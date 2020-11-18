//
//  HCFiliterViewData.swift
//  HuChuangApp
//
//  Created by yintao on 2020/11/18.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

class HCFiliterModel {
    
    public var title: String = ""
    public var id: String = ""
    
    public var normalBGColor: UIColor = .clear
    public var selectedBGColor: UIColor = .clear
    public var normalTextColor: UIColor = RGB(61, 55, 68)
    public var selectedTextColor: UIColor = HC_MAIN_COLOR
    
    public var isSelected: Bool = false
    public var isHiddenDelete: Bool = true

    init() { }
        
    public var contentSize: CGSize {
        get {
            let w = title.getTexWidth(fontSize: 12, height: 48, fontName: FontName.PingFMedium.rawValue) + 50
            return .init(width: w, height: 48)
        }
    }
    
    public var bgColor: UIColor {
        get {
            return isSelected ? selectedBGColor : normalBGColor
        }
    }
    
    public var titleColor: UIColor {
        get {
            return isSelected ? selectedTextColor : normalTextColor
        }
    }
}

class HCFiliterSectionModel {
    
    public var sectionTitle: String = ""

    public var datas: [HCFiliterModel] = []
    
    public class func createData(datas: [HCTagNameModel]) ->[HCFiliterSectionModel] {
        let section = HCFiliterSectionModel()
        section.sectionTitle = ""
        for item in datas {
            let m = HCFiliterModel()
            m.title = item.tagName
            m.id = item.id
            section.datas.append(m)
        }
                
        return [section]
    }
    
    public class func transform(of model: HCTagNameModel) ->HCFiliterModel {
        let m = HCFiliterModel()
        m.title = model.tagName
        m.id = model.id
        return m
    }
}
