//
//  HCMyPatient.swift
//  HuChuangApp
//
//  Created by yintao on 2020/9/18.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation
import HandyJSON

/// 患者列表
class HCMyPatientListModel: HJModel {
    var records: [HCPatientItemModel] = []
}

class HCPatientItemModel: HJModel {
    var age: String = ""
    var bak: String = ""
    var black: Bool = false
    var consultId: String = ""
    var createDate: String = ""
    var creates: String = ""
    var headPath: String = ""
    var id: String = ""
    var memberId: String = ""
    var memberName: String = ""
    var name: String = ""
    var modifyDate: String = ""
    var modifys: String = ""
    var note: String = ""
    var sex: Int = 1
    var userId: String = ""

    var tagName: String = ""
    var mobile: String = ""
    var userName: String = ""

//    override func mapping(mapper: HelpingMapper) {
//        mapper <<<
//            memberId <-- ["id", "memberId"]
//        mapper <<<
//            memberName <-- ["name", "memberName"]
//    }
    
    public lazy var sexText: String = {
        if let type = HCGender(rawValue: self.sex) {
            return type.genderText
        }
        return "女"
    }()
    
    public lazy var nameText: String = {
        return memberName.count > 0 ? memberName : name
    }()
    
    public lazy var memberInfoText: String = {
        if age.count > 0 {
            return "\(nameText)(\(sexText) \(age)岁)"
        }
        return "\(nameText)(\(sexText))"
    }()
    
    public static func testDatas() ->[HCPatientItemModel] {
        var data: [HCPatientItemModel] = []
        for _ in 0..<5 {
            let m = HCPatientItemModel()
            m.userName = "测试数据"
            m.sex = 0
            m.age = "20"
            data.append(m)
        }
        return data
    }
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
    var consultId: String = ""
}

/// 屏蔽患者列表
class HCHideMembersListModel: HJModel {
    var records: [HCPatientItemModel] = []
}
