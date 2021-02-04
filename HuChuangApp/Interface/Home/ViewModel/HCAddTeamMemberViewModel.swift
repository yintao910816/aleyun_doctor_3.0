//
//  HCAddTeamMemberViewModel.swift
//  HuChuangApp
//
//  Created by sw on 2021/2/4.
//  Copyright © 2021 sw. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

class HCAddTeamMemberViewModel: RefreshVM<HCTeamItemModel> {
    
    private var searchWord: String = ""
    
    public let searchSignal = PublishSubject<String>()
    
    init(addTap: Driver<Void>) {
        super.init()
        
        searchSignal
            .subscribe(onNext: { [unowned self] in
                searchWord = $0
                requestData(true)
            })
            .disposed(by: disposeBag)
        
        addTap
            .drive(onNext: { [unowned self] in requestAddUserGroup() })
            .disposed(by: disposeBag)
    }
    
    override func requestData(_ refresh: Bool) {
        super.requestData(refresh)
        
        HCProvider.request(.selectUserGroupByParam(searchWord: searchWord, pageNum: pageModel.currentPage, pageSize: pageModel.pageSize))
            .map(model: HCTeamListModel.self)
            .subscribe(onSuccess: { [weak self] in
                self?.updateRefresh(refresh, $0.records, $0.pages)
            }) { [weak self] in
                self?.hud.failureHidden(self?.errorMessage($0))
                self?.revertCurrentPageAndRefreshStatus()
            }
            .disposed(by: disposeBag)
    }
    
    private func requestAddUserGroup() {
        
        let addUser = datasource.value.filter({ $0.isSelected == true })
        let ids = addUser.map{ $0.userId }
                
        if ids.count == 0 {
            NoticesCenter.alert(message: "请选择要添加的组员")
            return
        }
        
        hud.noticeLoading()
        HCProvider.request(.addUserGroup(ids: ids))
            .mapResponse()
            .subscribe(onSuccess: { [weak self] in
                if $0.code == RequestCode.success.rawValue {
                    HCDataObserCenter.share.addTeamMemberSuccessSignal.onNext(Void())
                    self?.hud.successHidden("添加成功", {
                        self?.popSubject.onNext(Void())
                    })
                }else {
                    self?.hud.failureHidden($0.message)
                }
            }, onError: { [weak self] in
                self?.hud.failureHidden(self?.errorMessage($0))
            })
            .disposed(by: disposeBag)
    }
}
