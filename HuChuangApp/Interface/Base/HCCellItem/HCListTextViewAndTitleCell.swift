
//
//  HCListTextViewAndTitleCell.swift
//  HuChuangApp
//
//  Created by yintao on 2020/9/18.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCListTextViewAndTitleCell_identifier = "HCListTextViewAndTitleCell"

class HCListTextViewAndTitleCell: HCBaseListCell {

    private var textView: UITextView!

    public var textChangeCallBack: ((String)->())?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        clipsToBounds = true
        
        titleIcon.isHidden = true
        arrowImgV.isHidden = true
        bottomLine.isHidden = true
        
        textView = UITextView()
        textView.returnKeyType = .done
        textView.font = .font(fontSize: 15, fontName: .PingFRegular)
        textView.textColor = RGB(53, 53, 53)
        textView.layer.cornerRadius = 5
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = RGB(240, 240, 240).cgColor
        textView.backgroundColor = RGB(247, 247, 247)
        textView.delegate = self
        contentView.addSubview(textView)
                
        textView.snp.makeConstraints {
            $0.left.equalTo(12)
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.right.equalTo(-12)
            $0.bottom.equalTo(0)
        }
    }
        
    override var model: HCListCellItem! {
        didSet {
            super.model = model
            
            textView.text = model.detailTitle
            
            titleLabel.snp.remakeConstraints {
                $0.left.equalTo(12)
                $0.top.equalTo(0)
                $0.height.equalTo(50)
            }
        }
    }
}

extension HCListTextViewAndTitleCell: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }else {
            textChangeCallBack?(textView.text)
        }
        return true
    }
}

