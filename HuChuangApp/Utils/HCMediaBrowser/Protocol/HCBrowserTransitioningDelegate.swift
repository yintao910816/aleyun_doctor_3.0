//
//  HCBrowserTransitioningDelegate.swift
//  HuChuangApp
//
//  Created by sw on 2021/1/17.
//  Copyright © 2021 sw. All rights reserved.
//

import Foundation

/// 转场动画代理
public protocol HCBrowserTransitioningDelegate: UIViewControllerTransitioningDelegate {
    
    /// 实现者应弱引用 PhotoBrowser，由 PhotoBrowser 初始化完毕后注入
    var browser: HCBrowserViewController? { set get }
    
    /// 蒙板 alpha 值
    var maskAlpha: CGFloat { set get }
}
