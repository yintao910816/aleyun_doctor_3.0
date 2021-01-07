//
//  HCTag.swift
//  HuChuangApp
//
//  Created by yintao on 2020/9/19.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

class HCTagNameModel: HJModel {
    var bak: String = ""
    var clinicId: String = ""
    var createDate: String = ""
    var creates: String = ""
    var id: String = ""
    var modifyDate: String = ""
    var modifys: String = ""
    var tagName: String = ""
    var type: Int = 0
    var unitId: String = ""
    var userId: String = ""
    
    public func transform() ->HCPatientGroupListModel {
        let model = HCPatientGroupListModel()
        model.id = id
        model.type = type
        model.createDate = createDate
        model.tagName = tagName
        return model
    }
}
