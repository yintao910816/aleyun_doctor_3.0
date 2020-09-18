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

class HCMyPatientViewModel: BaseViewModel {
    
    public let listSignal = PublishSubject<([HCPatientItemModel], [HCListCellItem])>()
    
    override init() {
        super.init()
        
        reloadSubject
            .subscribe(onNext: { [weak self] in
                self?.listSignal.onNext(([HCPatientItemModel()], self!.prepareStaticGroupData()))
            })
            .disposed(by: disposeBag)
    }
}

extension HCMyPatientViewModel {
    
    private func prepareStaticGroupData() ->[HCListCellItem] {
        let titles: [String] = ["报道患者", "分组", "随访", "屏蔽患者"]
        let icons: [String] = ["patient_baodao", "patient_group", "patient_suifang", "patient_pinbi"]
        var datas: [HCListCellItem] = []
        for idx in 0..<titles.count {
            let m = HCListCellItem()
            m.shwoArrow = false
            m.title = titles[idx]
            m.titleIcon = icons[idx]
            m.cellHeight = 55
            m.titleIconSize = .init(width: 33, height: 33)
            m.titleColor = RGB(12, 12, 12)
            m.titleFont = .font(fontSize: 16)
            datas.append(m)
        }
        
        return datas
    }
}
