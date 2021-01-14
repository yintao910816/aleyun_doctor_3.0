//
//  HCVerificationQueryContainer.swift
//  HuChuangApp
//
//  Created by sw on 2021/1/7.
//  Copyright © 2021 sw. All rights reserved.
//

import UIKit

import RxSwift

class HCVerificationQueryContainer: UIView {

    private let disposeBag = DisposeBag()
    
    private var colorBg: UIView!
    
    private var contentBg: UIImageView!
    private var titleLabel: UILabel!
    private var projectTitleLabel: UILabel!
    private var projectNameLabel: UILabel!
    private var lineImgV: UIImageView!
    private var memberRemindLabel: UILabel!
    private var memberLabel: UILabel!
    private var timeRemindLabel: UILabel!
    private var timeLabel: UILabel!

    public var queryButton: UIButton!
    
    private var queryStatusBg: UIView!
    private var queryStatusImgV: UIImageView!
    private var queryStatusLabel: UILabel!

    public let verificationStatusSignal = PublishSubject<(Bool, String)>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        
        verificationStatusSignal
            .subscribe(onNext: { [weak self] in
                self?.queryStatusBg.isHidden = false
                if $0.0 {
                    self?.queryStatusImgV.image = UIImage(named: "verification_success")
                    self?.queryStatusLabel.text = "核销成功"
                    self?.queryButton.setTitle("返回首页", for: .normal)
                }else {
                    self?.queryStatusImgV.image = UIImage(named: "verification_failuer")
                    self?.queryStatusLabel.text = $0.1
                    self?.queryButton.setTitle("重新扫码", for: .normal)
                }
                
                self?.setNeedsLayout()
                self?.layoutIfNeeded()
            })
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var infoModel: HCVerificationItemModel! {
        didSet {
            memberLabel.text = infoModel.memberName
            timeLabel.text = infoModel.shortBeginTimeText
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
                
        let contentBgH: CGFloat = (width - 13 * 2) / (352.0 / 375.0)
        contentBg.frame = .init(x: 13, y: 30, width: width - 13 * 2, height: contentBgH)
        
        colorBg.frame = .init(x: 0, y: 0, width: width, height: contentBgH - 100)

        
        var tempSize = titleLabel.sizeThatFits(.init(width: CGFloat.greatestFiniteMagnitude, height: 22))
        titleLabel.frame = .init(x: (width - tempSize.width) / 2, y: 33, width: tempSize.width, height: tempSize.height)
        
        tempSize = projectTitleLabel.sizeThatFits(.init(width: CGFloat.greatestFiniteMagnitude, height: 18))
        projectTitleLabel.frame = .init(x: 50, y: titleLabel.frame.maxY + 30, width: tempSize.width, height: tempSize.height)
        tempSize = projectNameLabel.sizeThatFits(.init(width: CGFloat.greatestFiniteMagnitude, height: 18))
        projectNameLabel.frame = .init(x: contentBg.width - 50 - tempSize.width, y: projectTitleLabel.y, width: tempSize.width, height: tempSize.height)

        lineImgV.frame = .init(x: projectTitleLabel.x, y: projectTitleLabel.frame.maxY + 10, width: projectNameLabel.frame.maxX - projectTitleLabel.x, height: 1)
        
        tempSize = memberRemindLabel.sizeThatFits(.init(width: CGFloat.greatestFiniteMagnitude, height: 15))
        memberRemindLabel.frame = .init(x: projectTitleLabel.x, y: lineImgV.frame.maxY + 15, width: tempSize.width, height: tempSize.height)
        tempSize = memberLabel.sizeThatFits(.init(width: CGFloat.greatestFiniteMagnitude, height: 15))
        memberLabel.frame = .init(x: contentBg.width - 50 - tempSize.width, y: memberRemindLabel.y, width: tempSize.width, height: tempSize.height)

        tempSize = timeRemindLabel.sizeThatFits(.init(width: CGFloat.greatestFiniteMagnitude, height: 15))
        timeRemindLabel.frame = .init(x: projectTitleLabel.x, y: memberRemindLabel.frame.maxY + 15, width: tempSize.width, height: tempSize.height)
        tempSize = timeLabel.sizeThatFits(.init(width: CGFloat.greatestFiniteMagnitude, height: 15))
        timeLabel.frame = .init(x: contentBg.width - 50 - tempSize.width, y: timeRemindLabel.y, width: tempSize.width, height: tempSize.height)
        
        queryButton.frame = .init(x: 35, y: contentBg.height - 35 - 40, width: contentBg.width - 35 * 2, height: 40)
        
        //
        queryStatusBg.frame = .init(x: 25, y: 25, width: contentBg.width - 50, height: queryButton.y - 25)
        tempSize = queryStatusLabel.sizeThatFits(.init(width: queryStatusBg.width, height: CGFloat.greatestFiniteMagnitude))
        let imgVX = (queryStatusBg.width - 70) / 2
        let imgVY = (queryStatusBg.height - 68 - 10 - tempSize.height) / 2
        queryStatusImgV.frame = .init(x: imgVX, y: imgVY, width: 70, height: 68)
        queryStatusLabel.frame = .init(x: (queryStatusBg.width - tempSize.width) / 2, y: queryStatusImgV.frame.maxY + 10, width: tempSize.width, height: tempSize.height)
    }
}

extension HCVerificationQueryContainer {
    
