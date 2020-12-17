//
//  HCSwitchCollectionCell.swift
//  HuChuangApp
//
//  Created by yintao on 2020/12/17.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCSwitchCollectionCell_identifier = "HCSwitchCollectionCell"

class HCSwitchCollectionCell: HCCollectionCell {
    
    private var switchView: UISwitch!
    
    override func loadView() {
        switchView = UISwitch()
        switchView.addTarget(self, action: #selector(changeValue(switch:)), for: .valueChanged)
        switchView.onTintColor = HC_MAIN_COLOR
        contentView.addSubview(switchView)
    }
    
    @objc private func changeValue(switch: UISwitch) {
        clickedSwitchCallBack?((switchView.isOn, model))
    }
    
    override var model: HCListCellItem! {
        didSet {
            super.model = model
            
            switchView.isOn = model.isOn
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if arrowImgV.superview != nil {
            arrowImgV.removeFromSuperview()
        }
        
        let tempSize = switchView.sizeThatFits(.init(width: CGFloat.greatestFiniteMagnitude, height: height))
        switchView.frame = .init(x: width - 15 - tempSize.width,
                                 y: (height - tempSize.height) / 2,
                                 width: tempSize.width,
                                 height: tempSize.height)
    }
    
}
