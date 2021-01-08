//
//  HCLoginViewContainer.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/7.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit
import RxSwift

enum HCLoginMode {
    case phone
    case pwd
}

class HCLoginViewContainer: UIView {
    
    private var titlelabel: UILabel!
    private var subTitleLabel: UILabel!
    private var subIcon: UIImageView!
    private var colorLine: UIView!
    
    private var loginModeBgView: UIView!
    private var phoneLoginButton: UIButton!
    private var phoneLoginLine: UIView!
    private var pwdLoginButton: UIButton!
    private var pwdLoginLine: UIView!

    private var areaCodeLabel: UILabel!
    private var vLine: UIView!
    public var phoneTf: UITextField!
    private var phoneHLine: UIView!
    
    public var pwdTf: UITextField!
    private var pwdHLine: UIView!

    public var getCodeButton: UIButton!

    private var remindLabel: UILabel!
    private var agreeButton: UIButton!
    private var agreeLabel: YYLabel!
    
    public var platformContainer: UIView!
    private var platformRemindLabel: UILabel!
    public var wchatLoginButton: UIButton!
    
    public let loginModeSignal = Variable(HCLoginMode.phone)
    public let agreeSignal = Variable(true)
    public var agreementTap: (()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()
                
        var tempSize = titlelabel.sizeThatFits(.init(width: CGFloat.greatestFiniteMagnitude, height: 35))
        titlelabel.frame = .init(x: 40, y: 0, width: tempSize.width, height: 35)
        
        colorLine.frame = .init(x: titlelabel.x,
                                y: titlelabel.frame.maxY - 15,
                                width: titlelabel.width,
                                height: 15)
        
        tempSize = subTitleLabel.sizeThatFits(.init(width: Double(MAXFLOAT), height: 20.0))
        subTitleLabel.frame = .init(x: titlelabel.frame.minX, y: titlelabel.frame.maxY + 5, width: tempSize.width, height: 20)
        subIcon.frame = .init(x: subTitleLabel.frame.maxX + 5, y: subTitleLabel.frame.minY + 2.5, width: 18, height: 15)
        
        loginModeBgView.frame = .init(x: subTitleLabel.x,
                                      y: subTitleLabel.frame.maxY + 45,
                                      width: 160,
                                      height: 25)
        phoneLoginButton.frame = .init(x: 0, y: 0, width: 65, height: 23)
        phoneLoginLine.frame = .init(x: (phoneLoginButton.width - 20) / 2,
                                     y: phoneLoginButton.frame.maxY,
                                     width: 20, height: 2)
        
        pwdLoginButton.frame = .init(x: phoneLoginButton.frame.maxX + 30, y: 0, width: 65, height: 23)
        pwdLoginLine.frame = .init(x: ((pwdLoginButton.width - 20) / 2) + pwdLoginButton.x,
                                     y: pwdLoginButton.frame.maxY,
                                     width: 20, height: 2)

        tempSize = areaCodeLabel.sizeThatFits(.init(width: CGFloat(MAXFLOAT), height: 22))
        areaCodeLabel.frame = .init(x: titlelabel.frame.minX,
                                    y: loginModeBgView.frame.maxY + 30,
                                    width: tempSize.width, height: 22)
        
        vLine.frame = .init(x: areaCodeLabel.frame.maxX + 15, y: areaCodeLabel.frame.minY + 1, width: 1, height: 20)
        phoneTf.frame = .init(x: vLine.frame.maxX + 15, y: areaCodeLabel.frame.minY, width: 250, height: 22)
        phoneHLine.frame = .init(x: titlelabel.frame.minX, y: vLine.frame.maxY + 12, width: width - 80, height: 1)
        
        switch loginModeSignal.value {
        case .phone:
            pwdHLine.removeFromSuperview()
            pwdTf.removeFromSuperview()
            getCodeButton.frame = .init(x: titlelabel.frame.minX, y: phoneHLine.frame.maxY + 45, width: width - 80, height: 48)
        case .pwd:
            if pwdTf.superview == nil {
                addSubview(pwdTf)
            }
            if pwdHLine.superview == nil {
                addSubview(pwdHLine)
            }
            pwdTf.frame = .init(x: areaCodeLabel.x,
                                y: phoneHLine.frame.maxY + 15,
                                width: phoneHLine.width,
                                height: 25)
            pwdHLine.frame = .init(x: pwdTf.x,
                                   y: pwdTf.frame.maxY + 10,
                                   width: phoneHLine.width,
                                   height: phoneHLine.height)
            getCodeButton.frame = .init(x: titlelabel.frame.minX, y: pwdHLine.frame.maxY + 20, width: width - 80, height: 48)
        }
        
        remindLabel.frame = .init(x: titlelabel.frame.minX, y: getCodeButton.frame.maxY + 20, width: width - 80, height: 16)
        agreeButton.frame = .init(x: titlelabel.frame.minX, y: remindLabel.frame.maxY + 12, width: 12, height: 12)
        
        let agreeLabelW: CGFloat = width - agreeButton.frame.maxX - 5 - 40
        tempSize = agreeLabel.sizeThatFits(.init(width: agreeLabelW, height: CGFloat(MAXFLOAT)))
        agreeLabel.frame = .init(x: agreeButton.frame.maxX + 5, y: agreeButton.frame.minY - 5, width: tempSize.width, height: tempSize.height)
        
        platformContainer.frame = .init(x: titlelabel.frame.minX, y: height - 85, width: width - 80, height: 40)
        
        platformRemindLabel.frame = .init(x: 0, y: 10, width: 70, height: 20)
        wchatLoginButton.frame = .init(x: platformContainer.width - 40, y: 0, width: 40, height: 40)
    }
}

