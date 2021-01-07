//
//  HCEditTagViewModel.swift
//  HuChuangApp
//
//  Created by yintao on 2020/9/19.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

class HCEditTagViewModel: BaseViewModel {
    
    private var patientGroup: HCPatientGroupListModel!
    
    public let removeTagSignal = PublishSubject<Void>()
    
    init(patientGroup: HCPatientGroupListModel, textDriver: Driver<String>, commitDriver: Driver<Void>) {
        super.init()
        
        self.patientGroup = patientGroup
        
        commitDriver.withLatestFrom(textDriver)
            .filter { value -> Bool in
                if value.count > 0 {
                    return true
                }
                NoticesCenter.alert(message: "标签内容不能为空")
                return false
        }
        .drive(onNext: { [unowned self] in self.requestEditUserMemberTags(tagName: $0) })
        .disposed(by: disposeBag)
        
        removeTagSignal
            .subscribe(onNext: { [unowned self] in requestRemoveUserTag() })
            .disposed(by: disposeBag)
    }
    
    private func requestEditUserMemberTags(tagName: String) {
        hud.noticeLoading()
        HCProvider.request(.editUserMemberTags(id: patientGroup.id, tagName: tagName))
            .map(result: HCTagNameModel.self)
            .subscribe(onSuccess: { [weak self] in
                if RequestCode(rawValue: $0.code) == .success {
                    self?.hud.noticeHidden()
                    HCDataObserCenter.share.tagEditSuccessSignal.onNext($0.data ?? HCTagNameModel())
                    self?.popSubject.onNext(Void())
                }else {
                    self?.hud.failureHidden($0.message)
                }
            }) { [weak self] in
                self?.hud.failureHidden(self?.errorMessage($0))
        }
        .disposed(by: disposeBag)
    }
    
    private func requestRemoveUserTag() {
        hud.noticeLoading()
        HCProvider.request(.removeUserTag(memberId: "", id: patientGroup.id))
            .mapResponse()
            .subscribe { [weak self] in
                if RequestCode(rawValue: $0.code) == .success {
                    HCDataObserCenter.share.tagRemoveSuccessSignal.onNext(self?.patientGroup.id ?? "")
                    self?.popSubject.onNext(Void())
                }else {
                    self?.hud.failureHidden($0.message)
                }
            } onError: { [weak self] in
                self?.hud.failureHidden(self?.errorMessage($0))
            }
            .disposed(by: disposeBag)
    }
}

class HCAddTagViewModel: BaseViewModel {
        
    init(textDriver: Driver<String>, commitDriver: Driver<Void>) {
        super.init()
                
        commitDriver.withLatestFrom(textDriver)
            .filter { value -> Bool in
                if value.count > 0 {
                    return true
                }
                NoticesCenter.alert(message: "标签内容不能为空")
                return false
        }
        .drive(onNext: { [unowned self] in self.requestAddUserMemberTags(tagName: $0) })
        .disposed(by: disposeBag)
    }
    
    private func requestAddUserMemberTags(tagName: String) {
        hud.noticeLoading()
        HCProvider.request(.addUserTag(tagName: tagName, clinicId: ""))
            .map(result: HCTagNameModel.self)
            .subscribe(onSuccess: { [weak self] in
                if RequestCode(rawValue: $0.code) == .success {
                    if let m = $0.data {
                        HCDataObserCenter.share.tagAddSuccessSignal.onNext(m)
                    }
                    self?.hud.noticeHidden()
                    self?.popSubject.onNext(Void())
                }else {
                    self?.hud.failureHidden($0.message)
                }
            }) { [weak self] in
                self?.hud.failureHidden(self?.errorMessage($0))
        }
        .disposed(by: disposeBag)
    }
}
