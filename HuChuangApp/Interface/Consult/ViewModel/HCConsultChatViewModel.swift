//
//  HCConsultDetailViewModel.swift
//  HuChuangApp
//
//  Created by yintao on 2020/10/19.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

import Foundation
import RxDataSources
import RxSwift

class HCConsultChatViewModel: RefreshVM<SectionModel<HCChatDataModel, HCChatListModel>> {
    
    private var memberId: String = ""
    private var consultId: String = ""

    private var timer: Timer!

    /// 图片回复
    public let sendImageSubject = PublishSubject<UIImage>()
    /// 语音回复
    public let sendAudioSubject = PublishSubject<(Data, UInt)>()
    /// 文字回复
    public let sendTextSubject = PublishSubject<String>()
    /// 快捷回复
    public let sendFastReplySignal = PublishSubject<HCFastReplyModel>()
    /// 发起视频获取用户信息
    public let requestUserInfoSubject = PublishSubject<Void>()
    /// 用户信息获取完成
    public let getUerInfoSubject = PublishSubject<CallingUserModel>()

    /// 咨询退回
    public let cancelSignal = PublishSubject<Void>()

    /// 更新待接诊等待时间 - 等待时间已到期
    public let waitTimeSignal = PublishSubject<Bool>()
        
    init(memberId: String, consultId: String) {
        super.init()
        
        self.memberId = memberId
        self.consultId = consultId
        
        pageModel.pageSize = 1
        
        sendImageSubject
            ._doNext(forNotice: hud)
            .flatMap { [unowned self] image -> Observable<HCFileUploadModel> in
            if let data = image.jpegData(compressionQuality: 0.5) {
                return self.uploadFile(data: data, type: .image)
            }
            return Observable.just(HCFileUploadModel())
        }
        .concatMap { [weak self] file -> Observable<HCReplySuccessModel> in
            guard let strongSelf = self else { return Observable.just(HCReplySuccessModel()) }
            return strongSelf.submitReply(content: "", filePath: file.filePath, bak: "")
        }
        .subscribe(onNext: { [weak self] in
            PrintLog("图片回复成功")
            self?.dealReplySuccess(model: $0, contentMode: .image)
            self?.hud.noticeHidden()
        }, onError: { [weak self] in
            self?.hud.failureHidden(self?.errorMessage($0))
        })
            .disposed(by: disposeBag)
        
        sendAudioSubject
            ._doNext(forNotice: hud)
            .flatMap { [unowned self] data -> Observable<(HCFileUploadModel, UInt)> in
                return self.uploadFile(data: data.0, type: .audio)
                    .map{ ($0, data.1) }
            }
            .concatMap { [weak self] data -> Observable<HCReplySuccessModel> in
                guard let strongSelf = self else { return Observable.just(HCReplySuccessModel()) }
                return strongSelf.submitReply(content: "", filePath: data.0.filePath, bak: "\(data.1)")
            }
            .subscribe(onNext: { [weak self] in
                PrintLog("语音回复成功")
                self?.dealReplySuccess(model: $0, contentMode: .audio)
                self?.hud.noticeHidden()
            }, onError: { [weak self] in
                self?.hud.failureHidden(self?.errorMessage($0))
            })
            .disposed(by: disposeBag)
    
        sendTextSubject
            ._doNext(forNotice: hud)
            .flatMap{ [unowned self] in self.submitReply(content: $0, filePath: "", bak: "") }
            .subscribe(onNext: { [weak self] in
                PrintLog("文字回复成功")
                self?.dealReplySuccess(model: $0, contentMode: .text)
                self?.hud.noticeHidden()
            }, onError: { [weak self] in
                self?.hud.failureHidden(self?.errorMessage($0))
            })
            .disposed(by: disposeBag)
        
        sendFastReplySignal
            .subscribe { [unowned self] in
                submitFastReply(model: $0)
            }
            .disposed(by: disposeBag)
        
        requestUserInfoSubject
            .subscribe(onNext: { [unowned self] in self.requestShortUserInfo() })
            .disposed(by: disposeBag)
        
        cancelSignal
            .subscribe(onNext: { [unowned self] in
                requestWithdrawConsult()
            })
            .disposed(by: disposeBag)
        
        reloadSubject
            .subscribe(onNext: { [weak self] in self?.requestCurrentConsult() })
            .disposed(by: disposeBag)
    }
    
