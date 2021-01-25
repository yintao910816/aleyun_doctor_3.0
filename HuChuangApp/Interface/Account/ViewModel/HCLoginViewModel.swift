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
    
    init(input: (phoneSignal: Driver<String>,
                 pwdSignal: Driver<String>),
         tap:(codeTap: Driver<Void>,
              agreeTap: Driver<Bool>,
              weChatTap: Driver<Void>,
              fastLoginTap: Driver<Void>),
         controller: UIViewController) {
        super.init()
        
        enableCode = Driver.combineLatest(input.phoneSignal, input.pwdSignal, loginModeSignal.asDriver()){ ($0, $1, $2) }
            .map({ ret -> Bool in
                if !ValidateNum.phoneNum(ret.0).isRight { return false }
                
                if ret.2 == .pwd {
                    if ret.1.count == 0 { return false }
                }

                return true
            })
            .asDriver()
                
        let combineSignal = Driver.combineLatest(input.phoneSignal, input.pwdSignal, loginModeSignal.asDriver(), tap.agreeTap){ ($0, $1, $2, $3) }
        
        tap.codeTap.withLatestFrom(combineSignal)
            .filter({ data -> Bool in
                if !data.3 {
                    NoticesCenter.alert(message: "请阅读并勾选《用户协议》《隐私声明》")
                    return false
                }
                return true
            })
            ._doNext(forNotice: hud)
            .drive(onNext: { [weak self] in
                if $0.2 == .phone {
                    self?.requestCode(mobile: $0.0)
                }else {
                    self?.requestPwdLogin(account: $0.0, psd: $0.1)
                }
            })
            .disposed(by: disposeBag)
        
        tap.weChatTap.asObservable()
            .subscribe(onNext: { [unowned self] in wchatLogin() })
            .disposed(by: disposeBag)

        weak var weakController = controller
        tap.fastLoginTap
            ._doNext(forNotice: hud)
            .drive(onNext: { [weak self] in
                guard let sc = weakController else { return }
                (UIApplication.shared.delegate as? HCAppDelegate)?.startUniLogin(viewController: sc, otherLoginCallBack: { [weak self] in
                    if $0.0 == .watchLogin {
                        self?.wchatLogin()
                    }else if $0.0 == .tokenLogin {
                        self?.requestTokenLogin(token: $0.1)
                    }
                }, presentCallBack: { [weak self] in
                    self?.hud.noticeHidden()
                })
            })
            .disposed(by: disposeBag)
    }
}

extension HCLoginViewModel {
    
    private func requestTokenLogin(token: String) {
        hud.noticeLoading()
        
        HCProvider.request(.tokenLogin(token: token))
            .map(result: HCUserModel.self)
            .subscribe { [weak self] in
                if let user = $0.data{
                    self?.hud.noticeHidden()
                    HCHelper.saveLogin(user: user)
                    self?.popSubject.onNext(Void())
                }else {
                    self?.hud.failureHidden($0.message)
                }
            } onError: { [weak self] in
                self?.hud.failureHidden(self?.errorMessage($0))
            }
            .disposed(by: disposeBag)
        
    }

    private func wchatLogin() {
        hud.noticeLoading()
        
        HCAccountManager.WeChatLogin()
            .do(onNext: { [weak self] UserInfoRes in
                if let _ = UserInfoRes {
                    self?.hud.noticeHidden()
                }else {
                    self?.hud.failureHidden("未获取到授权信息")
                }
            }, onError: { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
            })
            .filter{ $0 != nil }
            .map { $0! }
            .flatMap { [unowned self] in self.getAuthMemberInfoRequest(socialInfo: $0) }
            .subscribe(onNext: { [weak self] data in
                if data.0.code == RequestCode.unBindPhone.rawValue {
                    if let openId = data.1.openid, openId.count > 0 {
                        self?.hud.noticeHidden()
                        HCLoginViewModel.push(HCBindPhoneController.self, ["openId":data.1.openid ?? ""])
                    }else {
                        self?.hud.failureHidden("openId为空")
                    }
                }else if let user = data.0.data{
                    self?.hud.noticeHidden()
                    HCHelper.saveLogin(user: user)
                    self?.popSubject.onNext(Void())
                }else {
                    self?.hud.failureHidden("未获取到用户信息")
                }
            }, onError: { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
            })
            .disposed(by: disposeBag)
    }

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
                        HCHelper.share.isPresentLogin = false
                    }
                }else {
                    self?.hud.failureHidden($0.message)
                }
            }) { [weak self] in
                self?.hud.failureHidden(self?.errorMessage($0))
            }
            .disposed(by: disposeBag)
    }

    private func getAuthMemberInfoRequest(socialInfo: UMSocialUserInfoResponse) ->Observable<(DataModel<HCUserModel>,UMSocialUserInfoResponse)>
    {
        return HCProvider.request(.getAuthMember(openId: socialInfo.openid))
            .map(result: HCUserModel.self)
            .map { ($0, socialInfo) }
            .asObservable()
    }

}
