//
//  HCConsultListViewModel.swift
//  HuChuangApp
//
//  Created by yintao on 2020/10/14.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

import RxSwift

class HCConsultListViewModel: RefreshVM<HCConsultListItemModel> {
    
    private var sorted = HCRequestListSort.increase
    
    public let sortedSignal = PublishSubject<Bool>()

    override init() {
        super.init()
        
        sortedSignal
            .subscribe(onNext: { [unowned self] in
                sorted = $0 ? .increase : .decrease
                requestData(true)
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(NotificationName.Consult.statusChange, object: nil)
            .subscribe(onNext: { [weak self] _ in
                self?.requestData(true)
            })
            .disposed(by: disposeBag)
    }
    
    override func requestData(_ refresh: Bool) {
        super.requestData(refresh)
        
        if refresh {
            HCHelper.requestUnreplyNum()
        }
        
        HCProvider.request(.getPatientConsultList(pageNum: pageModel.currentPage, pageSize: pageModel.pageSize, sort: sorted, replyStatus: ""))
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
