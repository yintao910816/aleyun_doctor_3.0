//
//  HCqueryScheduleConsultSettingViewModel.swift
//  HuChuangApp
//
//  Created by yintao on 2020/12/17.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

import RxSwift

class HCqueryScheduleConsultSettingViewModel: BaseViewModel {
    
    public let datasource = Variable([[Any]]())
    
    private var model: HCQueryPreciseScheduleModel!
    
    init(model: HCQueryPreciseScheduleModel) {
        super.init()
        
        self.model = model
        
        reloadSubject
            .subscribe(onNext: { [unowned self] in self.prepareData() })
            .disposed(by: disposeBag)
    }

}

extension HCqueryScheduleConsultSettingViewModel {
    
    private func prepareData() {
        let switchModel = HCListCellItem()
        switchModel.title = "精准预约开关"
        switchModel.shwoArrow = false
        switchModel.isOn = model.open
        switchModel.cellIdentifier = HCSwitchCollectionCell_identifier

        let priceModel = HCListCellItem()
        priceModel.title = "预约价格"
        priceModel.shwoArrow = false
        priceModel.inputSize = .init(width: 190, height: 30)
        priceModel.cellIdentifier = HCDetailTextFiledCollectionCell_identifier
        priceModel.detailInputTextAlignment = .right
        if model.price > 0 {
            priceModel.detailTitle = "\(model.price)"
        }else {
            priceModel.placeholder = "请输入"
        }
        
        let addressModel = HCListCellItem()
        addressModel.title = "坐诊地点"
        addressModel.shwoArrow = false
        addressModel.cellIdentifier = HCDetailCollectionCell_identifier
        addressModel.inputSize = .init(width: 190, height: 30)
        addressModel.cellIdentifier = HCDetailTextFiledCollectionCell_identifier
        addressModel.detailInputTextAlignment = .right
        if model.address.count > 0 {
            addressModel.detailTitle = model.address
        }else {
            addressModel.placeholder = "请输入"
        }
        
        let dateTup = TYDateCalculate.getDatesAndWeekDays(startDate: Date(),
                                                          endDate: TYDateCalculate.getDate(currentDate: Date(),
                                                                                           days: 6,
                                                                                           isAfter: true))
        var dayItems: [HCQueryScheduleSettingModel] = []
        for idx in 0..<dateTup.dates.count {
            let item = HCQueryScheduleSettingModel()
            item.date = dateTup.dates[idx].formatDate(mode: .yymmdd)
            item.week = dateTup.weeks[idx]
            
            let todayDate = TYDateCalculate.formatDate(date: Date())
            if todayDate.compare(dateTup.dates[idx]) == .orderedSame {
                item.isToday = true
            }

            if let m = model.scheduleList.first(where: { $0.subjectsDate == item.date }) {
                item.settingModel = m
            }
            
            dayItems.append(item)
        }


        datasource.value = [[switchModel], [priceModel], [addressModel], dayItems]
    }
}
