//
//  HCVerificationCell.swift
//  HuChuangApp
//
//  Created by sw on 2021/1/6.
//  Copyright © 2021 sw. All rights reserved.
//

import UIKit

public let HCVerificationCell_identifier = "HCVerificationCell"
public let HCVerificationCell_height: CGFloat = 90

class HCVerificationCell: UITableViewCell {

    private var memberNameLabel: UILabel!
    private var beginTimeLabel: UILabel!
    private var endTimeLabel: UILabel!
    private var bottomLine: UIView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var model: HCVerificationItemModel! {
        didSet {
            memberNameLabel.text = model.memberNameText
            beginTimeLabel.text = model.beginTimeText
            endTimeLabel.text = model.endTimeText
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        memberNameLabel.frame = .init(x: 25, y: 10, width: width - 50, height: 15)
        beginTimeLabel.frame = .init(x: memberNameLabel.x, y: memberNameLabel.frame.maxY + 8, width: memberNameLabel.width, height: 15)
        endTimeLabel.frame = .init(x: memberNameLabel.x, y: beginTimeLabel.frame.maxY + 8, width: memberNameLabel.width, height: 15)
        bottomLine.frame = .init(x: 0, y: height - 0.5, width: width, height: 0.5)
    }
}

extension HCVerificationCell {
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .white
        
        memberNameLabel = UILabel()
        memberNameLabel.font = .font(fontSize: 14)
        memberNameLabel.textColor = RGB(102, 102, 102)
        
        beginTimeLabel = UILabel()
        beginTimeLabel.font = .font(fontSize: 14)
        beginTimeLabel.textColor = RGB(102, 102, 102)

        endTimeLabel = UILabel()
        endTimeLabel.font = .font(fontSize: 14)
        endTimeLabel.textColor = RGB(102, 102, 102)

        bottomLine = UIView()
        bottomLine.backgroundColor = RGB(241, 241, 241)
        
        addSubview(memberNameLabel)
        addSubview(beginTimeLabel)
        addSubview(endTimeLabel)
        addSubview(bottomLine)
    }
}
