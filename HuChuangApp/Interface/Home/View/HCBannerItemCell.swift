//
//  HCBannerItemCell.swift
//  HuChuangApp
//
//  Created by sw on 2020/9/3.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCBannerItemCell_identifier = "HCBannerItemCell"
public let HCBannerItemCell_height: CGFloat = 90

class HCBannerItemCell: UICollectionViewCell {
    
    private var bannerView: CarouselView!
    
    private var currentPageIdx: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var bannerDatas: [HCBannerModel] = [] {
        didSet {
            bannerView.setData(source: bannerDatas)
            
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bannerView.frame = .init(x: 15, y: 15, width: width - 30, height: 65)
    }
}

extension HCBannerItemCell {
    
    private func initUI() {
        backgroundColor = .white
        
        bannerView = CarouselView()
        bannerView.indicatorPosition = .bottomCenter
        bannerView.pageContrl.currentPageIndicatorTintColor = RGB(51, 51, 51)
        bannerView.pageContrl.pageIndicatorTintColor = RGB(214, 214, 214)
        bannerView.pageIdxChangeCallBack = { [weak self] in self?.currentPageIdx = $0 }
        
        addSubview(bannerView)
    }
}
