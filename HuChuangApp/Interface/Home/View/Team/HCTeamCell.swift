//
//  HCTeamCell.swift
//  HuChuangApp
//
//  Created by sw on 2021/2/4.
//  Copyright © 2021 sw. All rights reserved.
//

import UIKit

public enum HCTeamCellMode {
    case myTeam
    case addMember
    case teamContainMe
}

public let HCTeamCell_identifier = "HCTeamCell"
public let HCTeamCell_height: CGFloat = 80

class HCTeamCell: UITableViewCell {

    private var avatarImgV: UIImageView!
    private var nameLabel: UILabel!
    private var subLabel: UILabel!
    private var detailIcon: UIButton!
    private var bottomLine: UIView!
    private var markLabel: UILabel!
    
    public var mode: HCTeamCellMode = .myTeam {
        didSet {
            if mode == .myTeam {
                detailIcon.setImage(UIImage(named: "cell_right_arrow"), for: .normal)
            }else if mode == .teamContainMe {
                markLabel.isHidden = false
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var model: HCTeamItemModel! {
        didSet {
            avatarImgV.setImage(model.headPath, .userIconMen)
            nameLabel.text = model.userName
            subLabel.text = model.technicalPost
            
            if mode == .addMember {
                if model.isEnableSelected {
                    detailIcon.isUserInteractionEnabled = true
                    let image = model.isSelected ? UIImage(named: "team_selected") : UIImage(named: "team_un_selected")
                    detailIcon.setImage(image, for: .normal)
                }else {
                    detailIcon.isUserInteractionEnabled = false
                    detailIcon.setImage(UIImage(named: "team_forbidden_selected"), for: .normal)
                }
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        avatarImgV.frame = .init(x: 15, y: 15, width: height - 30, height: height - 30)
        if avatarImgV.layer.cornerRadius == 0 {
            avatarImgV.layer.cornerRadius = avatarImgV.height / 2
        }
        
        if let size = detailIcon.imageView?.image?.size {
            detailIcon.frame = .init(x: width - 15 - size.width, y: (height - size.height) / 2, width: size.width, height: size.height)
        }

        switch mode {
        case .myTeam, .addMember:
            nameLabel.frame = .init(x: avatarImgV.frame.maxX + 15, y: avatarImgV.y + 3, width: detailIcon.x - avatarImgV.frame.maxX - 30, height: 19)
            subLabel.frame = .init(x: nameLabel.x, y: avatarImgV.frame.maxY - 3 - 14, width: nameLabel.width, height: 14)
            bottomLine.frame = .init(x: 0, y: height - 0.5, width: width, height: 0.5)
        case .teamContainMe:
            nameLabel.frame = .init(x: avatarImgV.frame.maxX + 15, y: avatarImgV.y + 3, width: width - avatarImgV.frame.maxX - 30, height: 19)

            let size = subLabel.sizeThatFits(.init(width: CGFloat.greatestFiniteMagnitude, height: 17))
            subLabel.frame = .init(x: nameLabel.x, y: avatarImgV.frame.maxY - 3 - 14, width: size.width, height: 17)
            
            markLabel.frame = .init(x: subLabel.frame.maxX + 10, y: subLabel.y + 1.5, width: 30, height: 17)

            bottomLine.frame = .init(x: 0, y: height - 0.5, width: width, height: 0.5)
        }
        
    }
}

extension HCTeamCell {
    
    private func setupUI() {
        selectionStyle = .none
        
        avatarImgV = UIImageView()
        avatarImgV.contentMode = .scaleAspectFill
        avatarImgV.clipsToBounds = true
        
        nameLabel = UILabel()
        nameLabel.font = .font(fontSize: 18, fontName: .PingFSemibold)
        nameLabel.textColor = RGB(51, 51, 51)
        
        subLabel = UILabel()
        subLabel.font = .font(fontSize: 13)
        subLabel.textColor = RGB(153, 153, 153)

        detailIcon = UIButton()
        detailIcon.isUserInteractionEnabled = false
        detailIcon.addTarget(self, action: #selector(selectedAction), for: .touchUpInside)

        markLabel = UILabel()
        markLabel.font = .font(fontSize: 10)
        markLabel.textColor = .white
        markLabel.text = " 组长 "
        markLabel.isHidden = true
        markLabel.backgroundColor = HC_MAIN_COLOR
        markLabel.layer.cornerRadius = 3
        markLabel.clipsToBounds = true

        bottomLine = UIView()
        bottomLine.backgroundColor = RGB(241, 241, 241)
        
        contentView.addSubview(avatarImgV)
        contentView.addSubview(nameLabel)
        contentView.addSubview(subLabel)
        contentView.addSubview(detailIcon)
        contentView.addSubview(bottomLine)
        contentView.addSubview(markLabel)
    }
    
    @objc private func selectedAction() {
        model.isSelected = !model.isSelected
        let image = model.isSelected ? UIImage(named: "team_selected") : UIImage(named: "team_un_selected")
        detailIcon.setImage(image, for: .normal)
    }
}
