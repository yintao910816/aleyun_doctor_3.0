//
//  HCQueryScheduleDaySettingCell.swift
//  HuChuangApp
//
//  Created by yintao on 2020/12/17.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCQueryScheduleDaySettingCell_identifier = "HCQueryScheduleDaySettingCell"
public let HCQueryScheduleDaySettingCell_height: CGFloat = 70

class HCQueryScheduleDaySettingCell: UICollectionViewCell {
    
    private var dateLabel: UILabel!
    private var morningtimeLabel: UILabel!
    private var afternoonLabel: UILabel!
    private var remindLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = RGB(248, 248, 250)
        
        layer.cornerRadius = 3
        layer.borderWidth = 1
        layer.borderColor = UIColor.clear.cgColor
        clipsToBounds = true

        dateLabel = UILabel()
        dateLabel.font = .font(fontSize: 12)
        dateLabel.textColor = RGB(51, 51, 51)
        dateLabel.textAlignment = .center

        morningtimeLabel = UILabel()
        morningtimeLabel.font = .font(fontSize: 14, fontName: .PingFSemibold)
        morningtimeLabel.textColor = RGB(51, 51, 51)
        morningtimeLabel.textAlignment = .center

        afternoonLabel = UILabel()
        afternoonLabel.font = .font(fontSize: 14, fontName: .PingFSemibold)
        afternoonLabel.textColor = RGB(51, 51, 51)
        afternoonLabel.textAlignment = .center

        remindLabel = UILabel()
        remindLabel.font = .font(fontSize: 14, fontName: .PingFSemibold)
        remindLabel.textColor = RGB(51, 51, 51)
        remindLabel.text = "暂无排班"
        remindLabel.textAlignment = .center

        addSubview(dateLabel)
        addSubview(morningtimeLabel)
        addSubview(afternoonLabel)
        addSubview(remindLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var model: HCQueryScheduleSettingModel! {
        didSet {
            dateLabel.text = "\(model.date)(\(model.week))"
            if let m = model.settingModel {
                remindLabel.isHidden = true
                morningtimeLabel.isHidden = false
                afternoonLabel.isHidden = false
                
                morningtimeLabel.attributedText = m.morningNumText
                afternoonLabel.attributedText = m.afternoonNumText
            }else {
                remindLabel.isHidden = false
                morningtimeLabel.isHidden = true
                afternoonLabel.isHidden = true
            }
            
            if model.isSelected {
                backgroundColor = RGB(226, 237, 255)
                layer.borderColor = HC_MAIN_COLOR.cgColor
            }else {
                backgroundColor = RGB(248, 248, 250)
                layer.borderColor = UIColor.clear.cgColor
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        dateLabel.frame = .init(x: 10, y: 8, width: width - 20, height: 16)
        
        morningtimeLabel.frame = .init(x: dateLabel.x, y: dateLabel.frame.maxY + 2, width: dateLabel.width, height: 16)
        afternoonLabel.frame = .init(x: dateLabel.x, y: morningtimeLabel.frame.maxY + 2, width: dateLabel.width, height: 16)
        remindLabel.frame = .init(x: dateLabel.x,
                                  y: dateLabel.frame.maxY + ((height - dateLabel.frame.maxY - 16) / 2),
                                  width: dateLabel.width,
                                  height: 16)
    }
}