    private func setupUI() {
        backgroundColor = RGB(247, 247, 247)
        
        colorBg = UIView()
        colorBg.backgroundColor = HC_MAIN_COLOR
        
        contentBg = UIImageView(image: UIImage(named: "verification_query_bg"))
        contentBg.isUserInteractionEnabled = true
        //
        titleLabel = UILabel()
        titleLabel.text = "确认核销"
        titleLabel.textColor = RGB(51, 51, 51)
        titleLabel.font = .font(fontSize: 20, fontName: .PingFSemibold)
        //
        projectTitleLabel = UILabel()
        projectTitleLabel.text = "核销项目"
        projectTitleLabel.textColor = RGB(51, 51, 51)
        projectTitleLabel.font = .font(fontSize: 16, fontName: .PingFSemibold)
        //
        projectNameLabel = UILabel()
        projectNameLabel.text = "精准预约"
        projectNameLabel.textColor = RGB(51, 51, 51)
        projectNameLabel.font = .font(fontSize: 16, fontName: .PingFSemibold)
        //
        lineImgV = UIImageView(image: UIImage(named: "verification_query_line"))
        //
        memberRemindLabel = UILabel()
        memberRemindLabel.text = "预约人"
        memberRemindLabel.textColor = RGB(51, 51, 51)
        memberRemindLabel.font = .font(fontSize: 14, fontName: .PingFMedium)
        //
        memberLabel = UILabel()
        memberLabel.textColor = RGB(51, 51, 51)
        memberLabel.font = .font(fontSize: 14, fontName: .PingFMedium)
        //
        timeRemindLabel = UILabel()
        timeRemindLabel.text = "预约时间"
        timeRemindLabel.textColor = RGB(51, 51, 51)
        timeRemindLabel.font = .font(fontSize: 14, fontName: .PingFMedium)
        //
        timeLabel = UILabel()
        timeLabel.textColor = RGB(51, 51, 51)
        timeLabel.font = .font(fontSize: 14, fontName: .PingFMedium)

        //
        queryButton = UIButton()
        queryButton.setTitle("确认核销", for: .normal)
        queryButton.setTitleColor(.white, for: .normal)
        queryButton.backgroundColor = HC_MAIN_COLOR
        queryButton.titleLabel?.font = .font(fontSize: 16)
        queryButton.layer.cornerRadius = 3
        queryButton.clipsToBounds = true
        
        //
        queryStatusBg = UIView()
        queryStatusBg.backgroundColor = .white
        queryStatusBg.isHidden = true
        
        queryStatusImgV = UIImageView(image: UIImage(named: "verification_success"))
        queryStatusLabel = UILabel()
        queryStatusLabel.textColor = RGB(51, 51, 51)
        queryStatusLabel.font = .font(fontSize: 16, fontName: .PingFMedium)
        queryStatusLabel.textAlignment = .center
        queryStatusLabel.numberOfLines = 0
        
        addSubview(colorBg)
        addSubview(contentBg)
        contentBg.addSubview(titleLabel)
        contentBg.addSubview(projectTitleLabel)
        contentBg.addSubview(projectNameLabel)
        contentBg.addSubview(lineImgV)
        contentBg.addSubview(memberRemindLabel)
        contentBg.addSubview(memberLabel)
        contentBg.addSubview(timeRemindLabel)
        contentBg.addSubview(timeLabel)
        contentBg.addSubview(queryButton)
        
        contentBg.addSubview(queryStatusBg)
        queryStatusBg.addSubview(queryStatusImgV)
        queryStatusBg.addSubview(queryStatusLabel)
    }
}
