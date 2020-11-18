//
//  HCHomeHeaderReusableView.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/8.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

enum HCHomeHeaderClickedMode {
    case qrCode
    case message
    case setting
}

public let HCHomeHeaderReusableView_identifier = "HCHomeHeaderReusableView"
public let HCHomeHeaderReusableView_height: CGFloat = 310

class HCHomeHeaderReusableView: UICollectionReusableView {
   
    private var colorBgView: UIImageView!
    private var avatarBgView: UIImageView!
    private var avatar: UIButton!
    private var nameLabel: UILabel!
    // 好评 - 回复率
    private var briefLabel: UILabel!
    // 名片
    private var userCardButton: UIButton!
    // 消息
    private var messageButton: UIButton!
    
    // 工作台
    private var jobCornerBgView: UIView!
    private var jobShadowBgView: UIView!
    private var jobTitleLabel: UILabel!
    // 新的待接诊订单
    private var newOrderBgView: UIView!
    private var gradientLayer: CAGradientLayer!
    private var newOrderCountLabel: UILabel!
    private var orderLine: UIImageView!
    private var newOrderRemindLabel: UILabel!

    public var buttonClicked: ((HCHomeHeaderClickedMode)->())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    public var userModel: HCUserModel = HCUserModel() {
        didSet {
            avatar.setImage(userModel.headPath)
            nameLabel.text = userModel.name
                        
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    public var userServerStatistics: HCUserServerStatisticsModel = HCUserServerStatisticsModel() {
        didSet {
            briefLabel.text = userServerStatistics.briefText
            newOrderCountLabel.attributedText = userServerStatistics.unreplyNumText
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
        colorBgView.frame = bounds
        
        avatarBgView.frame = .init(x: 25, y: 80, width: 68, height: 68)
        avatar.frame = .init(x: 4, y: 4, width: 60, height: 60)

        let maxNameWidth: CGFloat = width - avatarBgView.frame.maxX - 12 - 15
        nameLabel.frame = .init(x: avatarBgView.frame.maxX + 12, y: avatarBgView.y + 4, width: maxNameWidth, height: 28)
        
        briefLabel.frame = .init(x: nameLabel.x, y: nameLabel.frame.maxY + 3, width: nameLabel.width, height: 14)

        userCardButton.frame = .init(x: nameLabel.x,
                                     y: briefLabel.frame.maxY + 5,
                                     width: 55,
                                     height: 24)
        
        messageButton.frame = .init(x: userCardButton.frame.maxX + 5,
                                    y: userCardButton.y,
                                    width: 55,
                                    height: 24)
        
        jobShadowBgView.frame = .init(x: 15,
                                      y: userCardButton.frame.maxY + 20,
                                      width: width - 30,
                                      height: 125)
        
        jobCornerBgView.frame = .init(x: 15,
                                      y: userCardButton.frame.maxY + 20,
                                      width: width - 30,
                                      height: 125)
        
        jobTitleLabel.frame = .init(x: 15,
                                    y: 10,
                                    width: jobCornerBgView.width - 30,
                                    height: 25)
        
        newOrderBgView.frame = .init(x: 0,
                                     y: jobTitleLabel.frame.maxY + 10,
                                     width: jobCornerBgView.width,
                                     height: 80)
        
        newOrderCountLabel.frame = .init(x: 0,
                                         y: 0,
                                         width: newOrderBgView.width / 3,
                                         height: newOrderBgView.height)
        
        orderLine.frame = .init(x: newOrderCountLabel.frame.maxX,
                                y: 15,
                                width: 1,
                                height: newOrderBgView.height - 30)
        
        newOrderRemindLabel.frame = .init(x: orderLine.frame.maxX + 20,
                                          y: (newOrderBgView.height - 15) / 2,
                                          width: newOrderBgView.width - orderLine.frame.maxX - 40,
                                          height: 15)
        
        gradientLayer.frame = .init(x: 0, y: 0, width: newOrderBgView.width, height: newOrderBgView.height)
        
        
        if jobShadowBgView.layer.shadowPath == nil {
            jobShadowBgView.setCornerAndShaow(shadowOpacity: 0.05)
        }
    }
}

extension HCHomeHeaderReusableView {
    
    private func initUI() {
        backgroundColor = .clear
        
        colorBgView = UIImageView()
        colorBgView.image = UIImage(named: "home_bg")
        colorBgView.backgroundColor = .clear
        colorBgView.isUserInteractionEnabled = true
        
        gradientLayer = CAGradientLayer.drawBg(with: [RGB(36, 84, 195, 1).cgColor,
                                                      RGB(80, 131, 248, 1).cgColor],
                                               gradientLocations: [.init(value: 0.5),
                                                                   .init(value: 1)])
        

        avatarBgView = UIImageView(image: UIImage(named: "home_avatar_bg"))
        avatar = UIButton()
        avatar.layer.cornerRadius = 30
        avatar.clipsToBounds = true
        
        nameLabel = UILabel()
        nameLabel.textColor = RGB(51, 51, 51)
        nameLabel.font = .font(fontSize: 20, fontName: .PingFSemibold)
                
        briefLabel = UILabel()
        briefLabel.textColor = RGB(102, 102, 102)
        briefLabel.font = .font(fontSize: 10)
        
        userCardButton = UIButton(type: .custom)
        userCardButton.setImage(UIImage(named: "home_user_card"), for: .normal)
        userCardButton.setTitle("名片", for: .normal)
        userCardButton.titleLabel?.font = .font(fontSize: 10, fontName: .PingFSemibold)
        userCardButton.setTitleColor(RGB(79, 130, 247), for: .normal)
        userCardButton.layer.cornerRadius = 12
        userCardButton.clipsToBounds = true
        userCardButton.layer.borderWidth = 0.5
        userCardButton.layer.borderColor = RGB(79, 130, 247).cgColor

        messageButton = UIButton(type: .custom)
        messageButton.setImage(UIImage(named: "home_message"), for: .normal)
        messageButton.setTitle("消息", for: .normal)
        messageButton.titleLabel?.font = .font(fontSize: 10, fontName: .PingFSemibold)
        messageButton.setTitleColor(RGB(79, 130, 247), for: .normal)
        messageButton.layer.cornerRadius = 12
        messageButton.clipsToBounds = true
        messageButton.layer.borderWidth = 0.5
        messageButton.layer.borderColor = RGB(79, 130, 247).cgColor
        
        jobShadowBgView = UIView()
        jobShadowBgView.backgroundColor = .clear
        
        jobCornerBgView = UIView()
        jobCornerBgView.backgroundColor = .white
        jobCornerBgView.layer.cornerRadius = 7
        jobCornerBgView.clipsToBounds = true
        
        jobTitleLabel = UILabel()
        jobTitleLabel.textColor = RGB(51, 51, 51)
        jobTitleLabel.font = .font(fontSize: 18, fontName: .PingFSemibold)
        jobTitleLabel.text = "我的工作台"

        newOrderBgView = UIView()
        newOrderBgView.layer.cornerRadius = 7
        newOrderBgView.clipsToBounds = true
        
        newOrderCountLabel = UILabel()
        newOrderCountLabel.textColor = .white
        newOrderCountLabel.font = .font(fontSize: 18, fontName: .PingFSemibold)
        newOrderCountLabel.numberOfLines = 2
        
        orderLine = UIImageView(image: UIImage.init(named: "home_line"))
        
        newOrderRemindLabel = UILabel()
        newOrderRemindLabel.textColor = .white
        newOrderRemindLabel.font = .font(fontSize: 14)
        newOrderRemindLabel.text = "您有新的待订单，请及时查看"
        
        addSubview(colorBgView)
        colorBgView.addSubview(avatarBgView)
        avatarBgView.addSubview(avatar)
        colorBgView.addSubview(nameLabel)
        colorBgView.addSubview(briefLabel)
        colorBgView.addSubview(userCardButton)
        colorBgView.addSubview(messageButton)

        colorBgView.addSubview(jobShadowBgView)
        colorBgView.addSubview(jobCornerBgView)
        jobCornerBgView.addSubview(jobTitleLabel)
        jobCornerBgView.addSubview(newOrderBgView)
        newOrderBgView.addSubview(newOrderCountLabel)
        newOrderBgView.addSubview(orderLine)
        newOrderBgView.addSubview(newOrderRemindLabel)
        
        newOrderBgView.layer.insertSublayer(gradientLayer, at: 0)
    }
}
