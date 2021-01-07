//
//  HCVerificationHeaderView.swift
//  HuChuangApp
//
//  Created by sw on 2021/1/6.
//  Copyright © 2021 sw. All rights reserved.
//

import UIKit

enum HCVerificationAction {
    case search
    case scan
}

public let HCVerificationHeaderView_height: CGFloat = 280

class HCVerificationHeaderView: UIView {

    private var topView: UIView!
    private var topRemindLabel: UILabel!
    private var searchView: TYSearchBar!
    private var searchButton: UIButton!
    private var scanButton: UIButton!
    
    private var bottomView: UIView!
    private var colorLine: UIView!
    private var bottomRemindLabel: UILabel!
    private var bottomLine: UIView!
    
    public var actionCallBack: (((HCVerificationAction, String))->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        topView.frame = .init(x: 0, y: 0, width: width, height: 230)
        topRemindLabel.frame = .init(x: (width - 230) / 2, y: 30, width: 230, height: 44)
        searchView.frame = .init(x: 30, y: topRemindLabel.frame.maxY + 10, width: width - 60, height: 50)
        let buttonW: CGFloat = (topView.width - 15 - 30 * 2) / 2
        searchButton.frame = .init(x: 30, y: searchView.frame.maxY + 25, width: buttonW, height: 40)
        scanButton.frame = .init(x: searchButton.frame.maxX + 15, y: searchButton.y, width: buttonW, height: 40)

        bottomView.frame = .init(x: 0, y: topView.frame.maxY + 10, width: width, height: 40)
        colorLine.frame = .init(x: 10, y: (bottomView.height - 15) / 2, width: 3, height: 15)
        bottomRemindLabel.frame = .init(x: colorLine.frame.maxX + 15, y: (bottomView.height - 15) / 2, width: 115, height: 15)
        bottomLine.frame = .init(x: 0, y: bottomView.height - 0.5, width: bottomView.width, height: 0.5)
    }
}

extension HCVerificationHeaderView {
    
    private func setupUI() {
        backgroundColor = RGB(247, 247, 247)
        
        topView = UIView()
        topView.backgroundColor = .white
        //
        topRemindLabel = UILabel()
        topRemindLabel.textColor = RGB(12, 12, 12)
        topRemindLabel.numberOfLines = 2
        topRemindLabel.textAlignment = .center
        topRemindLabel.font = .font(fontSize: 14, fontName: .PingFMedium)
        topRemindLabel.text = "精准预约核销，请确认患者已到院\n核销后即代表订单已完成"
        //
        searchView = TYSearchBar()
        searchView.coverButtonEnable = false
        searchView.viewConfig = TYSearchBarConfig.createVerification()
        //
        searchButton = UIButton()
        searchButton.setImage(UIImage(named: "verification_search"), for: .normal)
        searchButton.setTitle(" 搜索 ", for: .normal)
        searchButton.setTitleColor(.white, for: .normal)
        searchButton.backgroundColor = HC_MAIN_COLOR
        searchButton.titleLabel?.font = .font(fontSize: 14)
        searchButton.layer.cornerRadius = 5
        searchButton.clipsToBounds = true
        searchButton.addTarget(self, action: #selector(actions(button:)), for: .touchUpInside)
        //
        scanButton = UIButton()
        scanButton.setImage(UIImage(named: "verification_qrcode"), for: .normal)
        scanButton.setTitle(" 扫码 ", for: .normal)
        scanButton.setTitleColor(.white, for: .normal)
        scanButton.backgroundColor = HC_MAIN_COLOR
        scanButton.titleLabel?.font = .font(fontSize: 14)
        scanButton.layer.cornerRadius = 5
        scanButton.clipsToBounds = true
        scanButton.addTarget(self, action: #selector(actions(button:)), for: .touchUpInside)

        //
        bottomView = UIView()
        bottomView.backgroundColor = .white
        //
        colorLine = UIView()
        colorLine.backgroundColor = HC_MAIN_COLOR
        colorLine.layer.cornerRadius = 1.5
        colorLine.clipsToBounds = true
        //
        bottomLine = UIView()
        bottomLine.backgroundColor = RGB(241, 241, 241)
        //
        bottomRemindLabel = UILabel()
        bottomRemindLabel.textColor = RGB(51, 51, 51)
        bottomRemindLabel.font = .font(fontSize: 14, fontName: .PingFSemibold)
        bottomRemindLabel.text = "精准预约核销记录"

        addSubview(topView)
        topView.addSubview(topRemindLabel)
        topView.addSubview(searchView)
        topView.addSubview(searchButton)
        topView.addSubview(scanButton)
        addSubview(bottomView)
        bottomView.addSubview(colorLine)
        bottomView.addSubview(bottomRemindLabel)
        bottomView.addSubview(bottomLine)
    }
    
    @objc private func actions(button: UIButton) {
        endEditing(true)
        if button == searchButton {
            actionCallBack?((.search, searchView.text))
        }else if button == scanButton {
            actionCallBack?((.scan, ""))
        }
    }
}
