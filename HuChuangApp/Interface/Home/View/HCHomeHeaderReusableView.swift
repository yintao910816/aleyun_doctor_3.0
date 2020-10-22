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

class HCHomeHeaderReusableView: UICollectionReusableView {
   
    private var colorBgView: UIImageView!
    private var qrCodeButton: UIButton!
    private var noticeButton: UIButton!
    private var settingButton: UIButton!
    private var avatarBgView: UIImageView!
    private var avatar: UIButton!
    private var nameLabel: UILabel!
    private var markTypeFirstImgV: UIImageView!
    private var markTypeSecondImgV: UIImageView!
    private var jobRoleLabel: UILabel!
    /// 服务患者
    private var serverPatientLabel: UILabel!
    /// 好评率
    private var praiseRateLabel: UILabel!
    /// 回复率
    private var replyRateLabel: UILabel!
    
    private var funcCornerBgView: UIView!
    private var funcShadowBgView: UIView!
    private var funcCollectionView: UICollectionView!
    
    public var funcItemClicked: ((HCFunctionsMenuModel)->())?
    public var buttonClicked: ((HCHomeHeaderClickedMode)->())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var funcMenuModels: [HCFunctionsMenuModel] = [] {
        didSet {
            funcCollectionView.reloadData()
        }
    }
    
    public var userModel: HCUserModel = HCUserModel() {
        didSet {
            avatar.setImage(userModel.headPath)
            nameLabel.text = userModel.name
            jobRoleLabel.text = userModel.technicalPost
            
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
        var safeTop: CGFloat = 0
        if #available(iOS 11.0, *) {
            safeTop = safeAreaInsets.top
            colorBgView.frame = .init(x: 0, y: 0, width: width, height: 384)
            qrCodeButton.frame = .init(x: 15, y: safeAreaInsets.top + (44 - 20) / 2.0, width: 20, height: 20)
        } else {
            colorBgView.frame = .init(x: 0, y: 0, width: width, height: 360)
            qrCodeButton.frame = .init(x: 15, y: (44 - 20) / 2.0 + 20.0, width: 20, height: 20)
        }
        
        settingButton.frame = .init(x: width - 35, y: qrCodeButton.y, width: 20, height: 20)
        noticeButton.frame = .init(x: settingButton.x - 40, y: qrCodeButton.y, width: 20, height: 20)
        
        avatarBgView.frame = .init(x: 15, y: qrCodeButton.frame.maxY + 16, width: 72, height: 72)
        avatar.frame = .init(x: 2, y: 2, width: 68, height: 68)
        
        var maxNameWidth: CGFloat = width - avatarBgView.frame.maxX
        maxNameWidth -= (18 + 10 + 15 + 5 + 15 + 15)
        var nameSize: CGSize = nameLabel.sizeThatFits(.init(width: CGFloat(MAXFLOAT), height: 31))
        nameSize.width = nameSize.width > maxNameWidth ? maxNameWidth : nameSize.width
        nameLabel.frame = .init(x: avatarBgView.frame.maxX + 18, y: avatarBgView.y + 8, width: nameSize.width, height: 31)
        
        markTypeFirstImgV.frame = .init(x: nameLabel.frame.maxX + 10, y: nameLabel.frame.maxY - 20, width: 15, height: 20)
        markTypeSecondImgV.frame = .init(x: markTypeFirstImgV.frame.maxX + 5, y: markTypeFirstImgV.y, width: 15, height: 20)
        
        jobRoleLabel.frame = .init(x: nameLabel.x,
                                   y: nameLabel.frame.maxY + 12,
                                   width: width - nameLabel.x - 15,
                                   height: 14)
        
        let labelW: CGFloat = width / 3.0
        serverPatientLabel.frame = .init(x: 0, y: avatarBgView.frame.maxY + 34, width: labelW, height: 33)
        praiseRateLabel.frame = .init(x: serverPatientLabel.frame.maxX, y: serverPatientLabel.y, width: labelW, height: 33)
        replyRateLabel.frame = .init(x: praiseRateLabel.frame.maxX, y: serverPatientLabel.y, width: labelW, height: 33)
        
        let funcBgHeight: CGFloat = HCHomeHeaderReusableView.colViewHeight(with: width, funcCount: funcMenuModels.count, safeAreaTop: safeTop)
        funcShadowBgView.frame = .init(x: 15, y: height - funcBgHeight, width: width - 30, height: funcBgHeight)
        funcCornerBgView.frame = funcShadowBgView.frame
        funcCollectionView.frame = .init(x: 0, y: 0, width: funcCornerBgView.width, height: funcBgHeight)
        
        if funcShadowBgView.layer.shadowPath == nil {
            funcShadowBgView.setCornerAndShaow(shadowOpacity: 0.05)
        }
    }
}

extension HCHomeHeaderReusableView {
    
