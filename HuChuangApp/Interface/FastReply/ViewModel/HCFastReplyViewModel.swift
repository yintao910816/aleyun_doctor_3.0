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
    
    override init() {
        super.init()
        
        reloadSubject
            .subscribe(onNext: { [weak self] in
                self?.datasource.value = HCFastReplyModel.creatTestDatas()
            })
            .disposed(by: disposeBag)
    }
}
