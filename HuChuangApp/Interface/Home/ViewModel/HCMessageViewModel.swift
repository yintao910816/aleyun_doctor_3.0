//
//  HCMessageViewModel.swift
//  HuChuangApp
//
//  Created by yintao on 2020/8/23.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

class HCMessageViewModel: RefreshVM<HCMessageItemModel> {
    
    override init() {
        super.init()
    }
    
    override func requestData(_ refresh: Bool) {
        super.requestData(refresh)
        
        HCProvider.request(.messageCenter(pageNum: pageModel.currentPage, pageSize: pageModel.pageSize))
            .map(model: HCMessageListModel.self)
            .subscribe(onSuccess: { [weak self] in
                self?.updateRefresh(refresh, $0.records, $0.pages)
            }) { [weak self] _ in
                self?.revertCurrentPageAndRefreshStatus()
        }
        .disposed(by: disposeBag)
    }
}
