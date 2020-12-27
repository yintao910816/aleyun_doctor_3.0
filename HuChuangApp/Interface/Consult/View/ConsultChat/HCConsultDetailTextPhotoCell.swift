//
//  HCConsultDetailTextPhotoCell.swift
//  HuChuangApp
//
//  Created by yintao on 2020/6/19.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCConsultDetailTextPhotoCell_identifier = "HCConsultDetailTextPhotoCell_identifier"

class HCConsultDetailTextPhotoCell: HCConsultDetailBaseCell {

    private var contentTextLabel: UILabel!
    private var boxPhotoView: HCBoxPhotoView!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentTextLabel = UILabel()
        contentTextLabel.numberOfLines = 0
        contentTextLabel.font = .font(fontSize: 13, fontName: .PingFRegular)
        contentTextLabel.textColor = RGB(53, 53, 53)

        boxPhotoView = HCBoxPhotoView()

        contentView.addSubview(boxPhotoView)
        contentBgView.addSubview(contentTextLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public var model: HCChatListModel! {
        didSet {
            super.model = model
            contentTextLabel.text = model.content
//            boxPhotoView.filles = model.imageModels
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        contentTextLabel.frame = model.getContentTextFrame
//        boxPhotoView.frame = model.getImageBoxFrame
    }

}
