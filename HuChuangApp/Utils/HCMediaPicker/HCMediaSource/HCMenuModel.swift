//
//  HCMenuModel.swift
//  HuChuangApp
//
//  Created by yintao on 2020/11/5.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

class HCPickerMenuSectionModel {
    public var items: [HCPickerMenuItemModel] = []
    public var sectionInsets: UIEdgeInsets = .init(top: 15, left: 15, bottom: 15, right: 15)
    public var countForFull: Int = 4
        
    init() { }

    convenience init(items: [HCPickerMenuItemModel],
                     sectionInsets: UIEdgeInsets = .init(top: 15, left: 15, bottom: 15, right: 15),
                     countForFull: Int = 4) {
        self.init()
        self.items = items
        self.sectionInsets = sectionInsets
        self.countForFull = countForFull
    }
}

class HCPickerMenuItemModel {
    public var iconImage: UIImage?
    public var cornerRadius: CGFloat = 10
    public var iconTitleMargin: CGFloat = 5

    public var titleFont: UIFont = .font(fontSize: 12)
    public var titleColor: UIColor = RGB(120, 127, 133)
    public var title: String = ""

    init() { }
    
    convenience init(iconImage: UIImage? = nil,
                     ornerRadius: CGFloat = 10,
                     titleFont: UIFont = .font(fontSize: 12),
                     titleColor: UIColor = RGB(120, 127, 133),
                     iconTitleMargin: CGFloat = 5,
                     title: String) {
        self.init()
        self.iconImage = iconImage
        self.cornerRadius = cornerRadius
        self.titleFont = titleFont
        self.titleColor = titleColor
        self.iconTitleMargin = iconTitleMargin
        self.title = title
    }
    
    public lazy var textHeight: CGFloat = {
        return self.title.ty_textSize(font: self.titleFont, width: 1000, height: CGFloat.greatestFiniteMagnitude).height
    }()
}

extension HCPickerMenuSectionModel {
    
    /// 医生咨询
    public static func createChatPicker() ->[HCPickerMenuSectionModel] {
        return [HCPickerMenuSectionModel.init(items: [HCPickerMenuItemModel.init(iconImage: UIImage(named: "picker_message"),
                                                                                 title: "快捷回复"),
                                                      HCPickerMenuItemModel.init(iconImage: UIImage(named: "picker_photo"),
                                                                                 title: "相册"),
                                                      HCPickerMenuItemModel.init(iconImage: UIImage(named: "picker_camera"),
                                                                                 title: "拍摄"),
                                                      HCPickerMenuItemModel.init(iconImage: UIImage(named: "picker_video_call"),
                                                                                 title: "视频通话")])]
    }
}
