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
    private var bottomBgView: UIView!
    private var bgLineView: UIView!
    private var lineView: UIView!
    
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
        
        let bannerW: CGFloat = CGFloat(14 * bannerDatas.count)
        let bannerX: CGFloat = (width - bannerW) / 2
        bottomBgView.frame = .init(x: bannerX, y: height - 5, width: bannerW, height: 5)
        bgLineView.frame = .init(x: 0, y: 0, width: bottomBgView.width, height: bottomBgView.height)
        lineView.frame = .init(x: CGFloat(currentPageIdx * 14), y: 0, width: 14, height: 5)
    }
}

extension HCBannerItemCell {
    
    private func initUI() {
        backgroundColor = .clear
        
        bannerView = CarouselView()
        bannerView.pageContrlIsHidden = true
        bannerView.pageIdxChangeCallBack = { [weak self] in self?.currentPageIdx = $0 }
        
        bottomBgView = UIView()
        bottomBgView.backgroundColor = backgroundColor
        
        bgLineView = UIView()
        bgLineView.backgroundColor = RGB(153, 193, 245)
        bgLineView.layer.cornerRadius = 2.5
        bgLineView.clipsToBounds = true

        lineView = UIView()
        lineView.backgroundColor = RGB(75, 137, 239)
        lineView.layer.cornerRadius = 2.5
        lineView.clipsToBounds = true
        
        addSubview(bannerView)
        addSubview(bottomBgView)
        bottomBgView.addSubview(bgLineView)
        bottomBgView.addSubview(lineView)
    }
}