extension HCLoginViewContainer {
    
    private func initUI() {
        backgroundColor = .white
        
        titlelabel = UILabel()
        titlelabel.text = "登录"
        titlelabel.font = .font(fontSize: 32, fontName: .PingFSemibold)
        titlelabel.textColor = .black
        
        colorLine = UIView()
        colorLine.backgroundColor = HC_MAIN_COLOR
        
        subTitleLabel = UILabel()
        subTitleLabel.text = "为爱孕育生命"
        subTitleLabel.font = .font(fontSize: 14, fontName: .PingFRegular)
        subTitleLabel.textColor = RGB(51, 51, 51)

        subIcon = UIImageView.init(image: UIImage(named: "login_title_icon"))
        
        // --
        loginModeBgView = UIView()
        loginModeBgView.backgroundColor = backgroundColor
        
        phoneLoginButton = UIButton(type: .custom)
        phoneLoginButton.setTitle("手机登陆", for: .normal)
        phoneLoginButton.setTitleColor(HC_MAIN_COLOR, for: .selected)
        phoneLoginButton.setTitleColor(RGB(153, 153, 153), for: .normal)
        phoneLoginButton.titleLabel?.font = .font(fontSize: 16, fontName: .PingFSemibold)
        phoneLoginButton.addTarget(self, action: #selector(loginModeChangeAction(button:)), for: .touchUpInside)
        phoneLoginButton.isSelected = true
        
        phoneLoginLine = UIView()
        phoneLoginLine.backgroundColor = HC_MAIN_COLOR
        
        pwdLoginButton = UIButton(type: .custom)
        pwdLoginButton.setTitle("密码登陆", for: .normal)
        pwdLoginButton.setTitleColor(HC_MAIN_COLOR, for: .selected)
        pwdLoginButton.setTitleColor(RGB(153, 153, 153), for: .normal)
        pwdLoginButton.titleLabel?.font = .font(fontSize: 16)
        pwdLoginButton.addTarget(self, action: #selector(loginModeChangeAction(button:)), for: .touchUpInside)

        pwdLoginLine = UIView()
        pwdLoginLine.backgroundColor = HC_MAIN_COLOR
        pwdLoginLine.isHidden = true
        
        // --
        areaCodeLabel = UILabel()
        areaCodeLabel.text = "+86"
        areaCodeLabel.font = .font(fontSize: 16, fontName: .PingFRegular)
        areaCodeLabel.textColor = RGB(51, 51, 51)

        vLine = UIView()
        vLine.backgroundColor = RGB(229, 229, 229)
        
        phoneTf = UITextField()
        phoneTf.keyboardType = .numberPad
        phoneTf.returnKeyType = .done
        phoneTf.borderStyle = .none
        phoneTf.font = .font(fontSize: 16, fontName: .PingFRegular)
        phoneTf.textColor = RGB(51, 51, 51)
        phoneTf.placeholder = "请输入您的手机号"
        
        phoneHLine = UIView()
        phoneHLine.backgroundColor = RGB(229, 229, 229)
        
        pwdTf = UITextField()
        pwdTf.isSecureTextEntry = true
        pwdTf.keyboardType = .numberPad
        pwdTf.returnKeyType = .done
        pwdTf.borderStyle = .none
        pwdTf.font = .font(fontSize: 16, fontName: .PingFRegular)
        pwdTf.textColor = RGB(51, 51, 51)
        pwdTf.placeholder = "请输入密码"
        
        pwdHLine = UIView()
        pwdHLine.backgroundColor = RGB(229, 229, 229)

        getCodeButton = UIButton()
        getCodeButton.layer.cornerRadius = 3
        getCodeButton.clipsToBounds = true
        getCodeButton.setTitle("获取验证码", for: .normal)
        getCodeButton.backgroundColor = HC_MAIN_COLOR
        getCodeButton.setTitleColor(RGB(191, 191, 191), for: .normal)
        getCodeButton.setTitleColor(.white, for: .selected)
        getCodeButton.titleLabel?.font = .font(fontSize: 13)
        
        remindLabel = UILabel()
        remindLabel.textColor = RGB(154, 154, 154)
        remindLabel.font = .font(fontSize: 12)
        remindLabel.text = "未注册手机验证后自动注册"
        
        agreeButton = UIButton()
        agreeButton.setImage(UIImage(named: "login_unselected_agree"), for: .normal)
        agreeButton.setImage(UIImage(named: "login_selected_agree"), for: .selected)
        agreeButton.addTarget(self, action: #selector(agreeClicked), for: .touchUpInside)
        agreeButton.isSelected = true
        
        agreeLabel = YYLabel()
        agreeLabel.textColor = RGB(154, 154, 154)
        agreeLabel.font = .font(fontSize: 12)
        agreeLabel.numberOfLines = 0
        let string = NSMutableAttributedString.init(string: "阅读并勾选以下协议《爱乐孕用户服务协议》《法律声明》《隐私政策》")
        string.yy_setTextHighlight(.init(location: 9, length: 11), color: RGB(57, 129, 247), backgroundColor: .clear) { [weak self] (_, _, _, _) in
            self?.agreementTap?()
        }
        string.yy_setTextHighlight(.init(location: 20, length: 6), color: RGB(57, 129, 247), backgroundColor: .clear) { [weak self] (_, _, _, _) in
            self?.agreementTap?()
        }
        string.yy_setTextHighlight(.init(location: 26, length: 6), color: RGB(57, 129, 247), backgroundColor: .clear) { [weak self] (_, _, _, _) in
            self?.agreementTap?()
        }
        agreeLabel.attributedText = string
        
        platformContainer = UIView()
        platformContainer.backgroundColor = .white
            
        platformRemindLabel = UILabel()
        platformRemindLabel.text = "第三方登录"
        platformRemindLabel.font = .font(fontSize: 14)
        platformRemindLabel.textColor = RGB(216, 216, 216)
        
        wchatLoginButton = UIButton()
        wchatLoginButton.setImage(UIImage(named: "wchat_login"), for: .normal)
        
        addSubview(colorLine)
        addSubview(titlelabel)
        addSubview(subTitleLabel)
        addSubview(subIcon)
        
        addSubview(loginModeBgView)
        loginModeBgView.addSubview(phoneLoginButton)
        loginModeBgView.addSubview(phoneLoginLine)
        loginModeBgView.addSubview(pwdLoginButton)
        loginModeBgView.addSubview(pwdLoginLine)

        addSubview(areaCodeLabel)
        addSubview(vLine)
        addSubview(phoneTf)
        addSubview(phoneHLine)
        addSubview(pwdTf)
        addSubview(pwdHLine)
        addSubview(getCodeButton)
        
        addSubview(remindLabel)
        addSubview(agreeButton)
        addSubview(agreeLabel)

        addSubview(platformContainer)
        platformContainer.addSubview(platformRemindLabel)
        platformContainer.addSubview(wchatLoginButton)
        
        #if DEBUG
//        phoneTf.text = "13995631675"
        phoneTf.text = "15172321017"
//        phoneTf.text = "13244762499"
//        phoneTf.text = "15717102067"
//        phoneTf.text = "18627844751"
        #else
        phoneTf.text = userDefault.loginPhone
        #endif
    }

    @objc private func agreeClicked() {
        agreeButton.isSelected = !agreeButton.isSelected
        agreeSignal.value = agreeButton.isSelected
    }
    
    @objc private func loginModeChangeAction(button: UIButton) {
        if button == phoneLoginButton && loginModeSignal.value == .phone || button == pwdLoginButton && loginModeSignal.value == .pwd {
            return
        }
        
        if button == pwdLoginButton {
            phoneLoginButton.isSelected = false
            phoneLoginLine.isHidden = true
            phoneLoginButton.titleLabel?.font = .font(fontSize: 16)
            
            pwdLoginButton.isSelected = true
            pwdLoginLine.isHidden = false
            pwdLoginButton.titleLabel?.font = .font(fontSize: 16, fontName: .PingFSemibold)
            
            getCodeButton.setTitle("登录", for: .normal)
            
            loginModeSignal.value = .pwd
        }else {
            pwdLoginButton.isSelected = false
            pwdLoginLine.isHidden = true
            pwdLoginButton.titleLabel?.font = .font(fontSize: 16)

            phoneLoginButton.isSelected = true
            phoneLoginLine.isHidden = false
            phoneLoginButton.titleLabel?.font = .font(fontSize: 16, fontName: .PingFSemibold)
            
            getCodeButton.setTitle("获取验证码", for: .normal)

            loginModeSignal.value = .phone
        }
        
        setNeedsLayout()
        layoutIfNeeded()
    }
}
