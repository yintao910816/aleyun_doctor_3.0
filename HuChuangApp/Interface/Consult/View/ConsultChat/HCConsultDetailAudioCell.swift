//
//  HCConsultDetailAudioCell.swift
//  HuChuangApp
//
//  Created by yintao on 2020/6/19.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCConsultDetailAudioCell_identifier = "HCConsultDetailAudioCell_identifier"

class HCConsultDetailAudioCell: HCConsultDetailBaseCell {

    private var audioIcon: UIImageView!
    private var audioDrution: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        audioIcon = UIImageView(image: UIImage(named: ""))
        
        audioDrution = UILabel()
        audioDrution.font = .font(fontSize: 13, fontName: .PingFRegular)
        audioDrution.textColor = RGB(53, 53, 53)

        contentBgView.addSubview(audioDrution)
        contentBgView.addSubview(audioIcon)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override var model: HCChatListModel! {
        didSet {
            super.model = model

            audioIcon.image = UIImage(named: model.isMine ? "consult_icon_voice" : "consult_icon_voice_other")
            audioDrution.text = "\(model.timeLen)"
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        audioDrution.frame = model.getAudioDurationFrame
        audioIcon.frame = model.getAudioIconFrame
    }
}
