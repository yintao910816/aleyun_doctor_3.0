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
        if imageList.count > 0 {
            return imageList[0]
        }
        return path
    }()
    
    public lazy var imageList: [String] = {
        if path.count > 0 {
            let strings = path.components(separatedBy: ",")
            return strings
        }
        return []
    }()

    public lazy var photoModels: [HCPhotoViewModel] = {
        if imageList.count > 0 {
            var datas: [HCPhotoViewModel] = []
            for item in imageList {
                datas.append(HCPhotoViewModel(image: nil, url: item))
            }
            return datas
        }
        return []
    }()
}
