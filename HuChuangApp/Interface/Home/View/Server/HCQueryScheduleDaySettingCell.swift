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
    private var markLabel: UILabel!
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

        markLabel = UILabel()
        markLabel.font = .font(fontSize: 9, fontName: .PingFSemibold)
        markLabel.textColor = RGB(14, 103, 217)
        markLabel.backgroundColor = RGB(193, 217, 255)
        markLabel.layer.cornerRadius = 6
        markLabel.clipsToBounds = true
        markLabel.textAlignment = .center
        markLabel.text = "今天"

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
        addSubview(markLabel)
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
            markLabel.isHidden = !model.isToday
            if let m = model.settingModel {
                remindLabel.isHidden = true
                morningtimeLabel.isHidden = false
                afternoonLabel.isHidden = false
                
                morningtimeLabel.text = "上午 \(m.morningNum)人"
                afternoonLabel.text = "下午 \(m.afternoonNum)人"
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
        
        dateLabel.frame = .init(x: 33, y: 8, width: width - 66, height: 16)

        if model.isToday {
//            var dateSize = dateLabel.sizeThatFits(.init(width: CGFloat.greatestFiniteMagnitude,
//                                                        height: 14))
//            dateSize.width = min(dateSize.width, width - 20 - 4 - 22 - 7)

            markLabel.frame = .init(x: width - 7 - 22,
                                    y: 10,
                                    width: 22,
                                    height: 12)
        }else {
            markLabel.frame = .zero
        }
        
        morningtimeLabel.frame = .init(x: 20, y: dateLabel.frame.maxY + 2, width: width - 40, height: 16)
        afternoonLabel.frame = .init(x: 20, y: morningtimeLabel.frame.maxY + 2, width: width - 40, height: 16)
        remindLabel.frame = .init(x: 20,
                                  y: dateLabel.frame.maxY + ((height - dateLabel.frame.maxY - 16) / 2),
                                  width: width - 40,
                                  height: 16)
    }
}
