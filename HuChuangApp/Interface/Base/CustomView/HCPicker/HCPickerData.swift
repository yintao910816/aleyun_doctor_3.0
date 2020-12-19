//
//  HCPickerData.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/17.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

struct HCPickerSectionData {
    var items: [HCPickerItemModel] = []
        
    /// 创建视频咨询排班设置数据
    public static func createVideoConsultSettingDatas() ->[HCPickerSectionData] {
        var startDatas: [HCPickerItemModel] = []
        var endDatas: [HCPickerItemModel] = []
        var peosDatas: [HCPickerItemModel] = []
        
        for idx in 0..<24 {
            if idx < 10 {
                var m1 = HCPickerItemModel()
                m1.title = "0\(idx):00"
                startDatas.append(m1)
                endDatas.append(m1)

                var m2 = HCPickerItemModel()
                m2.title = "0\(idx):30"
                startDatas.append(m2)
                endDatas.append(m2)
            }else {
                var m1 = HCPickerItemModel()
                m1.title = "\(idx):00"
                startDatas.append(m1)
                endDatas.append(m1)

                var m2 = HCPickerItemModel()
                m2.title = "\(idx):30"
                startDatas.append(m2)
                endDatas.append(m2)
            }
        }
        
        for idx in 1...10 {
            var m = HCPickerItemModel()
            m.title = "\(idx)"
            peosDatas.append(m)
        }
        
        return [HCPickerSectionData(items: startDatas),
                HCPickerSectionData(items: endDatas),
                HCPickerSectionData(items: peosDatas)]
    }
    
    /// 创建图文咨询排班设置数据
    public static func createPicConsultSettingDatas() ->[HCPickerSectionData] {
        var startDatas: [HCPickerItemModel] = []
        var endDatas: [HCPickerItemModel] = []
        
        for idx in 0..<24 {
            if idx < 10 {
                var m1 = HCPickerItemModel()
                m1.title = "0\(idx):00"
                startDatas.append(m1)
                endDatas.append(m1)

                var m2 = HCPickerItemModel()
                m2.title = "0\(idx):30"
                startDatas.append(m2)
                endDatas.append(m2)
            }else {
                var m1 = HCPickerItemModel()
                m1.title = "\(idx):00"
                startDatas.append(m1)
                endDatas.append(m1)

                var m2 = HCPickerItemModel()
                m2.title = "\(idx):30"
                startDatas.append(m2)
                endDatas.append(m2)
            }
        }
                
        return [HCPickerSectionData(items: startDatas),
                HCPickerSectionData(items: endDatas)]
    }

}

struct HCPickerItemModel {
    var title: String = ""
}
