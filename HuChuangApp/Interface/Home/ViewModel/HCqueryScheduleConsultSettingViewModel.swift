//
//  HCqueryScheduleConsultSettingViewModel.swift
//  HuChuangApp
//
//  Created by yintao on 2020/12/17.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

import HandyJSON
import RxSwift

class HCqueryScheduleConsultSettingViewModel: BaseViewModel {
    
    public let datasource = Variable([[Any]]())
    
    private var model: HCQueryPreciseScheduleModel!
    
    public let submitSubject = PublishSubject<[String: String]>()
    public let cancelScheduleSubject = PublishSubject<Void>()
    public let updateConsultUserStatusSubject = PublishSubject<Void>()

    init(model: HCQueryPreciseScheduleModel) {
        super.init()
        
        self.model = model
        
        submitSubject
            .subscribe(onNext: { [unowned self] in
                let datas = datasource.value
                if let tempItems = datas[3] as? [HCQueryScheduleSettingModel],
                   let dayItem = tempItems.first(where: { $0.isSelected == true }) {
                   
                    if dayItem.settingModel == nil {
                        requestAddPreciseSchedule(params: $0)
                    }else {
                        requestUpdateConsultUserStatus(params: $0)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        cancelScheduleSubject
            .subscribe(onNext: { [unowned self] in self.requestDelPreciseSchedule() })
            .disposed(by: disposeBag)

        updateConsultUserStatusSubject
            .subscribe(onNext: { [unowned self] in self.requestUpdateConsultUserStatus(params: nil) })
            .disposed(by: disposeBag)

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

            let dateS = dateTup.dates[idx].formatDate(mode: .newyymmdd)
            if let json = model.scheduleMap[dateS],
               let m = JSONDeserializer<HCQueryPreciseScheduleItemModel>.deserializeFrom(dict: json) {
                item.settingModel = m
            }
            
            if idx == 0 {
                item.isSelected = true
            }

            dayItems.append(item)
        }


        datasource.value = [[switchModel], [priceModel], [addressModel], dayItems]
    }
    
    private func reloadDayItems(dateStr: String, updateParams: [String: Any]?) {
        let datas = datasource.value
        
        if let tempItems = datas[3] as? [HCQueryScheduleSettingModel],
           let dayItem = tempItems.first(where: { $0.date == dateStr }) {
         
            if let json = updateParams {
                if let model = JSONDeserializer<HCQueryPreciseScheduleItemModel>.deserializeFrom(dict: json) {
                    dayItem.settingModel = model
                }
            }else {
                dayItem.settingModel = nil
            }

            datasource.value = datas
        }
    }
    
    private func reloadDayItems(dateStr: String) {
        let datas = datasource.value
        
        if let tempItems = datas[3] as? [HCQueryScheduleSettingModel],
           let dayItem = tempItems.first(where: { $0.date == dateStr }) {
         
            if let json = model.scheduleMap[dateStr.transform(mode: .newyymmdd)] {
                if let model = JSONDeserializer<HCQueryPreciseScheduleItemModel>.deserializeFrom(dict: json) {
             
                    dayItem.settingModel = model
                    datasource.value = datas
                }
            }
        }
    }

}

extension HCqueryScheduleConsultSettingViewModel {
    
    private func requestAddPreciseSchedule(params: [String: String]) {
        if let days = datasource.value[3] as? [HCQueryScheduleSettingModel],
           let selectedDay = days.first(where: { $0.isSelected == true }) {
            
            hud.noticeLoading()
            
            var postParams = params
            postParams["subjectsDate"] = selectedDay.date
            
            HCProvider.request(.addPreciseSchedule(params: postParams))
                .mapJSON()
                .subscribe(onSuccess: { [weak self] data in
                    guard let strongSelf = self else { return }
                    
                    if let jsonDic = data as? [String: Any] {
                        
                        if let code = jsonDic["code"] as? Int,
                           let resDic = jsonDic["data"] as? [String: Any],
                           code == RequestCode.success.rawValue {
                            
                            let key = selectedDay.date.transform(mode: .newyymmdd)
                            strongSelf.model.scheduleMap[key] = resDic
                            strongSelf.reloadDayItems(dateStr: selectedDay.date,
                                                      updateParams: resDic)
                            self?.hud.noticeHidden()
                        }else {
                            self?.hud.failureHidden(jsonDic["message"] as? String)
                        }
                    }else {
                        self?.hud.failureHidden("json解析失败")
                    }

                }) { [weak self] in
                    self?.hud.noticeLoading(self?.errorMessage($0))
                }
                .disposed(by: disposeBag)
        }else {
            hud.failureHidden("参数错误")
        }
    }
    
    private func requestDelPreciseSchedule() {
        if let days = datasource.value[3] as? [HCQueryScheduleSettingModel],
           let selectedDay = days.first(where: { $0.isSelected == true }) {

            let key = selectedDay.date.transform(mode: .newyymmdd)
            if let dic = model.scheduleMap[key],
               let scheduleId = dic["id"] as? Int {

                hud.noticeLoading()
                HCProvider.request(.delPreciseSchedule(scheduleId: "\(scheduleId)"))
                    .mapResponse()
                    .subscribe(onSuccess: { [weak self] in
                        if $0.code == RequestCode.success.rawValue {
                            self?.model.scheduleMap[key] = nil
                            self?.reloadDayItems(dateStr: selectedDay.date, updateParams: nil)
                            self?.hud.noticeHidden()
                        }else {
                            self?.hud.failureHidden($0.message)
                        }
                    }) { [weak self] in
                        self?.hud.failureHidden(self?.errorMessage($0))
                    }
                    .disposed(by: disposeBag)
            }else {
                hud.failureHidden("参数错误")
            }
        }else {
            hud.failureHidden("参数错误")
        }
    }
    
    private func requestUpdateConsultUserStatus(params: [String: Any]?) {
        var postParams: [String: [String: Any]] = [:]
        var dealPrice: Float = 0
        var dayKey: String = ""
        
        if let days = datasource.value[3] as? [HCQueryScheduleSettingModel],
           let selectedDay = days.first(where: { $0.isSelected == true }) {
            
            dayKey = selectedDay.date
            
            if var scheduleParams = params {
                scheduleParams["scheduleId"] = selectedDay.settingModel?.id ?? ""
                scheduleParams["subjectsDate"] = selectedDay.date

                postParams["schedule"] = scheduleParams
            }else {
                if let dic = model.scheduleMap[selectedDay.date.transform(mode: .newyymmdd)],
                   let m = JSONDeserializer<HCQueryPreciseScheduleItemModel>.deserializeFrom(dict: dic) {
                    var tempParams: [String: Any] = [:]
                    tempParams["scheduleId"] = m.id
                    tempParams["subjectsDate"] = selectedDay.date
                    tempParams["morningNum"] = m.morningNum
                    tempParams["afternoonNum"] = m.afternoonNum
                    
                    postParams["schedule"] = tempParams
                }else {
                    hud.failureHidden("参数错误")
                    return
                }
            }
            
            if (datasource.value[1].first as! HCListCellItem).detailTitle.count == 0 {
                NoticesCenter.alert(message: "咨询价格不能为空")
                return
            }
            
            var twzx: [String: Any] = [:]
            twzx["isOpen"] = (datasource.value[0].first as! HCListCellItem).isOn

            var price = (datasource.value[1].first as! HCListCellItem).detailTitle
            price = price.replacingOccurrences(of: "元", with: "")
            
            guard let floatPrice = Float(price) else {
                NoticesCenter.alert(message: "请输入正确的价格")
                return
            }
            dealPrice = floatPrice
            twzx["price"] = floatPrice

            twzx["address"] = (datasource.value[2].first as! HCListCellItem).detailTitle

            postParams["jzyy"] = twzx

        }else {
            hud.failureHidden("参数错误")
            return
        }

        hud.noticeLoading()
        HCProvider.request(.updateConsultUserStatus(params: postParams))
            .mapResponse()
            .subscribe(onSuccess: { [weak self] in
                guard let strongSelf = self else { return }
                if $0.code == RequestCode.success.rawValue {
                    if params == nil {
                        strongSelf.model.price = dealPrice
                        strongSelf.model.open = (strongSelf.datasource.value[0].first as! HCListCellItem).isOn
                        strongSelf.model.address = (strongSelf.datasource.value[2].first as! HCListCellItem).detailTitle
                    }else {
                        let key = dayKey.transform(mode: .newyymmdd)
                        strongSelf.model.scheduleMap[key]?["morningNum"] = params?["morningNum"]
                        strongSelf.model.scheduleMap[key]?["afternoonNum"] = params?["afternoonNum"]
                        strongSelf.reloadDayItems(dateStr: dayKey)
                    }

                    NotificationCenter.default.post(name: NotificationName.ConsultSetting.querySettingChanged, object: nil)
                    
                    strongSelf.hud.noticeHidden()
                }else {
                    strongSelf.hud.failureHidden($0.message)
                }
            }) { [weak self] in
                self?.hud.failureHidden(self?.errorMessage($0))
            }
            .disposed(by: disposeBag)

    }

}