    public var consultMode: HCConsultType {
        get {
            if let sectionModel = datasource.value.last?.model.mainInfo,
               let status = HCConsultType(rawValue: sectionModel.consultType) {
                return status
            }
            
            return .chatConsult
        }
    }
    
    override func requestData(_ refresh: Bool) {
        HCProvider.request(.chatHistoryDetail(memberId: memberId,
                                              userId: HCHelper.share.userInfoModel?.uid ?? "",
                                              loadSize: pageModel.currentPage,
                                              consultType: HCConsultType.chatConsult.rawValue))
            .map(model: HCChatDataModel.self)
            .subscribe(onSuccess: { [weak self] in
                self?.pageModel.currentPage += 1
                self?.dealRequestData(refresh: false, data: $0)
            }) { [weak self] _ in
                self?.refreshStatus.value = .DropDownSuccess
        }
            .disposed(by: disposeBag)
    }
    
    private func requestShortUserInfo() {
        hud.noticeLoading()
        
        HCHelper.requestStartPhone(memberId: memberId)
            .flatMap { [weak self] res -> Observable<CallingUserModel?> in
                guard let strongSelf = self else { return Observable.just(nil) }
                if res {
                    return HCHelper.requestVideoCallUserInfo(memberId: strongSelf.memberId, consultId: strongSelf.consultId)
                }
                return Observable.just(nil)
            }
            .subscribe(onNext: { [weak self] user in
                if let callingUser = user {
                    self?.getUerInfoSubject.onNext(callingUser)
                }
                self?.hud.noticeHidden()
            })
            .disposed(by: disposeBag)
    }
}

//MARK: - 回复相关
extension HCConsultChatViewModel {
    
    /// 加载当前咨询的消息
    private func requestCurrentConsult() {
        HCProvider.request(.chatDetail(consultId: consultId))
            .map(model: HCChatDataModel.self)
            .subscribe { [weak self] in
                self?.dealRequestData(refresh: true, data: $0)
            } onError: { [weak self] in
                self?.revertCurrentPageAndRefreshStatus()
                self?.hud.failureHidden(self?.errorMessage($0))
            }
            .disposed(by: disposeBag)
    }
    
    // 咨询退回
    private func requestWithdrawConsult() {
        if let orderSn = datasource.value.last?.model.mainInfo.orderSn,
           orderSn.count > 0 {
            hud.noticeLoading()
            HCProvider.request(.withdrawConsult(orderSn: orderSn))
                .mapResponse()
                .subscribe(onSuccess: { [weak self] in
                    if $0.code == RequestCode.success.rawValue {
                        NotificationCenter.default.post(name: NotificationName.Consult.statusChange, object: nil)
                        self?.hud.noticeHidden()
                        self?.requestCurrentConsult()
                    }else {
                        self?.hud.failureHidden($0.message)
                    }
                }) { [weak self] in
                    self?.hud.failureHidden(self?.errorMessage($0))
                }
                .disposed(by: disposeBag)
        }
    }
    
    private func uploadFile(data: Data, type: HCFileUploadType) ->Observable<HCFileUploadModel> {
        return HCProvider.request(.uploadFile(data: data, fileType: type))
            .map(model: HCFileUploadModel.self)
            .asObservable()
    }

    private func submitReply(content: String, filePath: String, bak: String) ->Observable<HCReplySuccessModel> {
        return HCProvider.request(.replyConsult(content: content, filePath: filePath, bak: bak, consultId: consultId))
            .map(model: HCReplySuccessModel.self)
            .asObservable()
    }
    
    private func submitFastReply(model: HCFastReplyModel) {
        if model.imageList.count > 0 {
            for item in model.imageList {
                submitReply(content: "", filePath: item, bak: "")
                    .subscribe { [weak self] in
                        PrintLog("快捷回复成功")
                        self?.dealReplySuccess(model: $0, contentMode: .image)
                    } onError: { [weak self] in
                        self?.hud.failureHidden(self?.errorMessage($0))
                    }
                    .disposed(by: disposeBag)
            }
        }
        
        submitReply(content: model.content, filePath: "", bak: "")
            .subscribe { [weak self] in
                PrintLog("快捷回复成功")
                self?.dealReplySuccess(model: $0, contentMode: .text)
            } onError: { [weak self] in
                self?.hud.failureHidden(self?.errorMessage($0))
            }
            .disposed(by: disposeBag)
    }
}


/// 消息展示逻辑处理
extension HCConsultChatViewModel {
    
