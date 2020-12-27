//
//  HCFastReplyCell.swift
//  HuChuangApp
//
//  Created by yintao on 2020/11/7.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCFastReplyCell_identifier = "HCFastReplyCell"
public let HCFastReplyCell_height: CGFloat = 80

class HCFastReplyCell: UITableViewCell {

    private var titleLabel: UILabel!
    private var subTitleLabel: UILabel!
    private var markLabel: UILabel!
    private var coverImg: UIImageView!
    private var sendButton: UIButton!
    private var lineView: UIView!
    
    public var sendActionCallBack:((HCFastReplyModel)->())?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    
    public var model: HCFastReplyModel! {
        didSet {
            coverImg.setImage(model.imagePath)
            titleLabel.text = model.content
//            subTitleLabel.text = model.content
            markLabel.text = "备注：\(model.title)"
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        sendButton.frame = .init(x: width - 15 - 25, y: (height - 25) / 2, width: 25, height: 25)
        coverImg.frame = .init(x: sendButton.frame.minX - 20 - 58,
                               y: (height - 58) / 2,
                               width: 58, height: 58)
        titleLabel.frame = .init(x: 15, y: 10,
                                 width: coverImg.frame.minX - 15 - 15,
                                 height: 16)
        subTitleLabel.frame = .init(x: titleLabel.x,
                                    y: titleLabel.frame.maxY + 3,
                                    width: titleLabel.width,
                                    height: 16)
        markLabel.frame = .init(x: titleLabel.x,
                                y: subTitleLabel.frame.maxY + 6,
                                width: titleLabel.width,
                                height: 13)
        lineView.frame = .init(x: 0, y: height - 0.5, width: width, height: 0.5)
    }
}

extension HCFastReplyCell {
    
    private func setupUI() {
        titleLabel = UILabel()
        titleLabel.textColor = RGB(12, 12, 12)
        titleLabel.font = .font(fontSize: 14, fontName: .PingFMedium)
        
        subTitleLabel = UILabel()
        subTitleLabel.textColor = RGB(98, 161, 245)
        subTitleLabel.font = .font(fontSize: 14, fontName: .PingFMedium)

        markLabel = UILabel()
        markLabel.textColor = RGB(102, 102, 102)
        markLabel.font = .font(fontSize: 12)

        coverImg = UIImageView()
        coverImg.backgroundColor = .clear
        coverImg.layer.cornerRadius = 8
        coverImg.clipsToBounds = true
        coverImg.contentMode = .scaleAspectFill
        
        sendButton = UIButton()
        sendButton.setImage(UIImage.init(named: "fast_reply_send"), for: .normal)
        sendButton.addTarget(self, action: #selector(sendAction), for: .touchUpInside)
        
        lineView = UIView()
        lineView.backgroundColor = RGB(247, 247, 247)
        
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(markLabel)
        addSubview(coverImg)
        addSubview(sendButton)
        addSubview(lineView)
    }
    
    @objc private func sendAction() {
        sendActionCallBack?(model)
    }
}
