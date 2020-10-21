//
//  HCPatientConsultRecordFooter.swift
//  HuChuangApp
//
//  Created by yintao on 2020/5/28.
//  Copyright © 2020 sw. All rights reserved.
// 55

import UIKit

enum HCPatientConsultRecordFooterOperation {
    /// 退回
    case back
    /// 补充问题
    case supplementAsk
    /// 回复
    case reply
    /// 补充回复
    case supplementReply
    /// 查看
    case view
}

public let HCPatientConsultRecordFooter_identifier = "HCPatientConsultRecordFooter_identifier"
public let HCPatientConsultRecordFooter_height: CGFloat = 65

class HCPatientConsultRecordFooter: UITableViewHeaderFooterView {
    // 退回
    private var backButton: UIButton!
    // 补充问题
    private var supplementAskButton: UIButton!
    // 回复
    private var replyButton: UIButton!
    // 补充回复
    private var supplementReplyButton: UIButton!
    // 查看
    private var viewButton: UIButton!
    
    private var bottomView: UIView!
    
    public var operationCallBack:(((HCPatientConsultRecordFooterOperation,HCConsultDetailItemModel))->())?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        isUserInteractionEnabled = true
        
        backButton = UIButton(type: .system)
        backButton.titleLabel?.font = .font(fontSize: 13, fontName: .PingFRegular)
        backButton.backgroundColor = .white
        backButton.layer.cornerRadius = 12.5
        backButton.layer.borderWidth = 0.5
        backButton.clipsToBounds = true
        backButton.layer.borderColor = RGB(236, 236, 236).cgColor
        backButton.setTitle("退回", for: .normal)
        backButton.setTitleColor(RGB(53, 53, 53), for: .normal)
        backButton.addTarget(self, action: #selector(actions(button:)), for: .touchUpInside)

        supplementAskButton = UIButton(type: .system)
        supplementAskButton.titleLabel?.font = .font(fontSize: 13, fontName: .PingFRegular)
        supplementAskButton.backgroundColor = .white
        supplementAskButton.layer.cornerRadius = 12.5
        supplementAskButton.layer.borderWidth = 0.5
        supplementAskButton.clipsToBounds = true
        supplementAskButton.layer.borderColor = RGB(236, 236, 236).cgColor
        supplementAskButton.setTitle("补充问题", for: .normal)
        supplementAskButton.setTitleColor(RGB(53, 53, 53), for: .normal)
        supplementAskButton.addTarget(self, action: #selector(actions(button:)), for: .touchUpInside)

        replyButton = UIButton(type: .system)
        replyButton.titleLabel?.font = .font(fontSize: 13, fontName: .PingFRegular)
        replyButton.backgroundColor = HC_MAIN_COLOR
        replyButton.layer.cornerRadius = 12.5
        replyButton.clipsToBounds = true
        replyButton.layer.borderColor = RGB(236, 236, 236).cgColor
        replyButton.setTitle("回复", for: .normal)
        replyButton.setTitleColor(.white, for: .normal)
        replyButton.addTarget(self, action: #selector(actions(button:)), for: .touchUpInside)

        supplementReplyButton = UIButton(type: .system)
        supplementReplyButton.titleLabel?.font = .font(fontSize: 13, fontName: .PingFRegular)
        supplementReplyButton.backgroundColor = .white
        supplementReplyButton.layer.cornerRadius = 12.5
        supplementReplyButton.layer.borderWidth = 0.5
        supplementReplyButton.clipsToBounds = true
        supplementReplyButton.layer.borderColor = HC_MAIN_COLOR.cgColor
        supplementReplyButton.setTitle("补充回复", for: .normal)
        supplementReplyButton.setTitleColor(HC_MAIN_COLOR, for: .normal)
        supplementReplyButton.addTarget(self, action: #selector(actions(button:)), for: .touchUpInside)

        viewButton = UIButton(type: .system)
        viewButton.titleLabel?.font = .font(fontSize: 13, fontName: .PingFRegular)
        viewButton.backgroundColor = .white
        viewButton.layer.cornerRadius = 12.5
        viewButton.layer.borderWidth = 0.5
        viewButton.clipsToBounds = true
        viewButton.layer.borderColor = HC_MAIN_COLOR.cgColor
        viewButton.setTitle("查看", for: .normal)
        viewButton.setTitleColor(HC_MAIN_COLOR, for: .normal)
        viewButton.addTarget(self, action: #selector(actions(button:)), for: .touchUpInside)

        bottomView = UIView()
        bottomView.backgroundColor = RGB(249, 249, 249)
        
        addSubview(backButton)
        addSubview(supplementAskButton)
        addSubview(replyButton)
        addSubview(supplementReplyButton)
        addSubview(viewButton)
        addSubview(bottomView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func actions(button: UIButton) {
        if button == backButton {
            operationCallBack?((.back, model))
        }else if button == supplementAskButton {
            operationCallBack?((.supplementAsk, model))
        }else if button == replyButton {
            operationCallBack?((.reply, model))
        }else if button == supplementReplyButton {
            operationCallBack?((.supplementReply, model))
        }else if button == viewButton {
            operationCallBack?((.view, model))
        }
    }
    
    public var model: HCConsultDetailItemModel! {
        didSet {

        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        backButton.frame = model.backButtonFrame
        supplementAskButton.frame = model.supplementAskButtonFrame
        replyButton.frame = model.replyButtonFrame
        supplementReplyButton.frame = model.supplementReplyButtonFrame
        viewButton.frame = model.viewButtonFrame
        bottomView.frame = .init(x: 0, y: height - 10, width: width, height: 10)
    }
}
