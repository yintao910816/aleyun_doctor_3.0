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

    public var imageClicked: (((UIImage?, String))->())?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        boxPhotoView = HCBoxPhotoView()
        boxPhotoView.imageClicked = { [unowned self] in imageClicked?($0) }
        
        contentView.addSubview(boxPhotoView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public var model: HCChatListModel! {
        didSet {
            super.model = model

            if model.files.count == 0 {
                let file = HCConsultDetailFileModel()
                file.filePath = model.content
                model.files.append(file)
            }
            
            boxPhotoView.filles = model.files
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        boxPhotoView.frame = model.getImageBoxFrame
    }

}
