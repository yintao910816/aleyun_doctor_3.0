//
//  HCConsultDetailSectionHeader.swift
//  HuChuangApp
//
//  Created by yintao on 2020/5/23.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCConsultDetailSectionHeader_identifier = "HCConsultDetailSectionHeader_identifier"

class HCConsultDetailSectionHeader: UITableViewHeaderFooterView {
    
    private var timeLabel: UILabel!
    private var contentBgView: UIImageView!
    private var desInfoTitleLabel: UILabel!
    private var contentLabel: UILabel!
    private var desPhotoTitleLabel: UILabel!
    private var boxPhotoView: HCBoxPhotoView!
    
    public var imageClicked: (((UIImage?, String))->())?

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        backgroundColor = RGB(247, 247, 247)
        contentView.backgroundColor = RGB(247, 247, 247)
        
        timeLabel = UILabel()
        timeLabel.textAlignment = .center
        timeLabel.font = .font(fontSize: 14, fontName: .PingFRegular)
        timeLabel.textColor = RGB(169, 169, 169)
                
        contentBgView = UIImageView()
        contentBgView.layer.cornerRadius = 3
        contentBgView.clipsToBounds = true
        contentBgView.backgroundColor = .white
        contentBgView.isUserInteractionEnabled = true
        
        desInfoTitleLabel = UILabel()
        desInfoTitleLabel.font = .font(fontSize: 14)
        desInfoTitleLabel.textColor = RGB(153, 153, 153)
        desInfoTitleLabel.backgroundColor = contentBgView.backgroundColor
        desInfoTitleLabel.text = "病情描述："
        
        contentLabel = UILabel()
        contentLabel.numberOfLines = 0
        contentLabel.font = .font(fontSize: 13, fontName: .PingFRegular)
        contentLabel.textColor = RGB(53, 53, 53)

        desPhotoTitleLabel = UILabel()
        desPhotoTitleLabel.font = .font(fontSize: 14)
        desPhotoTitleLabel.textColor = RGB(153, 153, 153)
        desPhotoTitleLabel.backgroundColor = contentBgView.backgroundColor
        desPhotoTitleLabel.text = "报告病例："

        boxPhotoView = HCBoxPhotoView()
        boxPhotoView.imageClicked = { [unowned self] in imageClicked?($0) }
        
        contentView.addSubview(timeLabel)
        contentView.addSubview(contentBgView)
        contentBgView.addSubview(desInfoTitleLabel)
        contentBgView.addSubview(contentLabel)
        contentBgView.addSubview(desPhotoTitleLabel)
        contentBgView.addSubview(boxPhotoView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var sectionModel: HCChatMainInfoModel! {
        didSet {
            timeLabel.text = sectionModel.createDate.stringTransform(mode: .yymmddhhmm1)
            contentLabel.text = sectionModel.content
            boxPhotoView.filles = sectionModel.fileListModel
            desPhotoTitleLabel.text = sectionModel.fileList.count > 0 ? "报告病例：" : ""
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        timeLabel.frame = sectionModel.getTimeFrame
        contentBgView.frame = sectionModel.getContentBgFrame
        desInfoTitleLabel.frame = sectionModel.getDesInfoTitleFrame
        contentLabel.frame = sectionModel.getContentTextFrame
        desPhotoTitleLabel.frame = sectionModel.getDesPhotoTitleFrame
        boxPhotoView.frame = sectionModel.getBoxPhotoFrame
    }
}
