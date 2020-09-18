//
//  HCMyPatientListCell.swift
//  HuChuangApp
//
//  Created by yintao on 2020/9/18.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCMyPatientListCell_identifier: String = "HCMyPatientListCell"

class HCMyPatientListCell: UITableViewCell {

    private var avatarImgV: UIImageView!
    private var namelabel: UILabel!
    private var bottomLine: UIView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        avatarImgV = UIImageView()
        avatarImgV.contentMode = .scaleAspectFill
        avatarImgV.clipsToBounds = true
        avatarImgV.layer.cornerRadius = 17.5
        
        namelabel = UILabel()
        namelabel.font = .font(fontSize: 16)
        namelabel.textColor = RGB(12, 12, 12)
        
        bottomLine = UIView()
        bottomLine.backgroundColor = RGB(241, 241, 241)
        
        addSubview(avatarImgV)
        addSubview(namelabel)
        addSubview(bottomLine)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var model: HCPatientItemModel! {
        didSet {
            avatarImgV.setImage(model.headPath, .userIconWomen)
            namelabel.text = model.memberName
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avatarImgV.frame = .init(x: 15, y: (height - 35) / 2.0, width: 35, height: 35)
        namelabel.frame = .init(x: avatarImgV.frame.maxX + 7, y: (height - 17) / 2, width: width - avatarImgV.frame.maxX - 22.0, height: 17)
        bottomLine.frame = .init(x: 0, y: height - 0.5, width: width, height: 0.5)
    }
}
