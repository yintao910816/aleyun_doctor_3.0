//
//  HCMessage.swift
//  HuChuangApp
//
//  Created by yintao on 2020/8/23.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

class HCMessageListModel: HJModel {
    var records: [HCMessageItemModel] = []
}

class HCMessageItemModel: HJModel {
    var age: String = ""
    var birthday: String = ""
    var code: String = ""
    var consultId: String = ""
    var consultType: Int = 4
    var consultTypeName: String = ""
    var content: String = ""
    var createDate: String = ""
    var headPath: String = ""
    var id: String = ""
    var lastestConsultDate: String = ""
    var memberId: String = ""
    var memberName: String = ""
    var name: String = ""
    var price: String = ""
    var realName: String = ""
    var sex: Int = 0
    var status: Int = 0
    var totalConsultNum: Int = 0
    var unreplyNum: Int = 0
    var userId: String = ""
    var userName: String = ""
}

class HCServerMsgModel: HJModel {
    var records: [HCMessageItemModel] = []
}
