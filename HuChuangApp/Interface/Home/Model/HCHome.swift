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
    var bak: String = ""
    var bind: String = ""
    var code: String = ""
    var createDate: String = ""
    var creates: String = ""
    var functionUrl: String = ""
    var hide: Bool = false
    var iconPath: String = ""
    var id: String = ""
    var modifyDate: String = ""
    var modifys: String = ""
    var name: String = ""
    var primordial: String = ""
    var recom: Int = 0
    var sort: Int = 0
    var type: String = ""
    var unitId: String = ""
    var unitName: String = ""
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
