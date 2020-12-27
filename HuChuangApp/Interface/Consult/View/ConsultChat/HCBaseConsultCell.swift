//
//  HCBaseConsultCell.swift
//  HuChuangApp
//
//  Created by yintao on 2020/5/28.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCBaseConsultCell: UITableViewCell {

    public var contentBgTagCallBack: ((HCChatListModel)->())?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.backgroundColor = RGB(247, 247, 247)
        backgroundColor = RGB(247, 247, 247)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public var model: HCChatListModel! {
        didSet {

        }
    }
}

class HCConsultDetailBaseCell: HCBaseConsultCell {
    
    private var avatarButton: UIButton!
    private var tapBgGes: UITapGestureRecognizer!
    
    public var contentBgView: UIImageView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        avatarButton = UIButton.init(type: .custom)
        avatarButton.layer.cornerRadius = 5
        avatarButton.clipsToBounds = true
        avatarButton.imageView?.contentMode = .scaleAspectFill
        avatarButton.imageView?.clipsToBounds = true
        avatarButton.isUserInteractionEnabled = false
        avatarButton.backgroundColor = RGB(240, 240, 240)

        contentBgView = UIImageView()
        contentBgView.isUserInteractionEnabled = true
        contentBgView.backgroundColor = .clear//RGB(240, 240, 240)
        
        tapBgGes = UITapGestureRecognizer.init(target: self, action: #selector(tapAction))
        contentBgView.addGestureRecognizer(tapBgGes)
        
        contentView.addSubview(avatarButton)
        contentView.addSubview(contentBgView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func tapAction() {
        contentBgTagCallBack?(model)
    }
    
    override public var model: HCChatListModel! {
        didSet {
            tapBgGes.isEnabled = model.contentMode == .audio
//            contentBgView.image = UIImage(named: model.isMine ? "绿框" : "灰色")
            contentBgView.backgroundColor = model.isMine ? RGB(234, 243, 252) : .white
            avatarButton.setImage(model.headPath)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        avatarButton.frame = model.getAvatarFrame
        contentBgView.frame = model.getContentBgFrame
        
        if model.isMine {
            contentBgView.set(cornerRadius: 10, borderCorners: [.topLeft, .bottomLeft, .bottomRight])
        }else {
            contentBgView.set(cornerRadius: 10, borderCorners: [.topRight, .bottomLeft, .bottomRight])
        }
    }
}
