//
//  HCGroupManageViewModel.swift
//  HuChuangApp
//
//  Created by yintao on 2020/9/18.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

import RxSwift

class HCGroupManageViewModel: BaseViewModel {
    
    private var groupPatientDatas: [HCPatientGroupListModel] = []
    public let listSignal = PublishSubject<[[HCListCellItem]]>()
    
    init(groupPatientDatas: [HCPatientGroupListModel]) {
        super.init()
        
        self.groupPatientDatas = groupPatientDatas
        
        reloadSubject
            .subscribe(onNext: { [unowned self] in self.prepareCellData() })
            .disposed(by: disposeBag)
        
        HCDataObserCenter.share.tagEditSuccessSignal
            .subscribe(onNext: { [weak self] tagModel in
                guard let strongSelf = self else { return }
                strongSelf.groupPatientDatas = strongSelf.groupPatientDatas.map({ data -> HCPatientGroupListModel in
                    if data.id == tagModel.id {
                        data.tagName = tagModel.tagName
                    }
                    return data
                })
                strongSelf.prepareCellData()
            })
            .disposed(by: disposeBag)
    }
    
    private func prepareCellData() {
        var datas: [[HCListCellItem]] = []
        for idx in 0..<groupPatientDatas.count {
            let m = HCListCellItem()
            m.title = groupPatientDatas[idx].tagName
            m.detailTitle = "\(groupPatientDatas[idx].memberList.count)"
            m.cellHeight = 50
            m.cellIdentifier = HCListDetailCell_identifier
            datas.append([m])
        }
        
        listSignal.onNext(datas)
    }
}
