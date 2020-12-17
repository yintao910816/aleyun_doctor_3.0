//
//  HCVideoConsultSettingViewModel.swift
//  HuChuangApp
//
//  Created by yintao on 2020/12/17.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

import HandyJSON
import RxSwift

class HCVideoConsultSettingViewModel: BaseViewModel {
   
    public let datasource = Variable([[Any]]())
    
    private var model: HCConsultStatusModel!
    
    init(model: HCConsultStatusModel) {
        super.init()
        
        self.model = model
        
        reloadSubject
            .subscribe(onNext: { [unowned self] in self.prepareData() })
            .disposed(by: disposeBag)
    }
}

extension HCVideoConsultSettingViewModel {
    
    private func prepareData() {
        let switchModel = HCListCellItem()
        switchModel.title = "视频咨询开关"
        switchModel.shwoArrow = false
        switchModel.isOn = model.isOpen
        switchModel.cellIdentifier = HCSwitchCollectionCell_identifier

        let priceAtr = "咨询价格(元/15分钟)".attributed(.init(location: 4, length: 8), RGB(12, 12, 12), .font(fontSize: 12))
        let priceModel = HCListCellItem()
        priceModel.attrbuiteTitle = priceAtr
        priceModel.shwoArrow = false
        priceModel.cellIdentifier = HCDetailTextFiledCollectionCell_identifier
        priceModel.detailInputTextAlignment = .right
        if model.price > 0 {
            priceModel.detailTitle = "\(model.price)元"
        }else {
            priceModel.placeholder = "请输入"
        }
        
        let dateTup = TYDateCalculate.getDatesAndWeekDays(startDate: Date(),
                                                          endDate: TYDateCalculate.getDate(currentDate: Date(),
                                                                                           days: 6,
                                                                                           isAfter: true))
        var dayItems: [HCVideoDaySettingModel] = []
        for idx in 0..<dateTup.dates.count {
            let item = HCVideoDaySettingModel()
            item.date = dateTup.dates[idx].formatDate(mode: .yymmdd)
            item.week = dateTup.weeks[idx]
            
            let todayDate = TYDateCalculate.formatDate(date: Date())
            if todayDate.compare(dateTup.dates[idx]) == .orderedSame {
                item.isToday = true
            }
            
            let dateS = dateTup.dates[idx].formatDate(mode: .newyymmdd)
            if let json = model.consultVideoUserSubjectTimeMap[dateS],
               let m = JSONDeserializer<HCConsultDaySettingModel>.deserializeFrom(dict: json) {
                item.settingModel = m
            }
            
            dayItems.append(item)
        }
        
        datasource.value = [[switchModel], [priceModel], dayItems]
    }
    
}
