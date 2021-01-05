//
//  HCPatientSearchViewModel.swift
//  HuChuangApp
//
//  Created by yintao on 2021/1/4.
//  Copyright © 2021 sw. All rights reserved.
//

import Foundation

import RxSwift

class HCPatientSearchViewModel: RefreshVM<HCPatientGroupListItemModel>, VMNavigation {
    
    private var searchWords: String = ""
    
    public let beginSearchSignal = PublishSubject<String>()
    public let selectedSignal = PublishSubject<HCPatientGroupListItemModel>()

    override init() {
        super.init()
        
        selectedSignal
            .subscribe(onNext: {
                HCPatientSearchViewModel.push(HCConsultDetailController.self,
                                              ["memberId": $0.memberId,
                                               "consultId": $0.consultId])
            })
            .disposed(by: disposeBag)
        
        beginSearchSignal
            .subscribe(onNext: { [unowned self] in
                searchWords = $0
                requestData(true)
            })
            .disposed(by: disposeBag)
    }
    
    override func requestData(_ refresh: Bool) {
        super.requestData(refresh)
        
        HCProvider.request(.consultSearch(searchWords: searchWords))
            .map(model: HCPatientSearchDataModel.self)
            .subscribe(onSuccess: { [weak self] in
                self?.updateRefresh(refresh, $0.memberLsit, 1)
            }) { [weak self] in
                self?.hud.failureHidden(self?.errorMessage($0))
            }
            .disposed(by: disposeBag)
    }
}
