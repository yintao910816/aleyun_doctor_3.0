//
//  HCConsultChatStatusView.swift
//  HuChuangApp
//
//  Created by yintao on 2020/11/6.
//  Copyright © 2020 sw. All rights reserved.
//  聊天室咨询状态

import UIKit

class HCConsultChatStatusView: UIView {

    private var consultStatusContent: UIView!
    private var consultStatusLabel: UILabel!
    private var consultStatusDetailLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = RGB(238, 247, 255)
        
        consultStatusContent = UIView()
        consultStatusContent.backgroundColor = RGB(238, 247, 255)
        consultStatusContent.isHidden = true
        
        consultStatusLabel = UILabel()
        consultStatusLabel.textColor = RGB(91, 113, 145)
        consultStatusLabel.font = .font(fontSize: 16)

        consultStatusDetailLabel = UILabel()
        consultStatusDetailLabel.textAlignment = .right
        consultStatusDetailLabel.textColor = RGB(91, 113, 145)
        consultStatusDetailLabel.font = .font(fontSize: 16)

        addSubview(consultStatusContent)
        consultStatusContent.addSubview(consultStatusLabel)
        consultStatusContent.addSubview(consultStatusDetailLabel)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public var sectionModel: HCChatMainInfoModel? {
        didSet {
            consultStatusContent.isHidden = sectionModel == nil
            consultStatusLabel.text = sectionModel?.statusText
            if sectionModel?.isExpire == true {
                consultStatusDetailLabel.attributedText = NSAttributedString(string: "")
            }else {
                consultStatusDetailLabel.attributedText = sectionModel?.statusDetailText
            }
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    /// 等待超时
    public var isExpire: Bool = false {
        didSet {
            if isExpire {
                consultStatusDetailLabel.attributedText = NSAttributedString(string: "")
            }else {
                consultStatusDetailLabel.attributedText = sectionModel?.statusDetailText
            }
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        consultStatusContent.frame = bounds
        
        let labelSize = consultStatusLabel.sizeThatFits(.init(width: CGFloat.greatestFiniteMagnitude, height: 18))
        consultStatusLabel.frame = .init(x: 15,
                                         y: (height - 18) / 2,
                                         width: labelSize.width,
                                         height: 18)

        consultStatusDetailLabel.frame = .init(x: consultStatusLabel.frame.maxX + 20,
                                               y: (height - 18) / 2,
                                               width: width - consultStatusLabel.frame.maxX - 20 - 15,
                                               height: 18)
    }

}
