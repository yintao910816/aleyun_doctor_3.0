//
//  HCVideoConsultDaySettingCell.swift
//  HuChuangApp
//
//  Created by yintao on 2020/12/17.
//  Copyright © 2020 sw. All rights reserved.
//  排班时间

import UIKit

public let HCVideoConsultDaySettingCell_identifier = "HCVideoConsultDaySettingCell"
public let HCVideoConsultDaySettingCell_height: CGFloat = 70

class HCVideoConsultDaySettingCell: UICollectionViewCell {
    
    private var dateLabel: UILabel!
    private var markLabel: UILabel!
    private var timeLabel: UILabel!
    private var peosLabel: UILabel!
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

        timeLabel = UILabel()
        timeLabel.font = .font(fontSize: 14, fontName: .PingFSemibold)
        timeLabel.textColor = RGB(51, 51, 51)
        timeLabel.textAlignment = .center

        peosLabel = UILabel()
        peosLabel.font = .font(fontSize: 14, fontName: .PingFSemibold)
        peosLabel.textColor = RGB(51, 51, 51)
        peosLabel.textAlignment = .center

        remindLabel = UILabel()
        remindLabel.font = .font(fontSize: 14, fontName: .PingFSemibold)
        remindLabel.textColor = RGB(51, 51, 51)
        remindLabel.text = "暂无排班"
        remindLabel.textAlignment = .center

        addSubview(dateLabel)
        addSubview(markLabel)
        addSubview(timeLabel)
        addSubview(peosLabel)
        addSubview(remindLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var model: HCVideoDaySettingModel! {
        didSet {
            dateLabel.text = "\(model.date)(\(model.week))"
            markLabel.isHidden = !model.isToday
            if let m = model.settingModel {
                remindLabel.isHidden = true
                timeLabel.isHidden = false
                peosLabel.isHidden = false
                
                timeLabel.text = m.showTimeText
                peosLabel.text = "\(m.recevieNum)人"
            }else {
                remindLabel.isHidden = false
                timeLabel.isHidden = true
                peosLabel.isHidden = true
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
        
        dateLabel.frame = .init(x: 20, y: 8, width: width - 40, height: 16)

        if model.isToday {
            markLabel.frame = .init(x: width - 7 - 22, y: 10, width: 22, height: 12)
        }else {
            markLabel.frame = .zero
        }
        
        timeLabel.frame = .init(x: 20, y: dateLabel.frame.maxY + 2, width: width - 40, height: 16)
        peosLabel.frame = .init(x: 20, y: timeLabel.frame.maxY + 2, width: width - 40, height: 16)
        remindLabel.frame = .init(x: 20,
                                  y: dateLabel.frame.maxY + ((height - dateLabel.frame.maxY - 16) / 2),
                                  width: width - 40,
                                  height: 16)
    }
}
