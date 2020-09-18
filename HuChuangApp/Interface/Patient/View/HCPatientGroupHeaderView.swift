//
//  HCPatientGroupHeaderView.swift
//  HuChuangApp
//
//  Created by yintao on 2020/9/18.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCPatientGroupHeaderView_identifier = "HCPatientGroupHeaderView"
public let HCPatientGroupHeaderView_height: CGFloat = 35

class HCPatientGroupHeaderView: UITableViewHeaderFooterView {

    private var titleLabel: UILabel!
    private var expandButton: UIButton!
    
    public var expandAction: (()->())?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var model: HCPatientGroupListModel! {
        didSet {
            titleLabel.text = model.tagName
            
            expandButton.isHidden = model.memberList.count == 0
            expandButton.isSelected = model.isExpand
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var tempSize = titleLabel.sizeThatFits(.init(width: CGFloat(MAXFLOAT), height: height))
        titleLabel.frame = .init(x: 15, y: 0, width: tempSize.width, height: height)
        
        tempSize = expandButton.sizeThatFits(.init(width: CGFloat(MAXFLOAT), height: height))
        expandButton.frame = .init(x: width - 15 - tempSize.width, y: 0, width: tempSize.width, height: height)
    }
}

extension HCPatientGroupHeaderView {
    
    private func initUI() {
        contentView.backgroundColor = RGB(247, 247, 247)
        
        titleLabel = UILabel()
        titleLabel.font = .font(fontSize: 14, fontName: .PingFMedium)
        titleLabel.textColor = RGB(153, 153, 153)
        
        expandButton = UIButton()
        expandButton.setTitleColor(RGB(153, 153, 153), for: .normal)
        expandButton.titleLabel?.font = .font(fontSize: 14, fontName: .PingFMedium)
        expandButton.setTitle("收起", for: .selected)
        expandButton.setTitle("展开", for: .normal)
        expandButton.addTarget(self, action: #selector(expandOperation), for: .touchUpInside)

        addSubview(titleLabel)
        addSubview(expandButton)
    }
    
    @objc private func expandOperation() {
        model.isExpand = !model.isExpand
        expandButton.isSelected = model.isExpand
        
        expandAction?()
    }
}
