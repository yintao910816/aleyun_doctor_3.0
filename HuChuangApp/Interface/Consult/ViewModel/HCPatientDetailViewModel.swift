//
//  HCPatientDetailViewModel.swift
//  HuChuangApp
//
//  Created by yintao on 2020/5/15.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

class HCPatientDetailViewModel: BaseViewModel {
    
    public let healthArchivesData = Variable([SectionModel<HCPatientDetailSectionModel, Any>]())
    public let healthArchivesExpand = PublishSubject<(Bool, Int)>()
    public let consultRecordData = Variable([HCConsultDetailItemModel]())
    public let manageData = Variable([HCListCellItem]())
    
    /// 图片回复
    public let sendImageSubject = PublishSubject<(UIImage, String)>()
    /// 语音回复
    public let sendAudioSubject = PublishSubject<(Data, UInt, String)>()
    /// 文字回复
    public let sendTextSubject = PublishSubject<(String, String)>()
    /// 退回
    public let sendBackSubject = PublishSubject<String>()
    
    /// 编辑备注
    public let didEndEditMakrSubject = PublishSubject<String>()
    /// 屏蔽患者
    public let blackPatientSubject = PublishSubject<Bool>()
    
    private var healthArchivesOriginalData: [[Any]] = []
    // 健康档案数据
    private var healthArchivesModel = HCHealthArchivesModel()
    // 周期档案数据
    private var circleOrignalData: [HCPatientCircleModel] = []
    
    private var memberId: String = ""
    
