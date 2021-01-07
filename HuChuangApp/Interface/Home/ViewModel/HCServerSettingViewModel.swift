//
//  HCServerSettingViewModel.swift
//  HuChuangApp
//
//  Created by yintao on 2020/12/17.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

import HandyJSON
import RxSwift

class HCServerSettingViewModel: BaseViewModel {
    
    public let openStatusModel = HCOpenConsultStatusModel()
    public var queryPreciseScheduleModel = HCQueryPreciseScheduleModel()
    
    public let datasource = Variable([HCServerSettingModel]())
    
    override init() {
        super.init()

        NotificationCenter.default.rx.notification(NotificationName.ConsultSetting.picSettingChanged, object: nil)
            .subscribe(onNext: { [weak self] in
                if let m = $0.object as? HCConsultStatusModel {
                    self?.openStatusModel.picModel = m
                    self?.prepareCellData(isFirst: false)
                }
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(NotificationName.ConsultSetting.videoSettingChanged, object: nil)
            .subscribe(onNext: { [weak self] in
                if let m = $0.object as? HCConsultStatusModel {
                    self?.openStatusModel.videoModel = m
                    self?.prepareCellData(isFirst: false)
                }
            })
            .disposed(by: disposeBag)

        NotificationCenter.default.rx.notification(NotificationName.ConsultSetting.querySettingChanged, object: nil)
            .subscribe(onNext: { [weak self] _ in
                self?.prepareCellData(isFirst: false)
            })
            .disposed(by: disposeBag)

        reloadSubject
            .subscribe(onNext: { [weak self] in
                self?.prepareCellData(isFirst: true)
                self?.requestData()
            })
            .disposed(by: disposeBag)
    }
    
    private func requestData() {
        hud.noticeLoading()
        Observable.combineLatest(requestGetOpenConsultStatus(),
                                 requestQueryPreciseSchedule()){ ($0, $1) }
            .subscribe(onNext: { [weak self] data in

                if let jsonDic = data.0 as? [String: Any] {
                    
                    if let code = jsonDic["code"] as? Int,
                       let resDic = jsonDic["data"] as? [String: Any],
                       code == RequestCode.success.rawValue {
                                                
                        if let smsNotice = resDic["smsNotice"] as? Bool  {
                            self?.openStatusModel.smsNotice = smsNotice
                        }
                        
                        if let picDic = resDic["ltzx"] as? [String: Any],
                           let model = JSONDeserializer<HCConsultStatusModel>.deserializeFrom(dict: picDic) {
                            self?.openStatusModel.picModel = model
                        }
                        
                        if let videoDic = resDic["spzx"] as? [String: Any],
                           let model = JSONDeserializer<HCConsultStatusModel>.deserializeFrom(dict: videoDic) {
                            self?.openStatusModel.videoModel = model
                        }

                    }else {
                        self?.hud.failureHidden(jsonDic["message"] as? String)
                        return
                    }
                }else {
                    self?.hud.failureHidden("json解析失败")
                    return
                }

                if let jsonDic = data.1 as? [String: Any] {
                    
                    if let code = jsonDic["code"] as? Int,
                       let resDic = jsonDic["data"] as? [String: Any],
                       code == RequestCode.success.rawValue {
                                                
                        if let price = resDic["price"] as? Float  {
                            self?.queryPreciseScheduleModel.price = price
                        }
                        
                        if let address = resDic["address"] as? String {
                            self?.queryPreciseScheduleModel.address = address
                        }

                        if let open = resDic["open"] as? Bool {
                            self?.queryPreciseScheduleModel.open = open
                        }
                        
                        if let scheduleMap = resDic["scheduleMap"] as? [String: [String : Any]] {
                            self?.queryPreciseScheduleModel.scheduleMap = scheduleMap
                        }
                    }else {
                        self?.hud.failureHidden(jsonDic["message"] as? String)
                        return
                    }
                }else {
                    self?.hud.failureHidden("json解析失败")
                    return
                }

                self?.prepareCellData(isFirst: false)
                
                self?.hud.noticeHidden()
            })
            .disposed(by: disposeBag)
    }
    
    private func requestGetOpenConsultStatus() ->Observable<Any> {
        return HCProvider.request(.getOpenConsultStatus)
            .mapJSON()
            .catchErrorJustReturn([:])
            .asObservable()
    }
    
    private func requestQueryPreciseSchedule() ->Observable<Any> {
        return HCProvider.request(.queryPreciseSchedule)
            .mapJSON()
            .catchErrorJustReturn([:])
            .asObservable()
    }
}

extension HCServerSettingViewModel {
    
    private func prepareCellData(isFirst: Bool) {
        if !isFirst {
            datasource.value = [HCServerSettingModel(icon: nil,
                                                     title: "图文咨询",
                                                     subTitle: "随时随地的快速高效为患者服务",
                                                     actionTitle: openStatusModel.picModel.isOpen == true ? "管理" : "马上开通",
                                                     isOpen: openStatusModel.picModel.isOpen),
                                HCServerSettingModel(icon: nil,
                                                     title: "视频咨询",
                                                     subTitle: "更加快速准确解决问题",
                                                     actionTitle: openStatusModel.videoModel.isOpen == true ? "管理" : "马上开通",
                                                     isOpen: openStatusModel.videoModel.isOpen),
                                HCServerSettingModel(icon: nil,
                                                     title: "精准预约",
                                                     subTitle: "方便患者在线预约您",
                                                     actionTitle: queryPreciseScheduleModel.open == true ? "管理" : "马上开通",
                                                     isOpen: queryPreciseScheduleModel.open)]
        }else {
            datasource.value = [HCServerSettingModel(icon: nil,
                                                     title: "图文咨询",
                                                     subTitle: "随时随地的快速高效为患者服务",
                                                     actionTitle: ""),
                                HCServerSettingModel(icon: nil,
                                                     title: "视频咨询",
                                                     subTitle: "更加快速准确解决问题",
                                                     actionTitle: ""),
                                HCServerSettingModel(icon: nil,
                                                     title: "精准预约",
                                                     subTitle: "方便患者在线预约您",
                                                     actionTitle: "")]
        }
    }
}
