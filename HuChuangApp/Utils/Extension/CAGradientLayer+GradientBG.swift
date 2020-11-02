//
//  CAGradientLayer+GradientBG.swift
//  HuChuangApp
//
//  Created by yintao on 2020/11/2.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

extension CAGradientLayer {
    
    /// 绘制渐变色背景
    public static func drawBg(with colors: [CGColor], gradientLocations: [NSNumber]) ->CAGradientLayer {
        let gradientColors: [CGColor] = colors
        let gradientLocations: [NSNumber] = gradientLocations

        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations

        return gradientLayer
    }
}
