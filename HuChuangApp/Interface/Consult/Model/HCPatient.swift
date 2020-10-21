//
//  HCPatient.swift
//  HuChuangApp
//
//  Created by yintao on 2020/5/14.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

/// 患者管理-分组数据
class HCPatientListModel: HJModel {
    var id: String = ""
    var type: Int = 0
    var createDate: String = ""
    var tagName: String = ""
    var memberList: [HCPatientListItemModel] = []
    var memberCount: Int = 0
}

class HCPatientListItemModel: HJModel {
    var tagId: String = ""
    var tagName: String = ""
    var memberId: String = ""
    var memberName: String = ""
    var headPath: String = ""
    var userId: String = ""
}

/// 患者搜索
class HCPatientSearchDataModel: HJModel {
    var memberLsit: [HCPatientListItemModel] = []
}

/// 患者管理-周期档案
class HCPatientCircleModel: HJModel {
    var p_id: String = ""
    var o_id: String = ""
    var name_w: String = ""
    var name_m: String = ""
    var age_w: String = ""
    var age_m: String = ""
    var identif_w: String = ""
    var identif_m: String = ""
    var opsname: String = ""
    var opstimes: String = ""
    var begindate: String = ""
    var enddate: String = ""
    var patientmemo: String = ""
    var pourout: String = ""
    var nowmedicalrecord: String = ""
    var diagnose: String = ""
    var casehistorysumm: String = ""
    var fsh: String = ""
    var fsh_units: String = ""
    var lh: String = ""
    var lh_units: String = ""
    var e2: String = ""
    var e2_units: String = ""
    var prl: String = ""
    var prl_units: String = ""
    var t: String = ""
    var t_units: String = ""
    var p: String = ""
    var p_units: String = ""
    var amh: String = ""
    var amh_units: String = ""
    var bloodsugar: String = ""
    var bloodinsulin: String = ""
}

class HCMemberInfoModel: HJModel {
    var id: String = ""
    var nameW: String = ""
    var heightW: String = ""
    var weightW: String = ""
    var nameM: String = ""
    var heightM: String = ""
    var weightM: String = ""
    var memberId: String = ""
    var createDate: String = ""
    var modifyDate: String = ""
    var creates: String = ""
    var modifys: String = ""
    var bak: String = ""
}
