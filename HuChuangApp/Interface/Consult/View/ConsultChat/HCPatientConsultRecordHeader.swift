//
//  HCPatientConsultRecordHeader.swift
//  HuChuangApp
//
//  Created by yintao on 2020/5/28.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCPatientConsultRecordHeader_identifier = "HCPatientConsultRecordHeader_identifier"
public let HCPatientConsultRecordHeader_height: CGFloat = 33

class HCPatientConsultRecordHeader: UITableViewHeaderFooterView {

    private var titleLabel: UILabel!
    private var subTitleLabel: UILabel!
    private var statusLabel: UILabel!
    private var bottomLine: UIView!

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        titleLabel = UILabel()
        titleLabel.font = .font(fontSize: 13, fontName: .PingFMedium)
        titleLabel.textColor = RGB(136, 136, 136)
        titleLabel.textAlignment = .center

        subTitleLabel = UILabel()
        subTitleLabel.font = .font(fontSize: 11, fontName: .PingFRegular)
        subTitleLabel.textColor = RGB(136, 136, 136)
        subTitleLabel.textAlignment = .center
        subTitleLabel.clipsToBounds = true
        subTitleLabel.layer.borderWidth = 0.5
        
        statusLabel = UILabel()
        statusLabel.font = .font(fontSize: 13, fontName: .PingFRegular)
        statusLabel.textColor = RGB(136, 136, 136)
        statusLabel.textAlignment = .center

        bottomLine = UIView()
        bottomLine.backgroundColor = RGB(246, 246, 246)
        
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(statusLabel)
        addSubview(bottomLine)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var model: HCConsultDetailItemModel! {
        didSet {
            titleLabel.text = model.titleText
            subTitleLabel.text = model.subTitleText
            subTitleLabel.textColor = model.subTitleColor
            subTitleLabel.layer.borderColor = model.subTitleColor.cgColor
            statusLabel.text = model.statusText
            statusLabel.textColor = model.statusColor
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        titleLabel.frame = model.getTitleFrame
        subTitleLabel.frame = model.getSubTitleFrame
        statusLabel.frame = model.getStatusFrame
        bottomLine.frame = .init(x: 15, y: height-0.5, width: width - 15 * 2, height: 0.5)
        
        if subTitleLabel.layer.cornerRadius == 0 {
            subTitleLabel.layer.cornerRadius = subTitleLabel.frame.height / 2.0
        }
    }
}
