//
//  HCConsultListCell.swift
//  HuChuangApp
//
//  Created by yintao on 2020/10/14.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCConsultListCell_identifier: String = "HCConsultListCell"
public let HCConsultListCell_height: CGFloat = 114

class HCConsultListCell: UITableViewCell {
    
    private var avatarImgV: UIImageView!
    private var statusLabel: UILabel!
    private var nameLabel: UILabel!
    private var sexIconImgV: UIImageView!
    private var ageLabel: UILabel!
    private var timeLabel: UILabel!
    
    private var markIconImgV: UIImageView!
    private var markContentLabel: UILabel!

    private var contentLabel: UILabel!
    private var bottomLine: UIView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public var model: HCConsultListItemModel! {
        didSet {
            avatarImgV.setImage(model.headPath, .userIconMen)
            nameLabel.text = model.userName
            ageLabel.text = "\(model.age)岁"
            timeLabel.text = model.createDate
            contentLabel.text = model.content
            markContentLabel.text = "需要确认字断"
            statusLabel.text = "需要确认字断"
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var tempSize: CGSize = .zero
        
        avatarImgV.frame = .init(x: 18, y: 15, width: 50, height: 50)
        
        tempSize = statusLabel.sizeThatFits(.init(width: CGFloat.greatestFiniteMagnitude, height: 12))
        tempSize.width = min(avatarImgV.width, tempSize.width)
        statusLabel.frame = .init(x: ((avatarImgV.width - tempSize.width) / 2.0) + avatarImgV.x, y: avatarImgV.frame.maxY + 7, width: tempSize.width, height: 12)
        
        tempSize = nameLabel.sizeThatFits(.init(width: CGFloat.greatestFiniteMagnitude, height: 17))
        tempSize.width = min(tempSize.width, 120)
        nameLabel.frame = .init(x: avatarImgV.frame.maxX + 15,
                                y: avatarImgV.frame.minY + 5,
                                width: tempSize.width, height: 17)
        
        sexIconImgV.frame = .init(x: nameLabel.frame.maxX + 3,
                                  y: ((nameLabel.height - 13) / 2) + nameLabel.frame.minY,
                                  width: 13, height: 13)
        
        tempSize = ageLabel.sizeThatFits(.init(width: CGFloat.greatestFiniteMagnitude, height: 12))
        ageLabel.frame = .init(x: sexIconImgV.frame.maxX + 5,
                               y: ((nameLabel.height - 12) / 2) + nameLabel.frame.minY,
                               width: tempSize.width,
                               height: 12)
        
        tempSize = timeLabel.sizeThatFits(.init(width: CGFloat.greatestFiniteMagnitude, height: 12))
        timeLabel.frame = .init(x: width - 12 - tempSize.width,
                                y: ((nameLabel.height - 12) / 2) + nameLabel.frame.maxY,
                                width: tempSize.width, height: tempSize.height)
        
        markIconImgV.frame = .init(x: nameLabel.x, y: nameLabel.frame.maxY + 5, width: 15, height: 12)
        markContentLabel.frame = .init(x: markIconImgV.frame.maxX + 3,
                                       y: markIconImgV.y + 1,
                                       width: timeLabel.x - nameLabel.x - 30,
                                       height: 10)
        
        tempSize = contentLabel.sizeThatFits(.init(width: timeLabel.frame.maxX - nameLabel.x,
                                                   height: CGFloat.greatestFiniteMagnitude))
        contentLabel.frame = .init(x: nameLabel.x,
                                   y: height - 15 - tempSize.height,
                                   width: tempSize.width,
                                   height: tempSize.height)
        
        bottomLine.frame = .init(x: nameLabel.x, y: height - 0.5, width: timeLabel.frame.maxX - nameLabel.x, height: 0.5)
    }
}

extension HCConsultListCell {
    
    private func initUI() {
        avatarImgV = UIImageView()
        avatarImgV.contentMode = .scaleAspectFill
        avatarImgV.clipsToBounds = true
        avatarImgV.layer.cornerRadius = 25
        
        statusLabel = UILabel()
        statusLabel.font = .font(fontSize: 11)
        statusLabel.textColor = RGB(51, 51, 51)
        
        nameLabel = UILabel()
        nameLabel.font = .font(fontSize: 16)
        nameLabel.textColor = RGB(12, 12, 12)
        
        sexIconImgV = UIImageView()
        sexIconImgV.contentMode = .scaleAspectFill
        sexIconImgV.backgroundColor = .red
        
        ageLabel = UILabel()
        ageLabel.font = .font(fontSize: 12)
        ageLabel.textColor = RGB(153, 153, 153)

        timeLabel = UILabel()
        timeLabel.font = .font(fontSize: 12)
        timeLabel.textColor = RGB(153, 153, 153)

        markIconImgV = UIImageView()
        markIconImgV.contentMode = .scaleAspectFill
        markIconImgV.backgroundColor = .red
        
        markContentLabel = UILabel()
        markContentLabel.font = .font(fontSize: 10)
        markContentLabel.textColor = RGB(255, 180, 4)
        
        contentLabel = UILabel()
        contentLabel.font = .font(fontSize: 12)
        contentLabel.textColor = RGB(153, 153, 153)
        contentLabel.numberOfLines = 2
        
        bottomLine = UIView()
        bottomLine.backgroundColor = RGB(241, 241, 241)
        
        addSubview(avatarImgV)
        addSubview(statusLabel)
        addSubview(nameLabel)
        addSubview(sexIconImgV)
        addSubview(ageLabel)
        addSubview(timeLabel)
        addSubview(markIconImgV)
        addSubview(markContentLabel)
        addSubview(contentLabel)
        addSubview(bottomLine)
    }
}