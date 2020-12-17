//
//  HCPicConsultSettingViewModel.swift
//  HuChuangApp
//
//  Created by yintao on 2020/12/17.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

import RxSwift

class HCPicConsultSettingViewModel: BaseViewModel {
    
    public let datasource = Variable([HCListCellItem]())
    
    private var model: HCConsultStatusModel!
    
    init(model: HCConsultStatusModel) {
        super.init()
        
        self.model = model
        
        reloadSubject
            .subscribe(onNext: { [unowned self] in self.prepareData() })
            .disposed(by: disposeBag)
    }
}

extension HCPicConsultSettingViewModel {
    
    private func prepareData() {
        let switchModel = HCListCellItem()
        switchModel.title = "咨询开关"
        switchModel.shwoArrow = false
        switchModel.isOn = model.isOpen
        switchModel.cellIdentifier = HCSwitchCollectionCell_identifier

        let priceModel = HCListCellItem()
        priceModel.title = "图文咨询价格"
        priceModel.shwoArrow = false
        priceModel.inputSize = .init(width: 190, height: 30)
        priceModel.cellIdentifier = HCDetailTextFiledCollectionCell_identifier
        priceModel.detailInputTextAlignment = .right
        if model.price > 0 {
            priceModel.detailTitle = "\(model.price)"
        }else {
            priceModel.placeholder = "请输入价格，建议30-40元"
        }
        
        let timeModel = HCListCellItem()
        timeModel.title = "咨询时间"
        timeModel.detailTitle = ""
        if model.startTime.count > 0, model.endTime.count > 0 {
            timeModel.detailTitle = "\(model.startTime)-\(model.endTime)"
        }
        timeModel.cellIdentifier = HCDetailCollectionCell_identifier

        
        datasource.value = [switchModel, priceModel, timeModel]
    }
}
