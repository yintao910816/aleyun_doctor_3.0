//
//  HCMyPatientViewModel.swift
//  HuChuangApp
//
//  Created by yintao on 2020/9/18.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class HCMyPatientViewModel: RefreshVM<HCPatientItemModel> {
    
    private var staticPaitentItems: [HCListCellItem] = []
    
    public let listSignal = PublishSubject<([HCPatientItemModel], [HCListCellItem])>()
    
    override init() {
        super.init()
        
        prepareStaticGroupData()
        
        reloadSubject
            .subscribe(onNext: { [unowned self] in
                self.listSignal.onNext(([], self.staticPaitentItems))
            })
            .disposed(by: disposeBag)
    }
    
    override func requestData(_ refresh: Bool) {
        super.requestData(refresh)
        
        HCProvider.request(.getConsultsPatientList(pageNum: pageModel.currentPage, pageSize: pageModel.pageSize, searchName: ""))
            .map(result: HCPatientListModel.self)
            .subscribe(onSuccess: { [weak self] data in
                guard let strongSelf = self else { return }
                strongSelf.updateRefresh(refresh, data.data?.records, data.data?.pages ?? 0)
                strongSelf.listSignal.onNext((strongSelf.datasource.value, strongSelf.staticPaitentItems))
                }, onError: { [weak self] _ in
                    self?.revertCurrentPageAndRefreshStatus()
            })
            .disposed(by: disposeBag)
    }
}

extension HCMyPatientViewModel {
    
    private func prepareStaticGroupData() {
        let titles: [String] = ["报到患者", "分组", "随访", "屏蔽患者"]
        let icons: [String] = ["patient_baodao", "patient_group", "patient_suifang", "patient_pinbi"]
        for idx in 0..<titles.count {
            let m = HCListCellItem()
            m.shwoArrow = false
            m.title = titles[idx]
            m.titleIcon = icons[idx]
            m.cellHeight = 55
            m.titleIconSize = .init(width: 33, height: 33)
            m.titleColor = RGB(12, 12, 12)
            m.titleFont = .font(fontSize: 16)
            staticPaitentItems.append(m)
        }
    }
}
