//
//  HCListTextViewCell.swift
//  HuChuangApp
//
//  Created by yintao on 2020/5/16.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCListTextViewCell_identifier = "HCListTextViewCell_identifier"

class HCListTextViewCell: HCBaseListCell {

    private var textView: UITextView!
    private var saveButton: UIButton!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        clipsToBounds = true
        
        titleLabel.isHidden = true
        titleIcon.isHidden = true
        arrowImgV.isHidden = true
        
        textView = UITextView()
        textView.returnKeyType = .done
        textView.font = .font(fontSize: 15, fontName: .PingFRegular)
        textView.textColor = RGB(53, 53, 53)
        textView.layer.cornerRadius = 5
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = RGB(240, 240, 240).cgColor
        textView.delegate = self
        contentView.addSubview(textView)
        
        saveButton = UIButton()
        saveButton.setTitle("保存", for: .normal)
        saveButton.titleLabel?.font = .font(fontSize: 13, fontName: .PingFRegular)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.backgroundColor = HC_MAIN_COLOR
        saveButton.layer.cornerRadius = 12.5
        saveButton.clipsToBounds = true
        saveButton.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        contentView.addSubview(saveButton)
    }
    
    @objc private func saveAction() {
        model.detailTitle = textView.text
        didEndEditWithModel?(model)
    }
    
    override var model: HCListCellItem! {
        didSet {
            super.model = model
            
            textView.isUserInteractionEnabled = model.inputEnable
            textView.text = model.detailTitle
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textView.frame = .init(x: 15, y: 0, width: width - 30, height: height - 5 - 25 - 10)
        saveButton.frame = .init(x: width - 15 - 70, y: textView.frame.maxY + 10, width: 70, height: 25)
    }
}

extension HCListTextViewCell: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
}
