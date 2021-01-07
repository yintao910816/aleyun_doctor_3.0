//
//  HCVerificationEmptyFooterView.swift
//  HuChuangApp
//
//  Created by sw on 2021/1/6.
//  Copyright © 2021 sw. All rights reserved.
//

import UIKit

class HCVerificationEmptyFooterView: UIView {

    private var remindLabel: UILabel!
    private var contentImgV: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        remindLabel = UILabel()
        remindLabel.text = "暂无记录"
        remindLabel.textColor = RGB(153, 153, 153)
        remindLabel.font = .font(fontSize: 16, fontName: .PingFMedium)
        remindLabel.textAlignment = .center
        
        contentImgV = UIImageView(image: UIImage(named: "verification_empty"))
        
        addSubview(remindLabel)
        addSubview(contentImgV)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let posionY: CGFloat = (height - 96 - 20 - 20) / 2
        contentImgV.frame = .init(x: (width - 91) / 2, y: posionY, width: 91, height: 96)
        remindLabel.frame = .init(x: 20, y: contentImgV.frame.maxY + 20, width: width - 40, height: 20)
    }
}
