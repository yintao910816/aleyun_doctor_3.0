//
//  HCUser.swift
//  HuChuangApp
//
//  Created by sw on 02/02/2019.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation
import HandyJSON

class HCUserModel: HJModel {
    
    var account: String = ""
    var age: String = ""
    var areaCode: String = ""
    var bak: String = ""
    var birthday: String = ""
    var brief: String = ""
    var cityName: String = ""
    var consult: String = ""
    var consultNum: Int = 0
    var consultPrice: String = ""
    var createDate: String = ""
    var creates: String = ""
    var departmentId: String = ""
    var departmentName: String = ""
    var email: String = ""
    var enable: Bool = true
    var environment: String = ""
    var headPath: String = ""
    var hisCode: String = ""
    var hisNo: String = ""
    var uid: String = ""
    var ip: String = ""
    var lastLogin: String = ""
    var linueupNo: String = ""
    var mobile: String = ""
    var modifyDate: String = ""
    var modifys: String = ""
    var name: String = ""
    var numbers: String = ""
    var practitionerYear: String = ""
    var prasiRat: String = ""
    var provinceName: String = ""
    var recom: String = ""
    var respRate: String = ""
    var sex: Int = 1;
    var skilledIn: String = ""
    var skilledInIds: String = ""
    var skin: String = ""
    var smsNotice: String = ""
    var sort: String = ""
    var spellBrevityCode: String = ""
    var spellCode: String = ""
    var status: Int = 1
    var technicalPost: String = ""
    var technicalPostId: String = ""
    var token: String = ""
    var unitId: String = ""
    var unitName: String = ""
    var viewProfile: String = ""
    var wubiCode: String = ""

    var sexText: String {
        get { return sex == 1 ? "男" : "女" }
    }

    override func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &uid, name: "id")
    }
    
}
