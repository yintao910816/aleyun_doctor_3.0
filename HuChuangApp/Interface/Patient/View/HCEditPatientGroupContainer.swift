//
//  HCEditPatientGroupContainer.swift
//  HuChuangApp
//
//  Created by yintao on 2020/11/18.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCEditPatientGroupContainer: UIView {

    public var contentView: HCFiliterView!
    public var addTagButton: UIButton!
    public var tagTf: UITextField!
    private var tfBgView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tfBgView = UIView()
        tfBgView.backgroundColor = RGB(246, 246, 246)
        tfBgView.layer.cornerRadius = 5
        tfBgView.clipsToBounds = true
        
        tagTf = UITextField()
        tagTf.font = .font(fontSize: 15)
        tagTf.placeholder = "添加分组"
        tagTf.borderStyle = .none
        
        addTagButton = UIButton(type: .system)
        addTagButton.titleLabel?.font = .font(fontSize: 15)
        addTagButton.setTitleColor(.white, for: .normal)
        addTagButton.backgroundColor = RGB(1, 200, 170)
        addTagButton.setTitle("添加", for: .normal)
        addTagButton.layer.cornerRadius = 15
        addTagButton.clipsToBounds = true
        
        contentView = HCFiliterView()

        addSubview(tfBgView)
        tfBgView.addSubview(tagTf)
        addSubview(addTagButton)
        addSubview(contentView)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addTagButton.frame = .init(x: width - 15 - 55, y: 12, width: 55, height: 30)
        tfBgView.frame = .init(x: 15, y: 10, width: addTagButton.x - 15 - 10, height: 36)
        tagTf.frame = .init(x: 10, y: 3, width: tfBgView.width - 20, height: tfBgView.height - 3 * 2)
        contentView.frame = .init(x: 0,
                                  y: tfBgView.frame.maxY + 10,
                                  width: width,
                                  height: height - tfBgView.frame.maxY - 10)
    }
}
