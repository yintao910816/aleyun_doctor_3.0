//
//  HCServer.swift
//  HuChuangApp
//
//  Created by yintao on 2020/12/17.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

public enum HCConsultSettingDelMode {
    /// 未设置
    case noSetting
    /// 已有人预约
    case hasReceive
    /// 可以取消排班
    case enable
}

//MARK: 界面展示
struct HCServerSettingModel {
    var icon: UIImage?
    var title: String = ""
    var subTitle: String = ""
    var actionTitle: String = ""
    
    var isOpen: Bool = false
}

class HCVideoDaySettingModel {
    var date: String = ""
    var week: String = ""
    var isToday: Bool = false
    var isSelected: Bool = false
    
    var settingModel: HCConsultDaySettingModel?
}

class HCQueryScheduleSettingModel {
    var date: String = ""
    var week: String = ""
    var isToday: Bool = false
    var isSelected: Bool = false

    var settingModel: HCQueryPreciseScheduleItemModel?
}

//MARK: 图文和视频
class HCOpenConsultStatusModel: HJModel {
    var smsNotice: Bool = false
    
    var picModel: HCConsultStatusModel = HCConsultStatusModel()
    var videoModel: HCConsultStatusModel = HCConsultStatusModel()
}

class HCConsultStatusModel: HJModel {
    var id: String = ""
    var unitId: String = ""
    var userName: String = ""
    var unitName: String = ""
    var userId: String = ""
    var price: Float = 0
    var isOpen: Bool = false
    var createDate: String = ""
    var modifyDate: String = ""
    var creates: String = ""
    var modifys: String = ""
    var bak: String = ""
    var timeType: Int = 0
    var startTime: String = ""
    var endTime: String = ""
    var type: Int = 0
    var unit: String = ""
    var address: String = ""
    var consultVideoUserSubjectTimeList: String = ""
    var consultVideoUserSubjectTimeMap: [String: [String: Any]] = [:]
    var consultVideoUserSubjectTime: String = ""
    var recom: Bool = false
    var smsNotice: Bool = false
}

class HCConsultDaySettingModel: HJModel {
    var id: String = ""
    var userId: String = ""
    var subjectsDate: String = ""
    var basicsTimeId: String = ""
    var startTime: String = ""
    var endTime: String = ""
    var recevieNum: String = ""
    var creates: String = ""
    var createDate: String = ""
    var modifys: String = ""
    var modifyDate: String = ""
    var apm: String = ""
    var status: Int = 0
}

//MARK: 精准预约
class HCQueryPreciseScheduleModel: HJModel {
    var price: Float = 0
    var address: String = ""
    var open: Bool = false
    
    var scheduleMap: [String: [String: Any]] = [:]
}

class HCQueryPreciseScheduleItemModel: HJModel {
    var id: String = ""
    var userId: String = ""
    var subjectsDate: String = ""
    var morningNum: Int = 0
    var afternoonNum: Int = 0
    var del: Bool = false
    var createDate: String = ""
    var modifyDate: String = ""
    var morningReservedNum: Int = 0
    var afternoonReservedNum: Int = 0
}
