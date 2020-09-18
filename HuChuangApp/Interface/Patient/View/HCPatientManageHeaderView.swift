//
//  HCPatientManageHeaderView.swift
//  HuChuangApp
//
//  Created by yintao on 2020/9/18.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCPatientManageHeaderView_identifier = "HCPatientManageHeaderView"
public let HCPatientManageHeaderView_height: CGFloat = 80

class HCPatientManageHeaderView: UITableViewHeaderFooterView {

    private var avatarImgV: UIImageView!
    private var nameLabel: UILabel!
    private var sexImgV: UIImageView!
    private var ageLabel: UILabel!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var model: HCPatientItemModel! {
        didSet {
            avatarImgV.setImage(model.headPath)
            nameLabel.text = model.memberName
            ageLabel.text = "未知"
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avatarImgV.frame = .init(x: 15, y: (height - 50) / 2.0, width: 50, height: 50)
        
        var tempSize = nameLabel.sizeThatFits(.init(width: CGFloat(MAXFLOAT), height: 17))
        nameLabel.frame = .init(x: avatarImgV.frame.maxX + 15, y: (height - 17) / 2.0, width: tempSize.width, height: 17)
        
        sexImgV.frame = .init(x: nameLabel.frame.maxX + 11, y: (height - 13) / 2.0, width: 13, height: 13)
        
        tempSize = ageLabel.sizeThatFits(.init(width: CGFloat(MAXFLOAT), height: 13))
        ageLabel.frame = .init(x: sexImgV.frame.maxX + 11, y: (height - 13) / 2, width: tempSize.width, height: 13)
    }
}

extension HCPatientManageHeaderView {
    
    private func initUI() {
        avatarImgV = UIImageView()
        avatarImgV.layer.cornerRadius = 25
        avatarImgV.contentMode = .scaleAspectFill
        avatarImgV.clipsToBounds = true
        
        nameLabel = UILabel()
        nameLabel.textColor = RGB(12, 12, 12)
        nameLabel.font = .font(fontSize: 16)
        
        sexImgV = UIImageView()
        sexImgV.image = UIImage(named: "sex_girl")
        
        ageLabel = UILabel()
        ageLabel.textColor = RGB(153, 153, 153)
        ageLabel.font = .font(fontSize: 12)

        addSubview(avatarImgV)
        addSubview(nameLabel)
        addSubview(sexImgV)
        addSubview(ageLabel)
    }
}
