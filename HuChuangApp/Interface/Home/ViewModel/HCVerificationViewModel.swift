//
//  HCVerificationViewModel.swift
//  HuChuangApp
//
//  Created by sw on 2021/1/6.
//  Copyright © 2021 sw. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

class HCVerificationViewModel: RefreshVM<HCVerificationItemModel> {
    
    public let getVerificationByCodeSignal = PublishSubject<(Bool, String)>()
    public let scaanResultSignal = PublishSubject<(Bool, HCVerificationItemModel)>()

    override init() {
        super.init()
    }
    
    override func requestData(_ refresh: Bool) {
        super.requestData(refresh)
        
        getVerificationByCodeSignal
            ._doNext(forNotice: hud)
            .subscribe(onNext: { [unowned self] in requestGetVerificationByCode(verificationCode: $0.1, isPop: $0.0) })
            .disposed(by: disposeBag)
        
        HCProvider.request(.verificationList(pageNum: 1, pageSize: 10))
            .map(model: HCVerificationListModel.self)
            .subscribe { [weak self] in
                self?.updateRefresh(refresh, $0.records, $0.pages)
            } onError: { [weak self] in
                self?.hud.failureHidden(self?.errorMessage($0))
            }
            .disposed(by: disposeBag)
    }
    
}

extension HCVerificationViewModel {
    
    // 根据核销码查询核销信息
    private func requestGetVerificationByCode(verificationCode: String, isPop: Bool) {
        HCProvider.request(.getVerificationByCode(verificationCode: verificationCode))
            .map(model: HCVerificationItemModel.self)
            .subscribe { [weak self] in
                self?.hud.noticeHidden()
                self?.scaanResultSignal.onNext((isPop, $0))
            } onError: { [weak self] in
                self?.hud.failureHidden(self?.errorMessage($0))
            }
            .disposed(by: disposeBag)
    }
}

//MARK: 确认核销
class HCVerificationQueryViewModel: BaseViewModel {
    
    private var infoModel: HCVerificationItemModel!
    private var isSuccessQuery: Bool?
    
    public let verificationStatusSignal = PublishSubject<(Bool, String)>()
    public let reScanSignal = PublishSubject<Void>()

    init(infoModel: HCVerificationItemModel, queryTap: Driver<Void>) {
        super.init()
        
        self.infoModel = infoModel
        
        queryTap
            .drive(onNext: { [unowned self] in
                if isSuccessQuery == nil {
                    requestConfirmVerification()
                }else if isSuccessQuery == true {
                    popSubject.onNext(Void())
                }else {
                    reScanSignal.onNext(Void())
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func requestConfirmVerification() {
        hud.noticeLoading()
        HCProvider.request(.confirmVerification(verificationId: infoModel.id, consultId: infoModel.consultId))
            .mapResponse()
            .subscribe { [weak self] in
                self?.hud.noticeHidden()
                var flag = false
                if RequestCode(rawValue: $0.code) ==  .success {
                    flag = true
                    self?.isSuccessQuery = true
                }else {
                    self?.isSuccessQuery = false
                }
                self?.verificationStatusSignal.onNext((flag, $0.message))
            } onError: { [weak self] in
                self?.hud.noticeHidden()
                self?.isSuccessQuery = false
                self?.verificationStatusSignal.onNext((false, self?.errorMessage($0) ?? "无效码"))
            }
            .disposed(by: disposeBag)
    }
}
