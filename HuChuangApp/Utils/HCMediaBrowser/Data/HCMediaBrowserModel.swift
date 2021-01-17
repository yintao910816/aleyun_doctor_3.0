//
//  HCMediaBrowserModel.swift
//  HuChuangApp
//
//  Created by sw on 2021/1/17.
//  Copyright © 2021 sw. All rights reserved.
//

import Foundation

enum HCBrowserType {
    case photo
    case video
    case audio
}

class HCMediaSectionModel {
    public var browserType: HCBrowserType = .photo
    
    public var items = [HCBaseBrowserModel]()
    
}

class HCBaseBrowserModel {
    public var mediaType: HCBrowserType = .photo
    
    public var picwidth: CGFloat = 0
    public var picHeight: CGFloat = 0

    public var idx: Int = 0
}

class HCPhotoBrowserModel: HCBaseBrowserModel {

    public var picPath: String = ""
    public var image: UIImage?

}

class HCVideoBrowserModel: HCBaseBrowserModel {
    

}

class HCAudioBrowserModel: HCBaseBrowserModel {


}
