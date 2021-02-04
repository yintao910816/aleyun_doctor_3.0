//
//  HCTeamViewModeel.swift
//  HuChuangApp
//
//  Created by sw on 2021/2/4.
//  Copyright © 2021 sw. All rights reserved.
//

import Foundation

import RxSwift

class HCTeamViewModel: BaseViewModel {
    
    override init() {
        super.init()
        

    }
}

//MARK: 我的团队
class HCMyTeamViewModel: RefreshVM<HCTeamItemModel> {
    
    public let errorSingle = PublishSubject<String>()
    public let deleteSignal = PublishSubject<String>()

    override init() {
        super.init()
        
        deleteSignal
            ._doNext(forNotice: hud)
            .subscribe(onNext: { [unowned self] in requestDelUserGroup(userId: $0) })
            .disposed(by: disposeBag)
        
        HCDataObserCenter.share.addTeamMemberSuccessSignal
            .subscribe(onNext: { [weak self] in
                self?.requestData(true)
            })
            .disposed(by: disposeBag)
    }
    
    override func requestData(_ refresh: Bool) {
        super.requestData(refresh)
        
        HCProvider.request(.selectUserGroupPage(pageNum: pageModel.currentPage, pageSize: pageModel.pageSize))
            .map(model: HCTeamListModel.self)
            .subscribe { [weak self] in
                self?.updateRefresh(refresh, $0.records, $0.pages)
            } onError: { [weak self] in
                if let data = self?.errorInfo($0), data.0 == 400 {
                    self?.errorSingle.onNext(data.1)
                }else {
                    self?.hud.failureHidden(self?.errorMessage($0))
                }
                self?.revertCurrentPageAndRefreshStatus()
            }
            .disposed(by: disposeBag)
    }
    
    private func requestDelUserGroup(userId: String) {
        HCProvider.request(.delUserGroup(userId: userId))
            .mapResponse()
            .subscribe(onSuccess: { [weak self] in
                guard let self = self else { return }
                if $0.code == RequestCode.success.rawValue {
                    let datas = self.datasource.value.filter({ $0.userId != userId })
                    self.datasource.value = datas
                    self.hud.noticeHidden()
                }else {
                    self.hud.failureHidden($0.message)
                }
            }) { [weak self] in
                self?.hud.failureHidden(self?.errorMessage($0))
            }
            .disposed(by: disposeBag)
    }
}

//MARK: 我所在的团队
class HCTeamContainMeViewModel: RefreshVM<HCTeamItemModel> {
    
    override init() {
        super.init()
    }
    
    override func requestData(_ refresh: Bool) {
        super.requestData(refresh)
        
        HCProvider.request(.myInGroupPage(pageNum: pageModel.currentPage, pageSize: pageModel.pageSize))
            .map(model: HCTeamListModel.self)
            .subscribe { [weak self] in
                self?.updateRefresh(refresh, $0.records, $0.pages)
            } onError: { [weak self] in
                self?.hud.failureHidden(self?.errorMessage($0))
                self?.revertCurrentPageAndRefreshStatus()
            }
            .disposed(by: disposeBag)

    }
}
