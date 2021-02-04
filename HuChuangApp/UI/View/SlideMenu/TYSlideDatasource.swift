//
//  TYSlideDatasource.swift
//  HuChuangApp
//
//  Created by sw on 2019/9/27.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation

class TYSlideItemModel {
    var title: String = ""
    var textColor: UIColor = RGB(51, 51, 51)
    var selectedTextColor: UIColor = RGB(255, 102, 149)
    var lineColor: UIColor = .red
    var textFont: UIFont = .font(fontSize: 14, fontName: .PingFMedium)
    var lineWidth: CGFloat = 20
    var icon: UIImage? = nil

    var isSelected: Bool = false
    var isHiddenAnimotionView: Bool = false
    var isFullLayout: Bool = true
    var itemCount: Int = 1

    var dataModel: HomeColumnItemModel!
    
    init() { }
    
    convenience init(title: String,
         textColor: UIColor = RGB(51, 51, 51),
         selectedTextColor: UIColor = RGB(255, 102, 149),
         lineColor: UIColor = .red,
         textFont: UIFont = .font(fontSize: 14, fontName: .PingFMedium),
         lineWidth: CGFloat = 20,
         isSelected: Bool = false,
         isHiddenAnimotionView: Bool = false,
         isFullLayout: Bool = true,
         itemCount: Int = 1,
         icon: UIImage? = nil,
         dataModel: HomeColumnItemModel = HomeColumnItemModel()) {
        
        self.init()
        
        self.title = title
        self.textColor = textColor
        self.selectedTextColor = selectedTextColor
        self.lineColor = lineColor
        self.textFont = textFont
        self.lineWidth = lineWidth
        self.isSelected = isSelected
        self.isHiddenAnimotionView = isHiddenAnimotionView
        self.isFullLayout = isFullLayout
        self.itemCount = itemCount
        self.icon = icon
        self.dataModel = dataModel
    }

    
    public lazy var contentWidth: CGFloat = {
        return self.title.ty_textSize(font: self.textFont, width: CGFloat(MAXFLOAT), height: 30).width + 30
    }()
    
    public static func creatSimple(for titles: [String]) ->[TYSlideItemModel] {
        var dataModels: [TYSlideItemModel] = []
        for title in titles {
            let itemModel = TYSlideItemModel()
            itemModel.isSelected = dataModels.count == 0
            
            let columItem = HomeColumnItemModel()
            columItem.name = title
            itemModel.dataModel = columItem
            
            dataModels.append(itemModel)
        }
        return dataModels
    }
    
    public static func creatModel(for titles: [String]) ->[TYSlideItemModel] {
        var dataModels: [TYSlideItemModel] = []
        for title in titles {
            let itemModel = TYSlideItemModel()
            itemModel.isSelected = dataModels.count == 0
            itemModel.title = title
            itemModel.itemCount = titles.count
            itemModel.selectedTextColor = RGB(75, 138, 279)
            itemModel.textColor = RGB(12, 12, 12)
            itemModel.lineColor = RGB(75, 138, 279)
            dataModels.append(itemModel)
        }
        return dataModels
    }
}

extension TYSlideItemModel {
   
    internal static func createTeamData() ->[TYSlideItemModel] {
        return [TYSlideItemModel(title: "我的团队",
                                 textColor: RGB(191, 191, 191),
                                 selectedTextColor: HC_MAIN_COLOR,
                                 lineColor: HC_MAIN_COLOR,
                                 textFont: .font(fontSize: 16),
                                 isSelected: true),
                TYSlideItemModel(title: "我所在的团队",
                                 textColor: RGB(51, 51, 51),
                                 selectedTextColor: RGB(51, 51, 51),
                                 lineColor: HC_MAIN_COLOR,
                                 textFont: .font(fontSize: 16))]
    }

}

class HCSlideItemController: BaseViewController {
    
    public var pageIdx: Int = 0
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    public func reloadData(data: Any?) {
        
    }
    
    public func bind<T>(viewModel: RefreshVM<T>, canRefresh: Bool, canLoadMore: Bool, isAddNoMoreContent: Bool) {
        
    }
}
