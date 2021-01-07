//
//  HCVerification.swift
//  HuChuangApp
//
//  Created by sw on 2021/1/6.
//  Copyright © 2021 sw. All rights reserved.
//

import Foundation

class HCVerificationListModel: HJModel {
    var records: [HCVerificationItemModel] = []
}

class HCVerificationItemModel: HJModel {
    var address: String = ""
    var apm: String = ""
    var consultId: String = ""
    var createDate: String = ""
    var id: String = ""
    var memberId: String = ""
    var memberName: String = ""
    var modifyDate: String = ""
    var subjectDate: String = ""
    var subjectTimeId: String = ""
    var userId: String = ""
    var verificationCode: String = ""
    var verificationDate: String = ""
    var verificationStatus: Int = 1
    var week: String = ""
    
    public lazy var memberNameText: String = {
        return "预约人：\(memberName)"
    }()
    
    public lazy var beginTimeText: String = {
        let text = "预约时间：\(subjectDate)(\(week))\(apm == "AM" ? "上午" : "下午")"
        return text
    }()
    
    public lazy var shortBeginTimeText: String = {
        let text = "\(subjectDate)(\(week))\(apm == "AM" ? "上午" : "下午")"
        return text
    }()

    public lazy var endTimeText: String = {
        return "核销时间：\(verificationDate)"
    }()
}
