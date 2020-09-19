//
//  HCEditTagContainer.swift
//  HuChuangApp
//
//  Created by yintao on 2020/9/19.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCEditTagContainer: UIView {

    private var tfBg: UIView!
    public var textTf: UITextField!
    public var saveButton: UIButton!
    public var removeButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var defaultContent: String = "" {
        didSet {
            textTf.text = defaultContent
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tfBg.frame = .init(x: 0, y: 10, width: width, height: 50)
        textTf.frame = .init(x: 15, y: 10, width: tfBg.width - 30, height: 30)
        removeButton.frame = .init(x: 0, y: height - 49, width: width / 2, height: 49)
        saveButton.frame = .init(x: removeButton.frame.maxX, y: removeButton.y, width: removeButton.width, height: removeButton.height)
    }
}

extension HCEditTagContainer {
    
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
        
        removeButton = UIButton(type: .system)
        removeButton.titleLabel?.font = .font(fontSize: 16)
        removeButton.setTitle("删除", for: .normal)
        removeButton.setTitleColor(RGB(41, 38, 33), for: .normal)
        removeButton.backgroundColor = .white
        
        addSubview(tfBg)
        tfBg.addSubview(textTf)
        addSubview(saveButton)
        addSubview(removeButton)
    }
}

extension HCEditTagContainer: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
