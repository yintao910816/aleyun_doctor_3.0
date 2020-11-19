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
    
    public let reloadSignal = Variable((HCPatientItemModel(), [[HCListCellItem]]()))
    public let cellSelectedSignal = PublishSubject<HCListCellItem>()

    init(patientInfo: HCPatientItemModel) {
        super.init()
        
        self.patientInfo = patientInfo
        
        cellSelectedSignal
            .subscribe(onNext: { [unowned self] in
                if $0.title == "分组" {
                    HCPatientManageViewModel.push(HCEditPatientGroupController.self,
                                                  ["memberId": self.patientInfo.memberId])
                }
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(NotificationName.Patient.changedTagName)
            .subscribe(onNext: { [weak self]  in
                if let strongSelf = self {
                    let tempManageData = strongSelf.reloadSignal.value.1
                    if let data = $0.object as? (Bool, String) {
                        if data.0 == false {
                            tempManageData[0][0].detailTitle = data.1
                        }else if tempManageData[0][0].detailTitle == data.1 {
                            tempManageData[0][0].detailTitle = ""
                        }
                        
                        strongSelf.reloadSignal.value = (strongSelf.patientInfo, tempManageData)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        reloadSubject
            .subscribe(onNext: { [weak self] in self?.requestConsultPatientInfo() })
            .disposed(by: disposeBag)
    }
    
    private func requestConsultPatientInfo() {
        prepareData(patientModel: nil)
        
        HCProvider.request(.getConsultPatientInfo(userId: HCHelper.share.userInfoModel?.uid ?? "", memberId: patientInfo.memberId))
            .map(model: HCPatientItemModel.self)
            .subscribe { [weak self] in
                self?.patientInfo.bak = $0.bak
                self?.patientInfo.black = $0.black
                self?.patientInfo.tagName = $0.tagName

                self?.prepareData(patientModel: $0)
            } onError: { _ in
                
            }
            .disposed(by: disposeBag)
    }
}

extension HCPatientManageViewModel {
    
    private func prepareData(patientModel: HCPatientItemModel?) {
        var datas: [[HCListCellItem]] = []
        let titles: [[String]] = [["分组", "健康档案", "历史咨询", "随访", "屏蔽"], ["备注"]]
        let identifiers: [[String]] = [[HCListDetailCell_identifier, HCBaseListCell_identifier, HCBaseListCell_identifier, HCListSwitchCell_identifier, HCListSwitchCell_identifier], [HCListTextViewAndTitleCell_identifier]]
        let arrowShow: [[Bool]] = [[true, true, true, false, false], [false]]

        if let model = patientModel {
            for i in 0..<titles.count {
                var items: [HCListCellItem] = []
                for j in 0..<titles[i].count {
                    let m = HCListCellItem()
                    m.title = titles[i][j]
                    m.cellIdentifier = identifiers[i][j]
                    m.shwoArrow = arrowShow[i][j]
                    
                    if m.title == "备注" {
                        m.cellHeight = 200
                        m.detailTitle = model.bak
                    }else {
                        m.cellHeight = 50
                    }
                    
                    if m.title == "分组" {
                        m.detailTitle = model.tagName
                    }
                    
                    if m.title == "屏蔽" {
                        m.isOn = model.black
                    }
                                        
                    items.append(m)
                }
                datas.append(items)
            }
        }else {
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
        }
        
        reloadSignal.value = (patientInfo, datas)
    }
}
