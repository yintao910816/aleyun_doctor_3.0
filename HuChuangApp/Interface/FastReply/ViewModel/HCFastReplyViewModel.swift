//
//  HCFastReplyViewModel.swift
//  HuChuangApp
//
//  Created by yintao on 2020/11/7.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation
import RxSwift

class HCFastReplyViewModel: BaseViewModel {
    
    public var datasource = Variable([HCFastReplyModel]())
    public let moveTopSignal = PublishSubject<IndexPath>()
    public let removeSignal = PublishSubject<IndexPath>()
    
    override init() {
        super.init()
        
        moveTopSignal
            .subscribe(onNext: { [unowned self] in
                if $0.row < datasource.value.count {
                    var datas = datasource.value
                    let id = datas[$0.row].id
                    
                    datas = datas.sorted(by: { (data1, data2) -> Bool in
                        if id == data1.id || id == data2.id {
                               return true
                         }
                         return false
                    })

                    datasource.value = datas
                }
            })
            .disposed(by: disposeBag)
        
        removeSignal
            .subscribe(onNext: { [unowned self] in
                if $0.row < datasource.value.count {
                    requestRemoveConsultTemplates(id: datasource.value[$0.row].id)
                }
            })
            .disposed(by: disposeBag)
        
        reloadSubject
            .subscribe(onNext: { [unowned self] in
                requestGetConsultTemplates()
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(NotificationName.FastReply.add, object: nil)
            .subscribe(onNext: { [weak self] _ in
                self?.requestGetConsultTemplates()
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(NotificationName.FastReply.edit, object: nil)
            .subscribe(onNext: { [weak self] _ in
                self?.requestGetConsultTemplates()
            })
            .disposed(by: disposeBag)
    }
    
    private func requestGetConsultTemplates() {
        HCProvider.request(.getConsultTemplates)
            .map(models: HCFastReplyModel.self)
            .subscribe { [weak self] in
                self?.datasource.value = $0
            } onError: { [weak self] in
                self?.hud.failureHidden(self?.errorMessage($0))
            }
            .disposed(by: disposeBag)
    }
    
    private func requestRemoveConsultTemplates(id: String) {
        hud.noticeLoading()
        HCProvider.request(.removeConsultTemplates(id: id))
            .mapResponse()
            .subscribe(onSuccess: { [weak self] in
                guard let strongSelf = self else { return }
                if $0.code == RequestCode.success.rawValue {
                    var datas = strongSelf.datasource.value
                    datas = datas.filter({ $0.id != id })
                    strongSelf.datasource.value = datas
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