    private func dealReplySuccess(model: HCReplySuccessModel, contentMode: HCChatContentMode) {
        var datas = datasource.value
        if var items = datas.last?.items,
           let sectionModel = datas.last?.model {
            if sectionModel.mainInfo.status == HCOrderDetailStatus.unReplay.rawValue {
                NotificationCenter.default.post(name: NotificationName.Consult.statusChange, object: nil)
                sectionModel.mainInfo.status = HCOrderDetailStatus.replay.rawValue
            }
            items.append(model.transform(contentType: contentMode))
            datas = datas.dropLast()
            datas.append(SectionModel(model: sectionModel, items: items))
            datasource.value = datas
        }
    }

    private func dealRequestData(refresh: Bool, data: HCChatDataModel) {
        var sectionDatas: [SectionModel<HCChatDataModel, HCChatListModel>] = []
        
        var fileModels: [HCConsultDetailFileModel] = []
        for item in data.mainInfo.fileList {
            let m = HCConsultDetailFileModel()
            m.filePath = item
            fileModels.append(m)
        }
        data.mainInfo.fileListModel = fileModels
        
        sectionDatas.append(SectionModel(model: data, items: data.chatList))
        
        let status = HCOrderDetailStatus(rawValue: data.mainInfo.status)
        
        if status == .unReplay, refresh == true {
            if let startDate = data.mainInfo.createDate.stringFormatDate(mode: .yymmddhhmm) {
                
                let endDate = TYDateCalculate.getDate(currentDate: startDate,
                                                      days: 1,
                                                      isAfter: true)
                
                let compare = endDate.compare(Date())
                if compare == .orderedDescending {
                    sectionDatas.last?.model.mainInfo.isExpire = false
                    startTimer()
                }else {
                    sectionDatas.last?.model.mainInfo.isExpire = true
                }
            }
        }
        
        if refresh {
            updateRefresh(refresh, sectionDatas, data.pages)
        }else {
            refreshStatus.value = .DropDownSuccess
            
            var tempDatas = datasource.value
            tempDatas.insert(contentsOf: sectionDatas, at: 0)
            datasource.value = tempDatas
        }
        
        hud.noticeHidden()
    }
    
}

//MARK: 计时器
extension HCConsultChatViewModel {
    
    public func customDeinit() {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
    }

    private func startTimer() {
        if timer == nil {
            initTimer()
        }

        timer.fireDate = Date.distantPast
    }
    
    private func initTimer() {
        
        if #available(iOS 10.0, *) {
            timer = Timer.init(fire: Date.distantFuture,
                               interval: 60,
                               repeats: true,
                               block: { [unowned self] timer in
                                timerAction()
                               })
        } else {
            timer = Timer.init(fireAt: Date.distantFuture,
                               interval: 60,
                               target: self,
                               selector: #selector(timerAction),
                               userInfo: nil,
                               repeats: true)
            timer.fireDate = Date.distantFuture
        }
        
        RunLoop.main.add(timer, forMode: RunLoop.Mode.default)
    }
    
    @objc private func timerAction() {
        guard let model = datasource.value.last?.model else {
            customDeinit()
            return
        }
        var date: Date?
        if let d = model.mainInfo.createDate.stringFormatDate(mode: .yymmddhhmm) {
            date = d
        }else {
            if let d = model.mainInfo.createDate.stringFormatDate(mode: .yymmddhhmm) {
                date = d
            }else {
                customDeinit()
            }
        }

        if let aDate = date {
            var timeInterval = aDate.timeIntervalSince1970
            timeInterval += 60

            var endDate: Date?
            if let startDate = model.mainInfo.createDate.stringFormatDate(mode: .yymmddhhmm) {
                endDate = TYDateCalculate.getDate(currentDate: startDate, days: 1, isAfter: true)
            }else {
                if let startDate = model.mainInfo.createDate.stringFormatDate(mode: .yymmddhhmm) {
                    endDate = TYDateCalculate.getDate(currentDate: startDate, days: 1, isAfter: true)
                }
            }
            
            if let aEndDate = endDate {
                let endDateTimeInterval = aEndDate.timeIntervalSince1970
                if timeInterval >= endDateTimeInterval {
                    model.mainInfo.isExpire = true
                    waitTimeSignal.onNext(true)
                    customDeinit()
                }else {
                    model.mainInfo.isExpire = false
                    waitTimeSignal.onNext(false)
                }
            }else {
                waitTimeSignal.onNext(false)
            }
        }else {
            customDeinit()
        }
    }
}
