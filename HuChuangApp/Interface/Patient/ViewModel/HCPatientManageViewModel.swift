//
//  HCPatientManageViewModel.swift
//  HuChuangApp
//
//  Created by yintao on 2020/9/18.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

class HCPatientManageViewModel: BaseViewModel, VMNavigation {
    
    private var patientInfo: HCPatientItemModel!
    
    public let reloadSignal = PublishSubject<(HCPatientItemModel, [[HCListCellItem]])>()
    public let cellSelectedSignal = PublishSubject<HCListCellItem>()

    init(patientInfo: HCPatientItemModel) {
        super.init()
        
        self.patientInfo = patientInfo
        
        cellSelectedSignal
            .subscribe(onNext: { [unowned self] in
                if $0.title == "分组" {
                    HCPatientManageViewModel.push(HCEditPatientGroupController.self,
                                                  ["memberId": self.patientInfo.id])
                }
            })
            .disposed(by: disposeBag)
        
        reloadSubject
            .subscribe(onNext: { [weak self] in self?.prepareData() })
            .disposed(by: disposeBag)
    }
}

extension HCPatientManageViewModel {
    
    private func prepareData() {
        let titles: [[String]] = [["分组", "健康档案", "历史咨询", "随访", "屏蔽"], ["备注"]]
        let identifiers: [[String]] = [[HCBaseListCell_identifier, HCBaseListCell_identifier, HCBaseListCell_identifier, HCListSwitchCell_identifier, HCListSwitchCell_identifier], [HCListTextViewAndTitleCell_identifier]]
        let arrowShow: [[Bool]] = [[true, true, true, false, false], [false]]
        var datas: [[HCListCellItem]] = []
        for i in 0..<titles.count {
            var items: [HCListCellItem] = []
            for j in 0..<titles[i].count {
                let m = HCListCellItem()
                m.title = titles[i][j]
                m.cellIdentifier = identifiers[i][j]
                m.shwoArrow = arrowShow[i][j]
                
                if m.title == "备注" {
                    m.cellHeight = 200
                }else {
                    m.cellHeight = 50
                }
                
                items.append(m)
            }
            datas.append(items)
        }
        
        reloadSignal.onNext((patientInfo, datas))
    }
}
