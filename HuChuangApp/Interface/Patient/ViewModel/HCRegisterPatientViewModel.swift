//
//  HCRegisterPatientViewModel.swift
//  HuChuangApp
//
//  Created by yintao on 2020/9/19.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation
import RxSwift

class HCRegisterPatientViewModel: RefreshVM<HCPatientItemModel> {
    
    override init() {
        super.init()
        
    }
    
    override func requestData(_ refresh: Bool) {
        super.requestData(refresh)
        
        updateRefresh(refresh, HCPatientItemModel.testDatas(), 1)
    }
}
