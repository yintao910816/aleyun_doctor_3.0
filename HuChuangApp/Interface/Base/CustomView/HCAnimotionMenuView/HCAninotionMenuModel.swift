//
//  HCAninotionMenuModel.swift
//  HuChuangApp
//
//  Created by sw on 2020/9/4.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

enum HCAninotionMenuStatus {
    case normal
    case selected
    
    public var titleColor: UIColor {
        get {
            switch self {
            case .normal:
                return RGB(12, 12, 12)
            case .selected:
                return RGB(75, 138, 239)
            }
        }
    }
    
    public var titleFont: UIFont {
        get {
            switch self {
            case .normal:
                return .font(fontSize: 14)
            case .selected:
                return .font(fontSize: 14, fontName: .PingFMedium)
            }
        }
    }

}

class HCAninotionMenuModel {
    public var title: String = ""
    public var statu: HCAninotionMenuStatus = .normal
    /// 是否按view宽度平铺
    public var isLayoutFull: Bool = true
    
    public var width: CGFloat {
        get {
            let height = statu.titleFont.pointSize + 10
            return title.ty_textSize(font: statu.titleFont, width: CGFloat(MAXFLOAT), height: height).width
        }
    }
}

extension HCAninotionMenuModel {
    
    /// 首页
    public static func creatHomeMenuItems() ->[HCAninotionMenuModel] {
        let titles: [String] = ["大咖直播", "医师讲堂", "医学资讯"]
        var datas: [HCAninotionMenuModel] = []
        for title in titles {
            let model = HCAninotionMenuModel()
            model.title = title
            model.statu = title == "大咖直播" ? .selected : .normal
            model.isLayoutFull = true
            
            datas.append(model)
        }
        return datas
    }
}
