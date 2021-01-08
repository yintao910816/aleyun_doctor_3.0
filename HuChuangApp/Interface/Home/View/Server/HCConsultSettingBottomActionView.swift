//
//  HCConsultSettingBottomActionView.swift
//  HuChuangApp
//
//  Created by yintao on 2020/12/17.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

enum HCConsultSettingAction {
    case close
    case save
}

class HCConsultSettingBottomActionView: UIView {

    private var closeButton: UIButton!
    private var saveButton: UIButton!
    
    public var actionCallBack: ((HCConsultSettingAction)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        closeButton = UIButton()
        closeButton.setTitle("关闭", for: .normal)
        closeButton.addTarget(self, action: #selector(actions(button:)), for: .touchUpInside)
        closeButton.setTitleColor(RGB(41, 38, 33), for: .normal)
        closeButton.titleLabel?.font = .font(fontSize: 16)
        closeButton.backgroundColor = .white
        
        saveButton = UIButton()
        saveButton.setTitle("保存设置", for: .normal)
        saveButton.addTarget(self, action: #selector(actions(button:)), for: .touchUpInside)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.titleLabel?.font = .font(fontSize: 16)
        saveButton.backgroundColor = HC_MAIN_COLOR

        addSubview(closeButton)
        addSubview(saveButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setTitle(leftTitle: String, rightTitle: String) {
        closeButton.setTitle(leftTitle, for: .normal)
        saveButton.setTitle(rightTitle, for: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        closeButton.frame = .init(x: 0, y: 0, width: width / 2, height: height)
        saveButton.frame = .init(x: closeButton.frame.maxX, y: 0, width: closeButton.width, height: closeButton.height)
    }
    
    @objc private func actions(button: UIButton) {
        if button == closeButton {
            actionCallBack?(.close)
        }else {
            actionCallBack?(.save)
        }
    }
}
