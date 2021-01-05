//
//  HCPatientSearchCell.swift
//  HuChuangApp
//
//  Created by yintao on 2021/1/4.
//  Copyright © 2021 sw. All rights reserved.
//

import UIKit

public let HCPatientSearchCell_identifier: String = "HCPatientSearchCell"
public let HCPatientSearchCell_height: CGFloat = 56

class HCPatientSearchCell: UITableViewCell {

    private var avatarImgV: UIImageView!
    private var namelabel: UILabel!
    private var desLabel: UILabel!
    private var arrowImgV: UIImageView!
    private var bottomLine: UIView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        avatarImgV = UIImageView()
        avatarImgV.contentMode = .scaleAspectFill
        avatarImgV.clipsToBounds = true
        avatarImgV.layer.cornerRadius = 8
        
        namelabel = UILabel()
        namelabel.font = .font(fontSize: 16, fontName: .PingFMedium)
        namelabel.textColor = RGB(12, 12, 12)
        
        desLabel = UILabel()
        desLabel.font = .font(fontSize: 14)
        desLabel.textColor = RGB(159, 160, 161)

        arrowImgV = UIImageView(image: UIImage(named: "cell_right_arrow"))
        arrowImgV.contentMode = .scaleAspectFill

        bottomLine = UIView()
        bottomLine.backgroundColor = RGB(241, 241, 241)
        
        addSubview(avatarImgV)
        addSubview(namelabel)
        addSubview(desLabel)
        addSubview(arrowImgV)
        addSubview(bottomLine)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    public var groupPatientModel: HCPatientGroupListItemModel! {
        didSet {
            avatarImgV.setImage(groupPatientModel.headPath, .userIconWomen)
            namelabel.text = groupPatientModel.memberName
            desLabel.text = "来自分组: \(groupPatientModel.tagName)"
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avatarImgV.frame = .init(x: 15, y: 0, width: HCPatientSearchCell_height - 1, height: HCPatientSearchCell_height - 1)
        arrowImgV.frame = .init(x: width - 15 - 12, y: (height - 12) / 2, width: 9, height: 9)
        namelabel.frame = .init(x: avatarImgV.frame.maxX + 12, y: avatarImgV.y + 3, width: arrowImgV.x - avatarImgV.frame.maxX - 17, height: 20)
        desLabel.frame = .init(x: namelabel.x, y: avatarImgV.frame.maxY - 16 - 3, width: namelabel.width, height: 16)
        bottomLine.frame = .init(x: namelabel.x, y: height - 0.5, width: width - namelabel.x, height: 0.5)
    }
}
