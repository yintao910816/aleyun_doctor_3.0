//
//  Array+Extension.swift
//  HuChuangApp
//
//  Created by yintao on 2020/12/28.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

extension Array {
    
    /// 交换数组两个元素的位置
    public static func exchangeValue<T>(_ nums: inout [T], _ a: Int, _ b: Int) {
        (nums[a], nums[b]) = (nums[b], nums[a])
    }
}

