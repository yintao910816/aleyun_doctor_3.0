//
//  HCMenuReusableView.swift
//  HuChuangApp
//
//  Created by sw on 2020/9/4.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCMenuReusableView_identifier = "HCMenuReusableView"
public let HCMenuReusableView_height: CGFloat = 52

class HCMenuReusableView: UICollectionReusableView {
        
    private var bgView: UIView!
    private var menuView: HCAninotionMenuView!
    
    public var menuChangeCallBack: (((HCAninotionMenuModel, Int))->())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var menuItems: [HCAninotionMenuModel] = [] {
        didSet {
            menuView.menuItems = menuItems
        }
    }
    
    private func initUI() {
        backgroundColor = .clear
                
        bgView = UIView()
        bgView.backgroundColor = .white
        
        menuView = HCAninotionMenuView.init(frame: .zero, isFullLayout: true)
        menuView.layer.cornerRadius = 20
        menuView.clipsToBounds = true
        
        addSubview(bgView)
        bgView.addSubview(menuView)
        
        menuView.menuChangeCallBack = { [weak self] in self?.menuChangeCallBack?($0) }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgView.frame = .init(x: 15, y: 0, width: width - 30, height: height)
        menuView.frame = .init(x: 12, y: 10, width: bgView.width - 24, height: bgView.height - 10)
        
        if bgView.layer.mask == nil {
            bgView.creat(cornerRadius: 7, borderCorners: [.topLeft, .topRight])
        }
    }
}
