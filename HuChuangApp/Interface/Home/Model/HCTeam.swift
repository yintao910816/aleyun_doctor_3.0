//
//  HCTeam.swift
//  HuChuangApp
//
//  Created by sw on 2021/2/4.
//  Copyright © 2021 sw. All rights reserved.
//

import Foundation

class HCTeamListModel: HJModel {
    var records: [HCTeamItemModel] = []
}

class HCTeamItemModel: HJModel {
    var userName: String = ""
    var userId: String = ""
    var status: Int = 0
    var unitId: String = ""
    var technicalPost: String = ""
    var headPath: String = ""
    
    var isSelected: Bool = false
    var isEnableSelected: Bool {
        get {
            return status != 1
        }
    }
}
