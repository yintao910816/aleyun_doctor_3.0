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
    var prasiRat: String = "0%"
    var provinceName: String = ""
    var recom: String = ""
    var respRate: String = "高"
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

    override func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &uid, name: "id")
    }

    var sexText: String {
        get { return sex == 1 ? "男" : "女" }
    }

    /// 服务患者
    public var serverNumberText: NSAttributedString {
        get {
            let text = "1152\n服务患者"
            return text.attributed(.init(location: 5, length: 4),
                                   RGB(221, 235, 254),
                                   .font(fontSize: 12),
                                   lineSpace: nil)
        }
    }
    
    /// 好评率
    public var prasiRatText: NSAttributedString {
        get {
            let prasiText = prasiRat.count > 0 ? prasiRat : "0%"
            let text = "\(prasiText)\n好评率"
            return text.attributed(.init(location: prasiText.count + 1, length: 3),
                                   RGB(221, 235, 254),
                                   .font(fontSize: 12),
                                   lineSpace: 2)
        }
    }

    /// 回复率
    public var respRateText: NSAttributedString {
        get {
            let respText = respRate.count > 0 ? respRate : "高"
            let text = "\(respText)\n回复率"
            return text.attributed(.init(location: respText.count + 1, length: 3),
                                   RGB(221, 235, 254),
                                   .font(fontSize: 12),
                                   lineSpace: 2)
        }
    }

}
