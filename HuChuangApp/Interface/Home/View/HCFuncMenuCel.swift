//
//  HCFuncMenuCel.swift
//  HuChuangApp
//
//  Created by yintao on 2020/9/2.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCFuncMenuCel_identifier: String = "HCFuncMenuCel"

class HCFuncMenuCel: UICollectionViewCell {
        
    private var icon: UIImageView!
    private var title: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var funcModel: HCFunctionsMenuModel! {
        didSet {
            icon.setImage(funcModel.iconPath)
            title.text = funcModel.name
        }
    }
    
    private func initUI() {
        icon = UIImageView()
        
        title = UILabel()
        title.textColor = RGB(12, 12, 12)
        title.font = .font(fontSize: 12)
        title.textAlignment = .center
        
        addSubview(icon)
        addSubview(title)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        icon.frame = .init(x: 0, y: 0, width: width, height: width)
        title.frame = .init(x: 0, y: icon.frame.maxY + 10, width: width, height: 12)
    }
}
