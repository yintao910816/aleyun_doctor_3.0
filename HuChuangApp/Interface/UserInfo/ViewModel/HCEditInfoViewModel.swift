//
//  HCEditInfoViewModel.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/13.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

class HCEditInfoViewModel: BaseViewModel {
    
    public let enableSignal = PublishSubject<Bool>()
    public let contentSignal = PublishSubject<String>()
    
    private var mode: HCEditMode = .nickName

    init(inputSignal: Driver<String>, commitSignal: Driver<Void>, mode: HCEditMode) {
        super.init()
        
        self.mode = mode
        
        inputSignal.map { $0.count > 0 }
            .drive(enableSignal)
            .disposed(by: disposeBag)
        
        commitSignal.withLatestFrom(inputSignal)
            .drive(onNext: { [unowned self] in
                switch self.mode {
                case .nickName:
                    self.requestUpdateNickName(nickName: $0)
                case .alias:
                    NotificationCenter.default.post(name: NotificationName.User.EditAlias, object: $0)
                    self.popSubject.onNext(Void())
                }
            })
            .disposed(by: disposeBag)
        
        switch mode {
        case .nickName:
            reloadSubject
                .subscribe(onNext: { [weak self] in
                    let content = HCHelper.share.userInfoModel?.name ?? ""
                    self?.contentSignal.onNext(content)
                    self?.enableSignal.onNext(content.count > 0)
                })
                .disposed(by: disposeBag)
        default:
            break
        }
    }
}

extension HCEditInfoViewModel {
    
    private func requestUpdateNickName(nickName: String) {
        guard let user = HCHelper.share.userInfoModel else {
            hud.failureHidden("用户信息获取失败，请重新登录") {
                HCHelper.presentLogin()
            }
            return
        }

        hud.noticeLoading()
        HCProvider.request(.accountSetting(nickName: nickName, headPath: user.headPath))
            .map(model: HCUserModel.self)
            .subscribe(onSuccess: { [weak self] in
                HCHelper.saveLogin(user: $0)
                self?.hud.noticeHidden()
                self?.popSubject.onNext(Void())
            }) { [weak self] in
                self?.hud.failureHidden(self?.errorMessage($0))
        }
        .disposed(by: disposeBag)
    
    }
}
