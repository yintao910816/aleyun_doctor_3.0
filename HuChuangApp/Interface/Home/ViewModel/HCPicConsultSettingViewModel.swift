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
    public let submitSubject = PublishSubject<[String: String]>()
    public let updateConsultUserStatusSubject = PublishSubject<Void>()

    private var model: HCConsultStatusModel!
    
    init(model: HCConsultStatusModel) {
        super.init()
        
        self.model = model
        
        submitSubject
            .subscribe(onNext: { [unowned self] in self.requestUpdateConsultUserStatus(params: $0) })
            .disposed(by: disposeBag)

        updateConsultUserStatusSubject
            .subscribe(onNext: { [unowned self] in
                let params = ["startTime": model.startTime, "endTime": model.endTime]
                requestUpdateConsultUserStatus(params: params)
            })
            .disposed(by: disposeBag)

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

        let smsSwitchModel = HCListCellItem()
        smsSwitchModel.title = "短信开关"
        smsSwitchModel.shwoArrow = false
        smsSwitchModel.isOn = model.smsNotice
        smsSwitchModel.cellIdentifier = HCSwitchCollectionCell_identifier

        let priceModel = HCListCellItem()
        priceModel.title = "图文咨询价格"
        priceModel.shwoArrow = false
        priceModel.inputSize = .init(width: 190, height: 30)
        priceModel.cellIdentifier = HCDetailTextFiledCollectionCell_identifier
        priceModel.detailInputTextAlignment = .right
        priceModel.keyboardType = .numbersAndPunctuation
        
        priceModel.detailTitle = "\(model.price)"
//        if model.price > 0 {
//            priceModel.detailTitle = "\(model.price)"
//        }else {
//            priceModel.placeholder = "请输入价格，建议30-40元"
//        }
        
        let timeModel = HCListCellItem()
        timeModel.title = "咨询时间"
        timeModel.detailTitle = ""
        if model.startTime.count > 0, model.endTime.count > 0 {
            timeModel.detailTitle = model.showTimeText
        }
        timeModel.cellIdentifier = HCDetailCollectionCell_identifier

        let unitModel = HCListCellItem()
        unitModel.title = "咨询回合数"
        unitModel.shwoArrow = false
        unitModel.inputSize = .init(width: 190, height: 30)
        unitModel.cellIdentifier = HCDetailTextFiledCollectionCell_identifier
        unitModel.detailInputTextAlignment = .right
        unitModel.keyboardType = .numberPad
        unitModel.placeholder = "请输入"
        unitModel.detailTitle = "\(model.unit)"

        
        datasource.value = [switchModel, smsSwitchModel, priceModel, timeModel, unitModel]
    }
}

extension HCPicConsultSettingViewModel {
    
    private func requestUpdateConsultUserStatus(params: [String: Any]) {
        if let startTime = params["startTime"], let endTime = params["endTime"] {
            let datas = datasource.value
            datas[3].detailTitle = "\(startTime)-\(endTime)"
            datasource.value = datas
        }
        
        var tempParams = params
        tempParams["open"] = datasource.value[0].isOn
        tempParams["smsNotice"] = datasource.value[1].isOn
        
        if datasource.value[2].detailTitle.count == 0 {
            NoticesCenter.alert(message: "咨询价格不能为空")
            return
        }

        guard let floatPrice = Float(datasource.value[2].detailTitle) else {
            NoticesCenter.alert(message: "请输入正确的价格")
            return
        }

        tempParams["price"] = floatPrice
        tempParams["type"] = 1
        if let unit = Int(datasource.value.last?.detailTitle ?? model.unit) {
            tempParams["unit"] = unit
        }else {
            tempParams["unit"] = model.unit
        }

        hud.noticeLoading()
        let postParams = ["ltzx": tempParams]
        HCProvider.request(.updateConsultUserStatus(params: postParams))
            .mapResponse()
            .subscribe(onSuccess: { [weak self] in
                guard let strongSelf = self else { return }
                if $0.code == RequestCode.success.rawValue {
                    strongSelf.model.isOpen = strongSelf.datasource.value[0].isOn
                    strongSelf.model.smsNotice = strongSelf.datasource.value[1].isOn
                    strongSelf.model.price = floatPrice
                    strongSelf.model.startTime = (params["startTime"] as? String) ?? ""
                    strongSelf.model.endTime = (params["endTime"] as? String) ?? ""

                    NotificationCenter.default.post(name: NotificationName.ConsultSetting.picSettingChanged, object: strongSelf.model)

                    strongSelf.hud.successHidden("保存成功")
                }else {
                    strongSelf.hud.failureHidden($0.message)
                }
            }) { [weak self] in
                self?.hud.failureHidden(self?.errorMessage($0))
            }
            .disposed(by: disposeBag)
    }
}
