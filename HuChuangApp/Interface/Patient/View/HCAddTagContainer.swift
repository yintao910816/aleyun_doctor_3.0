//
//  HCAddTagContainer.swift
//  HuChuangApp
//
//  Created by sw on 2021/1/7.
//  Copyright © 2021 sw. All rights reserved.
//

import UIKit

class HCAddTagContainer: UIView {
    
    private var tfBg: UIView!
    public var textTf: UITextField!
    public var saveButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tfBg.frame = .init(x: 0, y: 10, width: width, height: 50)
        textTf.frame = .init(x: 15, y: 10, width: tfBg.width - 30, height: 30)
        saveButton.frame = .init(x: 0, y: height - 49, width: width, height: 49)
    }
}

extension HCAddTagContainer {
    
    private func initUI() {
        backgroundColor = RGB(247, 247, 247)
        
        tfBg = UIView()
        tfBg.backgroundColor = .white
        
        textTf = UITextField()
        textTf.font = .font(fontSize: 16)
        textTf.textColor = RGB(12, 12, 12)
        textTf.borderStyle = .none
        textTf.returnKeyType = .done
        textTf.delegate = self
        textTf.placeholder = "请输入标签内容"
        
        saveButton = UIButton(type: .system)
        saveButton.titleLabel?.font = .font(fontSize: 16, fontName: .PingFSemibold)
        saveButton.setTitle("保存设置", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.backgroundColor = RGB(75, 138, 239)
                
        addSubview(tfBg)
        tfBg.addSubview(textTf)
        addSubview(saveButton)
    }
}

extension HCAddTagContainer: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

