//
//  HCConsultDetalMineCell.swift
//  HuChuangApp
//
//  Created by yintao on 2020/5/24.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCConsultDetalCell_identifier = "HCConsultDetalCell_identifier"

class HCConsultDetalCell: HCConsultDetailBaseCell {

    private var contentTextLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentTextLabel = UILabel()
        contentTextLabel.numberOfLines = 0
        contentTextLabel.font = .font(fontSize: 14)
        contentTextLabel.textColor = RGB(12, 12, 12)
        
        contentBgView.addSubview(contentTextLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public var model: HCChatListModel! {
        didSet {
            super.model = model
            contentTextLabel.text = model.content
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentTextLabel.frame = model.getContentTextFrame
    }
}
