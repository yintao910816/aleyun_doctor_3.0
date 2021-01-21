//
//  HCBindPhoneViewModel.swift
//  HuChuangApp
//
//  Created by yintao on 2020/11/18.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class HCBindPhoneViewModel: BaseViewModel, VMNavigation {
    
    private var openId: String = ""

    public var enableCode: Driver<Bool>!
    
    init(input: Driver<String>, openId: String,
         tap:(codeTap: Driver<Void>,
              agreeTap: Driver<Bool>)) {
        super.init()
        
        self.openId = openId
        
        enableCode = input.map{ ValidateNum.phoneNum($0).isRight }
        
        let combineSignal = Driver.combineLatest(input, tap.agreeTap){ ($0, $1) }

        tap.codeTap.withLatestFrom(combineSignal)
            .filter({ data -> Bool in
                if !data.1 {
                    NoticesCenter.alert(message: "请阅读并勾选《用户协议》《隐私声明》")
                    return false
                }
                return true
            })
            ._doNext(forNotice: hud)
            .drive(onNext: { [weak self] in self?.requestCode(mobile: $0.0) })
            .disposed(by: disposeBag)
    }
}

extension HCBindPhoneViewModel {
    
    private func requestCode(mobile: String) {
        HCProvider.request(.validateCode(mobile: mobile))
            .mapResponse()
            .subscribe(onSuccess: { [weak self] res in
                guard let strongSelf = self else { return }
                if RequestCode(rawValue: res.code) == .success {
                    strongSelf.hud.noticeHidden()
                    HCBindPhoneViewModel.push(HCVerifyViewController.self, ["mobile": mobile,
                                                                            "openId":strongSelf.openId])
                }else {
                    strongSelf.hud.failureHidden(res.message)
                }
            }) { [weak self] in
                self?.hud.failureHidden(self?.errorMessage($0))
            }
            .disposed(by: disposeBag)
    }

}