    private func initUI() {
        backgroundColor = .clear
        
        colorBgView = UIImageView()
        colorBgView.backgroundColor = .orange
        colorBgView.isUserInteractionEnabled = true
        
        qrCodeButton = UIButton()
        qrCodeButton.setImage(UIImage(named: "nav_qr_code"), for: .normal)
        qrCodeButton.addTarget(self, action: #selector(buttonAction(button:)), for: .touchUpInside)

        noticeButton = UIButton()
        noticeButton.setImage(UIImage(named: "nav_notice"), for: .normal)
        noticeButton.addTarget(self, action: #selector(buttonAction(button:)), for: .touchUpInside)

        settingButton = UIButton()
        settingButton.setImage(UIImage(named: "nav_setting"), for: .normal)
        settingButton.addTarget(self, action: #selector(buttonAction(button:)), for: .touchUpInside)

        avatarBgView = UIImageView(image: UIImage(named: "home_avatar_bg"))
        avatar = UIButton()
        avatar.layer.cornerRadius = 34
        avatar.clipsToBounds = true
        
        nameLabel = UILabel()
        nameLabel.textColor = .white
        nameLabel.font = .font(fontSize: 30, fontName: .PingFSemibold)
        
        markTypeFirstImgV = UIImageView(image: UIImage(named: "hzy"))
        markTypeSecondImgV = UIImageView(image: UIImage(named: "hze"))
        
        jobRoleLabel = UILabel()
        jobRoleLabel.textColor = RGB(220, 234, 253)
        jobRoleLabel.font = .font(fontSize: 14)

        serverPatientLabel = UILabel()
        serverPatientLabel.textColor = RGB(221, 235, 254)
        serverPatientLabel.font = .font(fontSize: 12)
        serverPatientLabel.numberOfLines = 2
        serverPatientLabel.contentMode = .center

        praiseRateLabel = UILabel()
        praiseRateLabel.textColor = RGB(221, 235, 254)
        praiseRateLabel.font = .font(fontSize: 12)
        praiseRateLabel.numberOfLines = 2
        praiseRateLabel.contentMode = .center

        replyRateLabel = UILabel()
        replyRateLabel.textColor = RGB(221, 235, 254)
        replyRateLabel.font = .font(fontSize: 12)
        replyRateLabel.numberOfLines = 2
        replyRateLabel.contentMode = .center

        funcShadowBgView = UIView()
        funcShadowBgView.backgroundColor = .clear
        
        funcCornerBgView = UIView()
        funcCornerBgView.layer.cornerRadius = 7
        funcCornerBgView.clipsToBounds = true
        
        let layout = UICollectionViewFlowLayout()
        funcCollectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        funcCollectionView.backgroundColor = .white
        funcCollectionView.showsVerticalScrollIndicator = false
        funcCollectionView.showsHorizontalScrollIndicator = false
        funcCollectionView.delegate = self
        funcCollectionView.dataSource = self
        
        addSubview(colorBgView)
        colorBgView.addSubview(qrCodeButton)
        colorBgView.addSubview(noticeButton)
        colorBgView.addSubview(settingButton)
        colorBgView.addSubview(avatarBgView)
        avatarBgView.addSubview(avatar)
        colorBgView.addSubview(nameLabel)
        colorBgView.addSubview(markTypeFirstImgV)
        colorBgView.addSubview(markTypeSecondImgV)
        colorBgView.addSubview(jobRoleLabel)
        colorBgView.addSubview(serverPatientLabel)
        colorBgView.addSubview(praiseRateLabel)
        colorBgView.addSubview(replyRateLabel)

        addSubview(funcShadowBgView)
        addSubview(funcCornerBgView)
        funcCornerBgView.addSubview(funcCollectionView)
        
        funcCollectionView.register(HCFuncMenuCel.self, forCellWithReuseIdentifier: HCFuncMenuCel_identifier)
    }
    
    @objc private func buttonAction(button: UIButton) {
        if button == qrCodeButton {
            buttonClicked?(.qrCode)
        }else if button == noticeButton {
            buttonClicked?(.message)
        }else if button == settingButton {
            buttonClicked?(.setting)
        }
    }
}

extension HCHomeHeaderReusableView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return funcMenuModels.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return HCHomeHeaderReusableView.itemSize(forCell: width, funcCount: funcMenuModels.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HCFuncMenuCel_identifier, for: indexPath) as! HCFuncMenuCel
        cell.funcModel = funcMenuModels[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 20, left: 10, bottom: 20, right: 10)
    }
}

extension HCHomeHeaderReusableView {
    
    public static func viewHeight(with width: CGFloat, funcCount: Int, safeAreaTop: CGFloat) ->CGFloat {

        var height: CGFloat = HCHomeHeaderReusableView.colViewHeight(with: width, funcCount: funcCount, safeAreaTop: safeAreaTop)
        
        /// --- 功能区之上部分
        height += safeAreaTop
        height += 230.0
        
        return height
    }
    
    private static func colViewHeight(with width: CGFloat, funcCount: Int, safeAreaTop: CGFloat) ->CGFloat {
        guard funcCount > 0 else { return 0 }
        
        let itemSize: CGSize = HCHomeHeaderReusableView.itemSize(forCell: width, funcCount: funcCount)
        
        /// --- 功能区
        // 顶部和底部
        var height: CGFloat = 20 * 2
        var lines = funcCount / 4
        lines = (funcCount % 4) == 0 ? lines : lines + 1;
        // 行间距之和
        height += CGFloat((lines - 1) * 15)
        // cell
        height += itemSize.height * CGFloat(lines)
                
        return height
    }
    
    private static func itemSize(forCell width: CGFloat, funcCount: Int) ->CGSize {
        let itemWidth: CGFloat = (width - 1 - 15 * 2 - 10 * 2 - 20 * 3) / 4.0
        let itemHeight: CGFloat = itemWidth + 10 + 13
        return .init(width: itemWidth, height: itemHeight)
    }

}
