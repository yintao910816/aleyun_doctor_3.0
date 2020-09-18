//
//  HCMyPatient.swift
//  HuChuangApp
//
//  Created by yintao on 2020/9/18.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

/// 患者列表
class HCPatientListModel: HJModel {
    var records: [HCPatientItemModel] = []
}

class HCPatientItemModel: HJModel {
    var age: String = ""
    var bak: String = ""
    var black: Bool = false
    var headPath: String = ""
    var id: String = ""
    var mobile: String = ""
    var name: String = ""
    var sex: Int = 1
    var userId: String = ""
    var userName: String = ""
    
    public lazy var sexText: String = {
        if let type = HCGender(rawValue: self.sex) {
            return type.genderText
        }
        return "女"
    }()
}

/// 患者管理-分组数据
class HCPatientGroupListModel: HJModel {
    var id: String = ""
    var type: Int = 0
    var createDate: String = ""
    var tagName: String = ""
    var memberList: [HCPatientGroupListItemModel] = []
    var memberCount: Int = 0
    
    /// 是否收起状态
    var isExpand: Bool = false
}

class HCPatientGroupListItemModel: HJModel {
    var tagId: String = ""
    var tagName: String = ""
    var memberId: String = ""
    var memberName: String = ""
    var headPath: String = ""
    var userId: String = ""
}
