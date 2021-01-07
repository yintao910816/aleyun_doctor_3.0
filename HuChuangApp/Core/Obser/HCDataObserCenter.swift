//
//  HCDataObserCenter.swift
//  HuChuangApp
//
//  Created by yintao on 2020/9/19.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

import RxSwift

class HCDataObserCenter {
    public static let share = HCDataObserCenter()
    
    /// 分组修改
    public let tagEditSuccessSignal = PublishSubject<HCTagNameModel>()
    /// 分组添加
    public let tagAddSuccessSignal = PublishSubject<HCTagNameModel>()
    /// 分组删除
    public let tagRemoveSuccessSignal = PublishSubject<String>()

    init() {
        
    }
}