    init(memberId: String) {
        super.init()
        self.memberId = memberId
        
        healthArchivesExpand.subscribe(onNext: { [weak self] in
            guard let strongSelf = self else { return }
            var data = strongSelf.healthArchivesData.value
            if $0.0 {
                data[$0.1].model.isExpand = true
                data[$0.1].items = strongSelf.healthArchivesOriginalData[$0.1]
            }else {
                data[$0.1].model.isExpand = false
                if $0.1 == 0 {
                    data[0].items = Array(strongSelf.healthArchivesOriginalData[0][0..<5])
                }else {
                    if strongSelf.circleOrignalData.count > 0 {
                        data[1].items = Array(strongSelf.healthArchivesOriginalData[1][0..<1])
                    }else {
                        data[1].items = []
                    }
                }
            }
            strongSelf.healthArchivesData.value = data
        })
            .disposed(by: disposeBag)
        
        didEndEditMakrSubject
            .subscribe(onNext: { [unowned self] in self.updateConsultBlack(mark: $0) })
            .disposed(by: disposeBag)
        
        blackPatientSubject
            .subscribe(onNext: { [unowned self] in self.updateConsultBlack(black: $0) })
            .disposed(by: disposeBag)

        reloadSubject
            .subscribe(onNext: { [weak self] in
                self?.requestConsultRecords()
                self?.requestHealthArchives()
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(NotificationName.Patient.changedTagName)
            .subscribe(onNext: { [weak self]  in
                if let strongSelf = self {
                    var tempManageData = strongSelf.manageData.value
                    if let data = $0.object as? (Bool, String) {
                        if data.0 == false {
                            let model = HCListCellItem()
                            model.title = "分组"
                            model.detailTitle = data.1
                            model.titleColor = .black
                            model.cellIdentifier = HCListDetailCell_identifier
                            tempManageData[2] = model
//                            tempManageData[2] = HCListCellItem(title: "分组",
//                                                               detailTitle: data.1,
//                                                               titleColor: .black,
//                                                               cellIdentifier: HCListDetailCell_identifier,
//                                                               segue: "patientGroupSegue")
                        }else if tempManageData[2].detailTitle == data.1 {
                            let model = HCListCellItem()
                            model.title = "分组"
                            model.detailTitle = "请选择"
                            model.titleColor = .black
                            model.cellIdentifier = HCListDetailCell_identifier
                            tempManageData[2] = model
//                            tempManageData[2] = HCListCellItem(title: "分组",
//                                                               detailTitle: "请选择",
//                                                               titleColor: .black,
//                                                               cellIdentifier: HCListDetailCell_identifier,
//                                                               segue: "patientGroupSegue")
                        }
                        
                        strongSelf.manageData.value = tempManageData
                    }
                }
            })
            .disposed(by: disposeBag)
        
        prepareReply()
    }
    
    private func updateConsultBlack(mark: String) {
        if let item = consultRecordData.value.first {
            HCProvider.request(.updateConsultBlack(memberId: memberId, userId: item.userId, bak: mark, black: item.black))
                .mapResponse()
                .subscribe(onSuccess: { [weak self] res in
                    self?.consultRecordData.value.first?.bak = mark
                    PrintLog("修改备注结果：\(res.message)")
                }) { _ in }
                .disposed(by: disposeBag)
        }
    }
    
    private func updateConsultBlack(black: Bool) {
        if let item = consultRecordData.value.first {
            HCProvider.request(.updateConsultBlack(memberId: memberId, userId: item.userId, bak: item.bak, black: black))
                .mapResponse()
                .subscribe(onSuccess: { [weak self] res in
                    self?.consultRecordData.value.first?.black = black
                    PrintLog("屏蔽患者结果：\(res.message)")
                }) { _ in }
                .disposed(by: disposeBag)
        }
    }

    
    // 咨询记录
    private func requestConsultRecords() {
//        HCProvider.request(.getConsultDetail(memberId: memberId, id: ""))
//            .map(model: HCConsultDetailModel.self)
//            .map({ [weak self] data -> [HCConsultDetailItemModel] in
//                guard let strongSelf = self else { return [HCConsultDetailItemModel]() }
//                strongSelf.hud.noticeHidden()
//                return strongSelf.dealConsultRecords(data: data)
//            })
//            .asObservable()
//            .bind(to: consultRecordData)
//            .disposed(by: disposeBag)
    }
        
    private func requestHealthArchives() {
        let archivesSignal = HCProvider.request(.getHealthArchives(memberId: memberId))
            .map(model: HCHealthArchivesModel.self)
            .asObservable()
        let coupleInfoSignal = HCProvider.request(.getPatientCoupleInfo(memberId: memberId))
            .map(models: HCPatientCircleModel.self)
            .asObservable()
            .catchErrorJustReturn([])
        
        Observable.combineLatest(archivesSignal, coupleInfoSignal)
            .subscribe(onNext: { [weak self] data in
                self?.healthArchivesModel = data.0
                self?.circleOrignalData = data.1
                self?.prepareHealthArchivesOriginalData()
                
            }, onError: { [weak self] _ in self?.prepareHealthArchivesOriginalData() })
            .disposed(by: disposeBag)
    }
    
}

extension HCPatientDetailViewModel {
    
    private func dealConsultRecords(data: HCConsultDetailModel) ->[HCConsultDetailItemModel]{
        refreshPatientData(model: data.records.first)
        
        var tempData: [HCConsultDetailItemModel] = []
        for item in data.records {
            var consultList: [HCConsultDetailConsultListModel] = []
            // 时间cell
            let m = HCConsultDetailConsultListModel()
            m.cellIdentifier = HCConsultDetailTimeCell_identifier
            m.timeString = item.createDate.timeSeprate3()
            consultList.append(m)
            // 单次图文：内容加回复全显示，其它只显示咨询内容
            if let type = HCConsultType(rawValue: item.type), type == .picAndText {
                consultList.append(contentsOf: item.consultList)
            }else {
                if let firstConsult = item.consultList.first {
                    consultList.append(firstConsult)
                }
            }

//            item.calculateFooterUI()
            item.consultList = consultList
            tempData.append(item)
        }
        return tempData
    }

    private func prepareHealthArchivesOriginalData() {
        let firstSectionTitles = ["女方健康信息", "基本信息", "姓名", "身高", "体重", "月经史", "月经量", "是否痛经", "经期天数", "月经周期", "婚育史", "婚姻情况", "初/再婚几年", "未避孕未孕(年)", "是否有过怀孕", "人工流产", "宫外孕", "男方健康信息", "基本信息", "姓名", "身高", "体重"]
        let memberInfo = healthArchivesModel.memberInfo
        let menstruationHistory = healthArchivesModel.menstruationHistory
        let maritalHistory = healthArchivesModel.maritalHistory
        let firstSectionDetailTitles = ["","",memberInfo.nameW,memberInfo.heightW,memberInfo.weightW,"",menstruationHistory.catCatameniaAmount,menstruationHistory.catDysmenorrhea,menstruationHistory.catMensescycleDay,menstruationHistory.catMensescycleDay,"",maritalHistory.marReMarriage,maritalHistory.marReMarriageAge,maritalHistory.contraceptionNoPregnancyNo,maritalHistory.isPregnancy,maritalHistory.marDrugAbortion,maritalHistory.ectopicPregnancy,"","",memberInfo.nameM,memberInfo.heightM,memberInfo.weightM]
        var firstSectionDatas: [HCListCellItem] = []
        for idx in 0..<firstSectionTitles.count {
            let title = firstSectionTitles[idx]
            let detailTitle = firstSectionDetailTitles[idx]
            
            let model = HCListCellItem()
            model.cellHeight = 55
            model.title = title
            model.detailTitle = detailTitle
            model.cellIdentifier = HCListDetailCell_identifier
            model.shwoArrow = false
            model.titleFont = title.contains("健康信息") ? UIFont.font(fontSize: 17, fontName: .PingFMedium) : UIFont.font(fontSize: 16, fontName: .PingFRegular)
            if title.contains("女方健康信息") {
                model.titleColor = HC_MAIN_COLOR
                model.detailIcon = "record_icon_woman"
            }else if title.contains("男方健康信息") {
                model.titleColor = RGB(253, 119, 146)
                model.detailIcon = "record_icon_man"
            }else if title.contains("基本信息") || title.contains("月经史") || title.contains("婚育史") {
                model.titleColor = RGB(253, 153, 39)
            }else {
                model.titleColor = RGB(53, 53, 53)
            }
            firstSectionDatas.append(model)
        }
        healthArchivesOriginalData.append(firstSectionDatas)
        healthArchivesOriginalData.append(circleOrignalData)
        
        var secondData: [HCPatientCircleModel] = []
        if circleOrignalData.count > 0 {
            secondData.append(circleOrignalData.first!)
        }
        
        healthArchivesData.value = [SectionModel.init(model: HCPatientDetailSectionModel(title: "健康档案", isExpand: false),
                                                      items: Array(firstSectionDatas[0..<5])),
                                    SectionModel.init(model: HCPatientDetailSectionModel(title: "周期档案", isExpand: false),
                                                      items: secondData)]
    }
    
    private func refreshPatientData(model: HCConsultDetailItemModel?) {
        if let tempM = model {
            let bzModel = HCListCellItem()
            bzModel.title = "备注"
            bzModel.detailTitle = tempM.bak
            bzModel.titleColor = .black
            bzModel.placeholder = "请输入"
            bzModel.shwoArrow = false
            bzModel.cellIdentifier = HCListDetailInputCell_identifier

            let ageModel = HCListCellItem()
            ageModel.title = "年龄"
            ageModel.detailTitle = tempM.age
            ageModel.titleColor = .black
            ageModel.shwoArrow = false
            ageModel.cellIdentifier = HCListDetailCell_identifier

            let groupModel = HCListCellItem()
            groupModel.title = "分组"
            groupModel.detailTitle = tempM.tagName.count > 0 ? tempM.tagName : "请选择"
            groupModel.titleColor = .black
            groupModel.cellIdentifier = HCListDetailCell_identifier

            let pbModel = HCListCellItem()
            pbModel.title = "屏蔽该患者"
            pbModel.titleColor = .black
            pbModel.cellIdentifier = HCListSwitchCell_identifier
            pbModel.isOn = tempM.black
            
            manageData.value = [bzModel, ageModel, groupModel, pbModel]
        }else {
            let bzModel = HCListCellItem()
            bzModel.title = "备注"
            bzModel.detailTitle = ""
            bzModel.titleColor = .black
            bzModel.placeholder = "请输入"
            bzModel.shwoArrow = false
            bzModel.cellIdentifier = HCListDetailInputCell_identifier

            let ageModel = HCListCellItem()
            ageModel.title = "年龄"
            ageModel.detailTitle = ""
            ageModel.titleColor = .black
            ageModel.shwoArrow = false
            ageModel.cellIdentifier = HCListDetailCell_identifier

            let groupModel = HCListCellItem()
            groupModel.title = "分组"
            groupModel.detailTitle = "请选择"
            groupModel.titleColor = .black
            groupModel.cellIdentifier = HCListDetailCell_identifier

            let pbModel = HCListCellItem()
            pbModel.title = "屏蔽该患者"
            pbModel.titleColor = .black
            pbModel.cellIdentifier = HCListSwitchCell_identifier
            
            manageData.value = [bzModel, ageModel, groupModel, pbModel]
        }
    }

}

//MARK: - 单次图文回复
extension HCPatientDetailViewModel {

    private func prepareReply() {
        sendImageSubject
            ._doNext(forNotice: hud)
            .flatMap { [unowned self] data -> Observable<(HCFileUploadModel, String)> in
                if let imgData = data.0.jpegData(compressionQuality: 0.5) {
                    return self.uploadFile(data: imgData, type: .image)
                        .map{ ($0, data.1) }
                }
                return Observable.just((HCFileUploadModel(), data.1))
        }
        .concatMap { [weak self] data -> Observable<ResponseModel> in
            guard let strongSelf = self else { return Observable.just(ResponseModel()) }
            return strongSelf.submitReply(content: "", filePath: data.0.filePath, bak: "", id: data.1)
        }
        .subscribe(onNext: { [weak self] res in
            PrintLog("图片回复结果：\(res.message)")
            if RequestCode(rawValue: res.code) == RequestCode.success {
                self?.requestConsultRecords()
            }else {
                self?.hud.failureHidden(res.message)
            }
        })
            .disposed(by: disposeBag)
        
        sendAudioSubject
            ._doNext(forNotice: hud)
            .flatMap { [unowned self] data -> Observable<(HCFileUploadModel, UInt, String)> in
                return self.uploadFile(data: data.0, type: .audio)
                    .map{ ($0, data.1, data.2) }
        }
        .concatMap { [weak self] data -> Observable<ResponseModel> in
            guard let strongSelf = self else { return Observable.just(ResponseModel()) }
            return strongSelf.submitReply(content: "", filePath: data.0.filePath, bak: "\(data.1)", id: data.2)
        }
        .subscribe(onNext: { [weak self] res in
            PrintLog("语音回复结果：\(res.message)")
            if RequestCode(rawValue: res.code) == RequestCode.success {
                self?.requestConsultRecords()
            }else {
                self?.hud.failureHidden(res.message)
            }
        })
            .disposed(by: disposeBag)
        
        sendTextSubject
            ._doNext(forNotice: hud)
            .flatMap{ [unowned self] in self.submitReply(content: $0.0, filePath: "", bak: "", id: $0.1) }
            .subscribe(onNext: { [weak self] res in
                PrintLog("文字回复结果：\(res.message)")
                if RequestCode(rawValue: res.code) == RequestCode.success {
                    self?.requestConsultRecords()
                }else {
                    self?.hud.failureHidden(res.message)
                }
            })
            .disposed(by: disposeBag)
        
        sendBackSubject
            .subscribe(onNext: { [unowned self] in self.withdrawConsult(orderSn: $0) })
            .disposed(by: disposeBag)
    }
    
    /// 咨询退回
    private func withdrawConsult(orderSn: String) {
        hud.noticeLoading()
        HCProvider.request(.withdrawConsult(orderSn: orderSn))
            .mapResponse()
            .subscribe(onSuccess: { [weak self] res in
                if RequestCode(rawValue: res.code) == RequestCode.success {
                    self?.requestConsultRecords()
                }else {
                    self?.hud.failureHidden(res.message)
                }
            }) { [weak self] in
                self?.hud.failureHidden(self?.errorMessage($0))
        }
        .disposed(by: disposeBag)
    }
    
    private func uploadFile(data: Data, type: HCFileUploadType) ->Observable<HCFileUploadModel> {
        return HCProvider.request(.uploadFile(data: data, fileType: type))
            .map(model: HCFileUploadModel.self)
            .asObservable()
    }

    private func submitReply(content: String, filePath: String, bak: String, id: String) ->Observable<ResponseModel> {
        return HCProvider.request(.replyConsult(content: content, filePath: filePath, bak: bak, consultId: id))
            .mapResponse()
            .asObservable()
    }
}

struct HCPatientDetailSectionModel {
    var title: String = ""
    var isExpand: Bool = false
    
    var expandIcon: UIImage? {
        get {
            return isExpand ? UIImage(named: "btn_gray_up_arrow") : UIImage(named: "btn_gray_down_arrow")
        }
    }
    
    var expandTitle: String {
        get {
            return isExpand ? "收起" : "展开"
        }
    }
}
