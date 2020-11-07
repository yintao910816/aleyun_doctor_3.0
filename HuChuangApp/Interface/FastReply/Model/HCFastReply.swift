//
//  HCFastReply.swift
//  HuChuangApp
//
//  Created by yintao on 2020/11/7.
//  Copyright © 2020 sw. All rights reserved.
//  快捷回复

import Foundation

class HCFastReplyModel: HJModel {
    var title: String = ""
    var link: String = ""
    var iconPath: String = ""
    var markText: String = ""
    
    public static func creatTestDatas() ->[HCFastReplyModel] {
        var datas: [HCFastReplyModel] = []
        for _ in 0..<10 {
            let m = HCFastReplyModel()
            m.title = "测试标题"
            m.link = "http://www.baidu.com"
            m.markText = "备注：爱乐晕"
            datas.append(m)
        }
        return datas
    }
}
