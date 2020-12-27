//
//  HCConsultDetailTimeCell.swift
//  HuChuangApp
//
//  Created by yintao on 2020/5/24.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCConsultDetailTimeCell_identifier = "HCConsultDetailTimeCell_identifier"

class HCConsultDetailTimeCell: HCBaseConsultCell {

    private var titleLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = RGB(247, 247, 247)
        
        titleLabel = UILabel()
        titleLabel.textColor = RGB(153, 153, 153)
        titleLabel.backgroundColor = .clear
        titleLabel.font = .font(fontSize: 14)
        contentView.addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override public var model: HCConsultDetailConsultListModel! {
//        didSet {
//            titleLabel.text = model.timeString
//        }
//    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        titleLabel.frame = model.getTimeFrame
    }
}
