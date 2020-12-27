//
//  HCFastReply.swift
//  HuChuangApp
//
//  Created by yintao on 2020/11/7.
//  Copyright © 2020 sw. All rights reserved.
//  快捷回复

import Foundation

class HCFastReplyModel: HJModel {
    var id: String = ""
    var title: String = ""
    var content: String = ""
    var userId: String = ""
    var creates: String = ""
    var modifys: String = ""
    var createDate: String = ""
    var modifyDate: String = ""
    var unitId: String = ""
    var path: String = ""
    var pathList: String = ""
    var sort: Int = 0
    
    public lazy var imagePath: String = {
        let strings = path.components(separatedBy: ",")
        if strings.count > 0 {
            return strings[0]
        }
        return path
    }()
}
