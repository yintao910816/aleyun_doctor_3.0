//
//  HCBrowserZoomAnimator.swift
//  HuChuangApp
//
//  Created by sw on 2021/1/17.
//  Copyright © 2021 sw. All rights reserved.
//

import Foundation

/// Zoom动画命名空间
public class HCBrowserZoomAnimator: NSObject {
    /// 转场时做动画效果的视图
    public var zoomView: () -> UIView?
    
    /// 动画开始位置
    public var startFrame: (_ transContainer: UIView) -> CGRect?
    
    /// 动画结束位置
    public var endFrame: (_ transContainer: UIView) -> CGRect?
    
    /// 初始化，三个回调中，只要有一个返回nil值，就无法执行zoom动画，将转为执行Fade动画。
    public init(zoomView: @escaping () -> UIView?,
                startFrame: @escaping (_ superView: UIView) -> CGRect?,
                endFrame: @escaping (_ superView: UIView) -> CGRect?) {
        self.zoomView = zoomView
        self.startFrame = startFrame
        self.endFrame = endFrame
    }
}
