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
    private var aliasText: String = ""
    
    public let reloadSignal = Variable((HCPatientItemModel(), [[HCListCellItem]]()))
    public let cellSelectedSignal = PublishSubject<HCListCellItem>()
    public let saveSignal = PublishSubject<(Bool?, String?)>()

    init(patientInfo: HCPatientItemModel) {
        super.init()
        
        self.patientInfo = patientInfo
        
        cellSelectedSignal
            .subscribe(onNext: { [unowned self] in
                if $0.title == "别名" {
                    HCPatientManageViewModel.push(HCEditInfoViewController.self,
                                                  ["mode": HCEditMode.alias, "content":self.patientInfo.bak])
                }else if $0.title == "分组" {
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
                            tempManageData[0][1].detailTitle = data.1
                        }else if tempManageData[0][1].detailTitle == data.1 {
                            tempManageData[0][1].detailTitle = ""
                        }
                        
                        strongSelf.reloadSignal.value = (strongSelf.patientInfo, tempManageData)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(NotificationName.User.EditAlias)
            .subscribe(onNext: { [weak self]  in
                if let strongSelf = self {
                    let tempManageData = strongSelf.reloadSignal.value.1
                    if let data = $0.object as? String {
                        strongSelf.aliasText = data
                        tempManageData[0][0].detailTitle = data
                        strongSelf.reloadSignal.value = (strongSelf.patientInfo, tempManageData)
                    }
                }
            })
            .disposed(by: disposeBag)

        saveSignal
            .subscribe(onNext: { [unowned self] in
                if $0.0 == nil && $0.1 == nil && aliasText.count == 0 { return }
                
                var needCommit: Bool = false
                var bakInfo = self.patientInfo.note
                var black = self.patientInfo.black
                
                if let isB = $0.0, isB != black {
                    needCommit = true
                    black = isB
                }
                
                if let note = $0.1, note != bakInfo {
                    needCommit = true
                    bakInfo = note
                }
                
                if aliasText.count > 0 {
                    needCommit = true
                }
                
                if needCommit {
                    self.requestUpdateConsultBlack(note: bakInfo, black: black)
                }
            })
            .disposed(by: disposeBag)
        
        reloadSubject
            .subscribe(onNext: { [weak self] in self?.requestConsultPatientInfo() })
            .disposed(by: disposeBag)
    }
    
    // 获取患者信息
    private func requestConsultPatientInfo() {
        prepareData(patientModel: nil)
        
        HCProvider.request(.getConsultPatientInfo(userId: HCHelper.share.userInfoModel?.uid ?? "", memberId: patientInfo.memberId))
            .map(model: HCPatientItemModel.self)
            .subscribe { [weak self] in
                self?.patientInfo.bak = $0.bak
                self?.patientInfo.black = $0.black
                self?.patientInfo.tagName = $0.tagName
                self?.patientInfo.note = $0.note
                self?.aliasText = $0.bak
                
                self?.prepareData(patientModel: $0)
            } onError: { _ in
                
            }
            .disposed(by: disposeBag)
    }
    
    // 修改患者设置
    private func requestUpdateConsultBlack(note: String, black: Bool) {
        hud.noticeLoading()
        HCProvider.request(.updateConsultBlack(memberId: patientInfo.memberId,
                                               userId: HCHelper.share.userInfoModel?.uid ?? "",
                                               bak: aliasText,
                                               black: black,
                                               consultId: patientInfo.consultId,
                                               note: note))
            .mapResponse()
            .subscribe { [weak self] res in
                if RequestCode(rawValue: res.code) == RequestCode.success {
                    self?.patientInfo.bak = self?.aliasText ?? ""
                    self?.patientInfo.black = black
                    self?.patientInfo.note = note
                    self?.hud.successHidden("更新成功")
                }else {
                    self?.hud.failureHidden(res.message)
                }
            } onError: { [weak self] in
                self?.hud.failureHidden(self?.errorMessage($0))
            }
            .disposed(by: disposeBag)

    }
}

extension HCPatientManageViewModel {
    
    private func prepareData(patientModel: HCPatientItemModel?) {
        var datas: [[HCListCellItem]] = []
        let titles: [[String]] = [["别名", "分组", "屏蔽"], ["备注"]]
        let identifiers: [[String]] = [[HCListDetailCell_identifier, HCListDetailCell_identifier, HCListSwitchCell_identifier], [HCListTextViewAndTitleCell_identifier]]
        let arrowShow: [[Bool]] = [[true, true, false], [false]]

        if let model = patientModel {
            for i in 0..<titles.count {
                var items: [HCListCellItem] = []
                for j in 0..<titles[i].count {
                    let m = HCListCellItem()
                    m.title = titles[i][j]
                    m.cellIdentifier = identifiers[i][j]
                    m.shwoArrow = arrowShow[i][j]
                        
                    if m.title == "别名" {
                        m.detailTitle = model.bak
                    }

                    if m.title == "分组" {
                        m.detailTitle = model.tagName
                    }
                                        
                    if m.title == "屏蔽" {
                        m.isOn = model.black
                    }
                    
                    if m.title == "备注" {
                        m.cellHeight = 200
                        m.detailTitle = model.note
                    }else {
                        m.cellHeight = 50
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
