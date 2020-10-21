//
//  HCConsultDetailPhotoCell.swift
//  HuChuangApp
//
//  Created by yintao on 2020/6/19.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCConsultDetailPhotoCell_identifier = "HCConsultDetailPhotoCell_identifier"

class HCConsultDetailPhotoCell: HCConsultDetailBaseCell {

    private var boxPhotoView: HCBoxPhotoView!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        boxPhotoView = HCBoxPhotoView()
        contentView.addSubview(boxPhotoView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public var model: HCConsultDetailConsultListModel! {
        didSet {
            super.model = model
            
            boxPhotoView.filles = model.imageModels
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        boxPhotoView.frame = model.getImageBoxFrame
    }

}
