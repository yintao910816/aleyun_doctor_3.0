//
//  HCServerSettingCell.swift
//  HuChuangApp
//
//  Created by yintao on 2020/12/17.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCServerSettingCell_identifier = "HCServerSettingCell"
public let HCServerSettingCell_height: CGFloat = 80

class HCServerSettingCell: UICollectionViewCell {

    private var iconImgV: UIImageView!
    private var titleLabel: UILabel!
    private var subTitleLabel: UILabel!
    private var actionButton: UIButton!
    
    public var actionCallBack: ((HCServerSettingModel)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        iconImgV = UIImageView()
        iconImgV.clipsToBounds = true
        iconImgV.backgroundColor = RGB(245, 245, 245)
        
        titleLabel = UILabel()
        titleLabel.textColor = RGB(12, 12, 12)
        titleLabel.font = .font(fontSize: 16)
        
        subTitleLabel = UILabel()
        subTitleLabel.textColor = RGB(153, 153, 153)
        subTitleLabel.font = .font(fontSize: 14)
        
        actionButton = UIButton()
        actionButton.backgroundColor = RGB(75, 138, 239)
        actionButton.setTitle("管理", for: .normal)
        actionButton.titleLabel?.font = .font(fontSize: 14)
        actionButton.setTitleColor(.white, for: .normal)
        actionButton.layer.cornerRadius = 3
        actionButton.clipsToBounds = true
        actionButton.isUserInteractionEnabled = false
        
        addSubview(iconImgV)
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(actionButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var model: HCServerSettingModel! {
        didSet {
            iconImgV.image = model.icon
            titleLabel.text = model.title
            subTitleLabel.text = model.subTitle
            actionButton.isHidden = model.actionTitle.count == 0
            actionButton.setTitle(model.actionTitle, for: .normal)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconImgV.frame = .init(x: 15, y: 15, width: height - 30, height: height - 30)
        
        let tempSize = actionButton.sizeThatFits(.init(width: CGFloat.greatestFiniteMagnitude, height: 28))
        actionButton.frame = .init(x: width - tempSize.width - 15 - 40,
                                   y: (height - 28) / 2,
                                   width: tempSize.width + 40,
                                   height: 28)
        
        titleLabel.frame = .init(x: iconImgV.frame.maxX + 10,
                                 y: (height - 20 - 2 - 16) / 2,
                                 width: actionButton.frame.maxX - iconImgV.frame.maxX - 10 - 10,
                                 height: 20)
        
        subTitleLabel.frame = .init(x: titleLabel.x,
                                    y: titleLabel.frame.maxY + 2,
                                    width: titleLabel.width,
                                    height: 16)

        if iconImgV.layer.cornerRadius == 0 {
            iconImgV.layer.cornerRadius = iconImgV.width / 2
        }
    }
    
    private func actions() {
        actionCallBack?(model)
    }
}
