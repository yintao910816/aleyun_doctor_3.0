//
//  HCHome.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/18.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation
import HandyJSON

/// 功能按钮
class HCFunctionsMenuModel: HJModel {
    var id: String = ""
    var code: String = ""
    var name: String = ""
    var sort: Int = 0
    var createDate: String = ""
    var modifyDate: String = ""
    var creates: String = ""
    var modifys: String = ""
    var bak: String = ""
    var unitId: String = ""
    var iconPath: String = ""
    var functionUrl: String = ""
    var type: String = ""
    var unitName: String = ""
    var facilityType: String = ""
    var primordial: Int = 0
    var recom: Int = 0
    var bind: String = ""
    var hide: Bool = false
}

/// 文章栏目菜单
class HCCmsCmsChanelListModel: HJModel {
    var bak: String = ""
    var code: String = ""
    var createDate: String = ""
    var creates: String = ""
    var del: Bool = false
    var hide: Bool = false
    var id: String = ""
    var modifyDate: String = ""
    var modifys: String = ""
    var name: String = ""
    var parentId: String = ""
    var path: String = ""
    var platform: String = ""
    var recom: Int = 0
    var shopId: String = ""
    var sort: String = ""
    var target: String = ""
    var type: String = ""
    var unitId: String = ""
    var url: String = ""
}

class HCCmsArticleModel: HJModel {
    var id: String = ""
    var picPath: String = ""
    var title: String = ""
}

class HCBannerModel: HJModel, CarouselSource {
    public var clickCount: Int = 0
    public var createTime: Int = 0
    public var discibe: String = ""
    public var hospitalId: String = ""
    public var id: String = ""
    public var order: Int = 0
    public var path: String = ""
    public var title: String = ""
    public var type: Int = 0
    public var updateTime: Int = 0
    public var link: String = ""
    
    override func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &link, name: "url")
    }

    var url: String? { return path }
}

/// 好评相关
class HCUserServerStatisticsModel: HJModel {
    var consultNum: Int = 0
    var prasiRat: Float = 0.0
    var replyNum: Int = 0
    var respRate: Float = 0.0
    
    /// 手动添加：待接诊订单
    var unreplyNum: Int = 0
    
    public lazy var briefText: String = {
        // 咨询数
        let consultText = "\(consultNum)"
        // 回复率
        let replyText = consultNum == 0 ? "良好" : Float(replyNum / consultNum) < 0.8 ? "良好" : "高"
        // 好评率
        let praiseText = prasiRat == 0 ? "100%" : "\(Int(prasiRat * 100))%"
        return "服务患者\(consultText)  好评率\(praiseText)  回复率:\(replyText)"
//        let string = NSMutableAttributedString.init(string: "咨询数\(consultText)，回复率\(replyText)，好评率\(praiseText)")
//
//        string.addAttribute(NSAttributedString.Key.foregroundColor,
//                            value: RGB(244, 174, 62),
//                            range: .init(location: 3, length: consultText.count))
//        string.addAttribute(NSAttributedString.Key.font,
//                            value: UIFont.font(fontSize: 12, fontName: .PingFSemibold),
//                            range: .init(location: 3, length: consultText.count))
//
//        string.addAttribute(NSAttributedString.Key.foregroundColor,
//                            value: RGB(244, 174, 62),
//                            range: .init(location: 3 + consultText.count + 4,
//                                         length: replyText.count))
//        string.addAttribute(NSAttributedString.Key.font,
//                            value: UIFont.font(fontSize: 12, fontName: .PingFSemibold),
//                            range: .init(location: 3 + consultText.count + 4,
//                                         length: replyText.count))
//
//        string.addAttribute(NSAttributedString.Key.foregroundColor,
//                            value: RGB(244, 174, 62),
//                            range: .init(location: 3 + consultText.count + 4 + replyText.count + 4,
//                                         length: praiseText.count))
//        string.addAttribute(NSAttributedString.Key.font,
//                            value: UIFont.font(fontSize: 12, fontName: .PingFSemibold),
//                            range: .init(location: 3 + consultText.count + 4 + replyText.count + 4,
//                                         length: praiseText.count))
//
//        return string
    }()

    public var unreplyNumText: NSAttributedString {
        get {
            let string = "待接诊\n\(unreplyNum)"
            return string.attributed(.init(location: 4,
                                           length: "\(unreplyNum)".count),
                                     .white,
                                     .font(fontSize: 16),
                                     lineSpace: 5)
        }
    }
    
    public var unreplyRemindText: String {
        get {
            return unreplyNum > 0 ? "您有新的待订单，请及时查看" : "当前无新订单"
        }
    }
}
