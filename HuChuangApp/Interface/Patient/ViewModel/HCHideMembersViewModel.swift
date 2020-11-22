//
//  HCHideMembersViewModel.swift
//  HuChuangApp
//
//  Created by yintao on 2020/11/19.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

class HCHideMembersViewModel: RefreshVM<HCPatientItemModel> {
    
    override init() {
        super.init()
    }
    
    override func requestData(_ refresh: Bool) {
        super.requestData(refresh)
        
        HCProvider.request(.hieldMember(pageNum: pageModel.currentPage, pageSize: pageModel.pageSize))
            .map(result: HCHideMembersListModel.self)
            .subscribe(onSuccess: { [weak self] data in
                guard let strongSelf = self else { return }
                strongSelf.updateRefresh(refresh, data.data?.records, data.pages)
            }, onError: { [weak self] _ in
                self?.revertCurrentPageAndRefreshStatus()
            })
            .disposed(by: disposeBag)
    }
}
