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
    
    public let submitSubject = PublishSubject<[String: String]>()
    public let cancelScheduleSubject = PublishSubject<Void>()
    public let updateConsultUserStatusSubject = PublishSubject<Void>()
    
    init(model: HCConsultStatusModel) {
        super.init()
        
        self.model = model
        
        submitSubject
            .subscribe(onNext: { [unowned self] in self.requestAddVideoConsultSchedule(params: $0) })
            .disposed(by: disposeBag)
        
        cancelScheduleSubject
            .subscribe(onNext: { [unowned self] in self.requestDeleteVideoConsultSchedule() })
            .disposed(by: disposeBag)
        
        updateConsultUserStatusSubject
            .subscribe(onNext: { [unowned self] in self.requestUpdateConsultUserStatus() })
            .disposed(by: disposeBag)

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
//        priceModel.keyboardType = .decimalPad
        priceModel.keyboardType = .numbersAndPunctuation
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
            
            if idx == 0 {
                item.isSelected = true
            }
            
            dayItems.append(item)
        }
        
        datasource.value = [[switchModel], [priceModel], dayItems]
    }
    
    private func reloadDayItems(dateStr: String, updateParams: [String: Any]?) {
        let datas = datasource.value
        
        if let tempItems = datas[2] as? [HCVideoDaySettingModel],
           let dayItem = tempItems.first(where: { $0.date == dateStr }) {
         
            if let json = updateParams {
                if let model = JSONDeserializer<HCConsultDaySettingModel>.deserializeFrom(dict: json) {
                    dayItem.settingModel = model
                }
            }else {
                dayItem.settingModel = nil
            }

            datasource.value = datas
        }
    }
}

extension HCVideoConsultSettingViewModel {
    
    private func requestAddVideoConsultSchedule(params: [String: String]) {
        if let days = datasource.value[2] as? [HCVideoDaySettingModel],
           let selectedDay = days.first(where: { $0.isSelected == true }) {
            
            hud.noticeLoading()
            
            var postParams = params
            postParams["subjectsDate"] = selectedDay.date
            
            HCProvider.request(.addVideoConsultSchedule(params: postParams))
                .mapJSON()
                .subscribe(onSuccess: { [weak self] data in
                    guard let strongSelf = self else { return }
                    
                    if let jsonDic = data as? [String: Any] {
                        
                        if let code = jsonDic["code"] as? Int,
                           let resDic = jsonDic["data"] as? [String: Any],
                           code == RequestCode.success.rawValue {
                            
                            var tempDic = strongSelf.model.consultVideoUserSubjectTimeMap
                            tempDic[selectedDay.date.transform(mode: .newyymmdd)] = resDic
                            strongSelf.model.consultVideoUserSubjectTimeMap = tempDic
                            
                            strongSelf.reloadDayItems(dateStr: selectedDay.date, updateParams: resDic)
                            
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
    
    private func requestDeleteVideoConsultSchedule() {
        if let days = datasource.value[2] as? [HCVideoDaySettingModel],
           let selectedDay = days.first(where: { $0.isSelected == true }) {
            
            let key = selectedDay.date.transform(mode: .newyymmdd)
            if let dic = model.consultVideoUserSubjectTimeMap[key],
               let scheduleId = dic["id"] as? Int {
                
                hud.noticeLoading()
                HCProvider.request(.deleteVideoConsultSchedule(scheduleId: "\(scheduleId)"))
                    .mapResponse()
                    .subscribe(onSuccess: { [weak self] in
                        if $0.code == RequestCode.success.rawValue {
                            self?.model.consultVideoUserSubjectTimeMap[key] = nil
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
    
    private func requestUpdateConsultUserStatus() {
        if (datasource.value[1].first as! HCListCellItem).detailTitle.count == 0 {
            NoticesCenter.alert(message: "咨询价格不能为空")
            return
        }
        
        var spzx: [String: Any] = [:]
        var price = (datasource.value[1].first as! HCListCellItem).detailTitle
        price = price.replacingOccurrences(of: "元", with: "")
        spzx["isOpen"] = (datasource.value[0].first as! HCListCellItem).isOn
        spzx["price"] = price
        spzx["type"] = 2
        
        guard  let floatPrice = Float(price) else {
            NoticesCenter.alert(message: "请输入正确的价格")
            return
        }

        var schedule: [String: Any] = [:]
        if let days = datasource.value[2] as? [HCVideoDaySettingModel],
           let selectedDay = days.first(where: { $0.isSelected == true }),
           let dic = model.consultVideoUserSubjectTimeMap[selectedDay.date.transform(mode: .newyymmdd)],
           let m = JSONDeserializer<HCConsultDaySettingModel>.deserializeFrom(dict: dic) {
            schedule["subjectsDate"] = selectedDay.date
            schedule["startTime"] = m.startTime
            schedule["endTime"] = m.endTime
            schedule["recevieNum"] = m.recevieNum
        }else {
            hud.failureHidden("参数错误")
            return
        }
        
        hud.noticeLoading()
        let postParams = ["spzx": spzx, "schedule": schedule]
        HCProvider.request(.updateConsultUserStatus(params: postParams))
            .mapResponse()
            .subscribe(onSuccess: { [weak self] in
                guard let strongSelf = self else { return }
                if $0.code == RequestCode.success.rawValue {
                    strongSelf.model.price = floatPrice
                    strongSelf.model.isOpen = (strongSelf.datasource.value[0].first as! HCListCellItem).isOn
                    
                    NotificationCenter.default.post(name: NotificationName.ConsultSetting.videoSettingChanged,
                                                    object: strongSelf.model)

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
