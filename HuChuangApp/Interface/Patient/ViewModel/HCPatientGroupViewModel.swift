//
//  HCPatientGroupViewModel.swift
//  HuChuangApp
//
//  Created by yintao on 2020/9/18.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

import RxSwift

class HCPatientGroupViewModel: RefreshVM<HCPatientGroupListModel> {
        
    override init() {
        super.init()
        
        requestData(true)
    }

    override func requestData(_ refresh: Bool) {
        super.requestData(refresh)
        
        HCProvider.request(.groupTagMemberList)
            .map(models: HCPatientGroupListModel.self)
            .subscribe(onSuccess: { [weak self] in
                self?.updateRefresh(refresh, $0, $0.count)
            }) { [weak self] in
                self?.hud.failureHidden(self?.errorMessage($0))
                self?.revertCurrentPageAndRefreshStatus()
        }
        .disposed(by: disposeBag)
    }
}
