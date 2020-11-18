//
//  HCLoginViewModel.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/7.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

class HCLoginViewModel: BaseViewModel, VMNavigation {
    
    public var enableCode: Driver<Bool>!
    public let loginModeSignal = Variable(HCLoginMode.phone)
    
    init(input: (phoneSignal: Driver<String>, pwdSignal: Driver<String>),
         tap:(codeTap: Driver<Void>, agreeTap: Driver<Bool>)) {
        super.init()
        
        enableCode = Driver.combineLatest(input.phoneSignal, input.pwdSignal, tap.agreeTap, loginModeSignal.asDriver()){ ($0, $1, $2, $3) }
            .map({ ret -> Bool in
                if !ValidateNum.phoneNum(ret.0).isRight { return false }
                if !ret.2 { return false }
                
                if ret.3 == .pwd {
                    if ret.1.count == 0 { return false }
                }

                return true
            })
            .asDriver()
                
        let combineSignal = Driver.combineLatest(input.phoneSignal, input.pwdSignal, loginModeSignal.asDriver()){ ($0, $1, $2) }
        
        tap.codeTap.withLatestFrom(combineSignal)
            ._doNext(forNotice: hud)
            .drive(onNext: { [weak self] in
                if $0.2 == .phone {
                    self?.requestCode(mobile: $0.0)
                }else {
                    self?.requestPwdLogin(account: $0.0, psd: $0.1)
                }
            })
            .disposed(by: disposeBag)
    }
}

extension HCLoginViewModel {
    
    private func requestCode(mobile: String) {
        #if DEBUG
        hud.noticeHidden()
        HCLoginViewModel.push(HCVerifyViewController.self, ["mobile": mobile])
        #else
        HCProvider.request(.validateCode(mobile: mobile))
            .mapResponse()
            .subscribe(onSuccess: { [weak self] res in
                if RequestCode(rawValue: res.code) == .success {
                    self?.hud.noticeHidden()
                    HCLoginViewModel.push(HCVerifyViewController.self, ["mobile": mobile])
                }else {
                    self?.hud.failureHidden(res.message)
                }
            }) { [weak self] in
                self?.hud.failureHidden(self?.errorMessage($0))
        }
        .disposed(by: disposeBag)
        #endif
    }
    
    private func requestPwdLogin(account: String, psd: String) {
        HCProvider.request(.pwdLogin(account: account, psd: psd))
            .map(result: HCUserModel.self)
            .subscribe(onSuccess: { [weak self] in
                if RequestCode(rawValue: $0.code) == .unVerified {
                    if let user = $0.data {
                        self?.hud.noticeHidden()
                        HCHelper.saveLogin(user: user)
                    }
                    HCLoginViewModel.push(HCRealNameAuthorViewController.self, nil)
                }else if RequestCode(rawValue: $0.code) == .success {
                    if let user = $0.data {
                        self?.hud.noticeHidden()
                        self?.popSubject.onNext(Void())
                        HCHelper.saveLogin(user: user)
                    }
                }else {
                    self?.hud.failureHidden($0.message)
                }
            }) { [weak self] in
                self?.hud.failureHidden(self?.errorMessage($0))
            }
            .disposed(by: disposeBag)
    }

}
