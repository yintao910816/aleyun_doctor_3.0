//
//  HCConsultListViewModel.swift
//  HuChuangApp
//
//  Created by yintao on 2020/10/14.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

class HCConsultListViewModel: RefreshVM<HCConsultListItemModel> {
    
    override init() {
        super.init()
        
    }
    
    override func requestData(_ refresh: Bool) {
        super.requestData(refresh)
        
        HCProvider.request(.getPatientConsultList(pageNum: pageModel.currentPage, pageSize: pageModel.pageSize, sort: .increase, replyStatus: ""))
            .map(model: HCConsultListModel.self)
            .subscribe { [weak self] in
                self?.updateRefresh(refresh, $0.records, $0.pages)
            } onError: { [weak self] in
                self?.hud.failureHidden(self?.errorMessage($0))
                self?.revertCurrentPageAndRefreshStatus()
            }
            .disposed(by: disposeBag)
    }
}
