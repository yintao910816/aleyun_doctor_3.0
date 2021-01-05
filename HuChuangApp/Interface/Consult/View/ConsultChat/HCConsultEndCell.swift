//
//  HCConsultEndCell.swift
//  HuChuangApp
//
//  Created by yintao on 2020/12/30.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCConsultEndCell_identifier = "HCConsultEndCell"

class HCConsultEndCell: HCBaseConsultCell {

    private var titleLabel: UILabel!
    private var leftLine: UIView!
    private var rightLine: UIView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
                
        titleLabel = UILabel()
        titleLabel.textColor = RGB(120, 127, 133)
        titleLabel.backgroundColor = .clear
        titleLabel.font = .font(fontSize: 14)
        titleLabel.text = "咨询结束"
        
        leftLine = UIView()
        leftLine.backgroundColor = RGB(209, 209, 209)
        
        rightLine = UIView()
        rightLine.backgroundColor = RGB(209, 209, 209)

        contentView.addSubview(titleLabel)
        contentView.addSubview(leftLine)
        contentView.addSubview(rightLine)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()

        let tempSize = titleLabel.sizeThatFits(.init(width: CGFloat.greatestFiniteMagnitude, height: 50))
        titleLabel.frame = .init(x: (width - tempSize.width) / 2, y: (height - tempSize.height) / 2, width: tempSize.width, height: tempSize.height)
        
        leftLine.frame = .init(x: 35, y: (height - 0.5) / 2, width: titleLabel.x - 35 - 10, height: 0.5)
        rightLine.frame = .init(x: titleLabel.frame.maxX + 10, y: leftLine.y, width: leftLine.width, height: leftLine.height)
    }

}
