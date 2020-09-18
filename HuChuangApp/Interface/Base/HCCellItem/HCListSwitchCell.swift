//
//  HCListSwitchCell.swift
//  HuChuangApp
//
//  Created by yintao on 2019/9/30.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

public let HCListSwitchCell_identifier = "HCListSwitchCell"

class HCListSwitchCell: HCBaseListCell {

    private var switchView: UISwitch!
    
    override func loadView() {
        switchView = UISwitch()
        switchView.addTarget(self, action: #selector(changeValue(s:)), for: .valueChanged)
        switchView.onTintColor = HC_MAIN_COLOR
        
        contentView.addSubview(switchView)
        
        arrowImgV.snp.makeConstraints{
            $0.right.equalTo(-15)
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.size.equalTo(CGSize.zero)
        }
        
        switchView.snp.makeConstraints {
            $0.right.equalTo(arrowImgV.snp.left).offset(0)
            $0.centerY.equalTo(arrowImgV.snp.centerY)
        }
    }
    
    @objc private func changeValue(s: UISwitch) {
        switchCallBack?(s.isOn)
    }
    
    override var model: HCListCellItem! {
        didSet {
            super.model = model
            
            switchView.isOn = model.isOn
        }
    }
}
