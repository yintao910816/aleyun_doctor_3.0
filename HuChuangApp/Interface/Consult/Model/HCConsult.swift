//
//  HCConsultList.swift
//  HuChuangApp
//
//  Created by yintao on 2020/10/14.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

class HCConsultListModel: HJModel {
    var records: [HCConsultListItemModel] = []
}

class HCConsultListItemModel: HJModel {
    var age: Int = 0
    var birthday: String = ""
    var consultType: Int = 1
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
