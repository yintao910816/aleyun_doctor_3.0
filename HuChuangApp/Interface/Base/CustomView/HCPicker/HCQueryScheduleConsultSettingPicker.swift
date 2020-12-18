//
//  HCQueryScheduleConsultSettingPicker.swift
//  HuChuangApp
//
//  Created by yintao on 2020/12/18.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit
import RxSwift

class HCQueryScheduleConsultSettingPicker: UIViewController {
    
    private var containerView: UIView!
    
    private var titleView: UIView!
    private var bottomView: HCConsultSettingBottomActionView!
    
    private var morningLabel: UILabel!
    private var morningCountLabel: UILabel!
    private var morningAddButton: UIButton!
    private var morningDecreaseButton: UIButton!
    private var morningRemindLabel: UILabel!

    private var afternoonLabel: UILabel!
    private var afternoonCountLabel: UILabel!
    private var afternoonAddButton: UIButton!
    private var afternoonDecreaseButton: UIButton!
    private var afternoonRemindLabel: UILabel!

    public var morningCount: Int = 0
    public var afternoonCount: Int = 0

    public var morningReservedNum: Int = 0
    public var afternoonReservedNum: Int = 0
    
    public var mode: HCConsultSettingDelMode = .noSetting

    public let submitSubject = PublishSubject<[String: String]>()
    public let cancelScheduleSubject = PublishSubject<Void>()

    override func viewDidLoad() {
        super.viewDidLoad()
           
        containerView = UIView()
        containerView.backgroundColor = .white
        
        //
        titleView = UIView()
        titleView.backgroundColor = .white
        
        let closeButton = UIButton()
        closeButton.setImage(UIImage(named: "close"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        closeButton.tag = 200
        closeButton.contentEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
        
        let titleLabel = UILabel()
        titleLabel.text = "排班设置"
        titleLabel.textAlignment = .center
        titleLabel.textColor = RGB(12, 12, 12)
        titleLabel.font = .font(fontSize: 16, fontName: .PingFSemibold)
        titleLabel.tag = 201
        
        let line = UIView()
        line.backgroundColor = RGB(241, 241, 241)
        line.tag = 202
        
        //
        morningLabel = UILabel()
        morningLabel.text = "上午接诊人数"
        morningLabel.textColor = RGB(51, 51, 51)
        morningLabel.font = .font(fontSize: 15, fontName: .PingFSemibold)
        
        morningRemindLabel = UILabel()
        morningRemindLabel.text = "当前已预约\(morningReservedNum)人"
        morningRemindLabel.textColor = RGB(231, 93, 88)
        morningRemindLabel.font = .font(fontSize: 14, fontName: .PingFSemibold)
        morningRemindLabel.isHidden = true
        
        morningCountLabel = UILabel()
        morningCountLabel.text = "\(morningCount)"
        morningCountLabel.textColor = RGB(51, 51, 51)
        morningCountLabel.font = .font(fontSize: 15, fontName: .PingFSemibold)
        morningCountLabel.textAlignment = .center
        
        morningDecreaseButton = UIButton()
        morningDecreaseButton.setImage(UIImage(named: "count_decrease_gray"), for: .normal)
        morningDecreaseButton.setImage(UIImage(named: "count_decrease"), for: .selected)
        morningDecreaseButton.addTarget(self, action: #selector(actions(button:)), for: .touchUpInside)
        morningDecreaseButton.contentEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
        morningDecreaseButton.isSelected = morningCount > 0
        
        morningAddButton = UIButton()
        morningAddButton.setImage(UIImage(named: "count_add"), for: .normal)
        morningAddButton.addTarget(self, action: #selector(actions(button:)), for: .touchUpInside)
        morningAddButton.contentEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)

        //
        afternoonLabel = UILabel()
        afternoonLabel.text = "下午接诊人数"
        afternoonLabel.textColor = RGB(51, 51, 51)
        afternoonLabel.font = .font(fontSize: 15, fontName: .PingFSemibold)

        afternoonRemindLabel = UILabel()
        afternoonRemindLabel.text = "当前已预约\(afternoonReservedNum)人"
        afternoonRemindLabel.textColor = RGB(231, 93, 88)
        afternoonRemindLabel.font = .font(fontSize: 14, fontName: .PingFSemibold)
        afternoonRemindLabel.isHidden = true

        afternoonCountLabel = UILabel()
        afternoonCountLabel.text = "\(afternoonCount)"
        afternoonCountLabel.textColor = RGB(51, 51, 51)
        afternoonCountLabel.font = .font(fontSize: 15, fontName: .PingFSemibold)
        afternoonCountLabel.textAlignment = .center

        afternoonDecreaseButton = UIButton()
        afternoonDecreaseButton.setImage(UIImage(named: "count_decrease_gray"), for: .normal)
        afternoonDecreaseButton.setImage(UIImage(named: "count_decrease"), for: .selected)
        afternoonDecreaseButton.addTarget(self, action: #selector(actions(button:)), for: .touchUpInside)
        afternoonDecreaseButton.contentEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
        afternoonDecreaseButton.isSelected = afternoonCount > 0

        afternoonAddButton = UIButton()
        afternoonAddButton.setImage(UIImage(named: "count_add"), for: .normal)
        afternoonAddButton.addTarget(self, action: #selector(actions(button:)), for: .touchUpInside)
        afternoonAddButton.contentEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)

        //
        bottomView = HCConsultSettingBottomActionView()
        bottomView.setTitle(leftTitle: "取消排班", rightTitle: "确定")
        bottomView.actionCallBack = { [unowned self] in
            if $0 == .save {
                self.doneAction()
            }else {
                switch mode {
                case .enable:
                    NoticesCenter.alert(title: "提示", message: "确定要清空当前排班吗", cancleTitle: "取消", okTitle: "确定", callBackOK:  {
                        self.dismiss(animated: true) { [weak self] in
                            self?.cancelScheduleSubject.onNext(Void())
                        }
                    })
                case .hasReceive:
                    NoticesCenter.alert(message: "已有\(morningReservedNum + afternoonReservedNum)人预约")
                case .noSetting:
                    NoticesCenter.alert(message: "还未设置排班")
                }
            }
        }

        view.addSubview(containerView)
        
        titleView.addSubview(titleLabel)
        titleView.addSubview(closeButton)
        titleView.addSubview(line)
        
        containerView.addSubview(titleView)
        containerView.addSubview(bottomView)
        containerView.addSubview(morningLabel)
        containerView.addSubview(morningRemindLabel)
        containerView.addSubview(morningCountLabel)
        containerView.addSubview(morningDecreaseButton)
        containerView.addSubview(morningAddButton)
        containerView.addSubview(afternoonLabel)
        containerView.addSubview(afternoonRemindLabel)
        containerView.addSubview(afternoonCountLabel)
        containerView.addSubview(afternoonDecreaseButton)
        containerView.addSubview(afternoonAddButton)

        let tapGes = UITapGestureRecognizer.init(target: self, action: #selector(tapAction))
        tapGes.delegate = self
        view.addGestureRecognizer(tapGes)

    }
    
    override func viewDidLayoutSubviews() {
        containerView.frame = .init(x: 0, y: view.height - 265, width: view.width, height: 265)

        titleView.frame = .init(x: 0, y: 0, width: containerView.width, height: 44)
        titleView.viewWithTag(201)?.frame = .init(x: 0, y: 0, width: containerView.width, height: 44)
        titleView.viewWithTag(200)?.frame = .init(x: containerView.width - 10 - 33, y: (44 - 33) / 2, width: 33, height: 33)
        titleView.viewWithTag(202)?.frame = .init(x: 0, y: 43.5, width: titleView.width, height: 0.5)
        
        //
        bottomView.frame = .init(x: 0, y: containerView.height - 50, width: containerView.width, height: 50)
        
        //
        morningLabel.frame = .init(x: 30, y: 75, width: 90, height: 20)
        morningRemindLabel.frame = .init(x: morningLabel.x,
                                         y: morningLabel.frame.maxY + 5,
                                         width: containerView.width - morningLabel.x * 2,
                                         height: 16)
        morningAddButton.frame = .init(x: containerView.width - 15 - 40, y: 69, width: 40, height: 40)
        morningCountLabel.frame = .init(x: morningAddButton.x - 40 , y: 79, width: 40, height: 20)
        morningDecreaseButton.frame = .init(x: morningCountLabel.x - 40, y: 69, width: 40, height: 40)

        //
        afternoonLabel.frame = .init(x: 30, y: morningLabel.frame.maxY + 35, width: 90, height: 20)
        afternoonRemindLabel.frame = .init(x: afternoonLabel.x,
                                           y: afternoonLabel.frame.maxY + 5,
                                           width: containerView.width - morningLabel.x * 2,
                                           height: 16)
        afternoonAddButton.frame = .init(x: containerView.width - 15 - 40, y: morningAddButton.frame.maxY + 15, width: 40, height: 40)
        afternoonCountLabel.frame = .init(x: afternoonAddButton.x - 40 , y: morningCountLabel.frame.maxY + 35, width: 40, height: 20)
        afternoonDecreaseButton.frame = .init(x: morningCountLabel.x - 40, y: morningDecreaseButton.frame.maxY + 15, width: 40, height: 40)

        if containerView.layer.mask == nil {
            containerView.set(cornerRadius: 15, borderCorners: [.topLeft, .topRight])
        }
    }
    
    @objc private func closeAction() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func actions(button: UIButton) {
        if button == morningDecreaseButton {
            if morningReservedNum > 0, morningCount <= morningReservedNum {
                morningRemindLabel.isHidden = false
                morningDecreaseButton.isSelected = false
                return
            }
            
            morningRemindLabel.isHidden = true
            
            if morningCount <= 0 {
                morningDecreaseButton.isSelected = false
                morningCount = 0
            }else {
                morningCount -= 1
                morningDecreaseButton.isSelected = morningCount > 0
            }
            
            if morningReservedNum > 0, morningCount <= morningReservedNum {
                morningRemindLabel.isHidden = false
                morningDecreaseButton.isSelected = false
            }
        }else if button == morningAddButton {
            morningRemindLabel.isHidden = true

            morningCount += 1
            morningDecreaseButton.isSelected = true
        }else if button == afternoonDecreaseButton {
            if afternoonReservedNum > 0, afternoonCount <= afternoonReservedNum {
                afternoonRemindLabel.isHidden = false
                afternoonDecreaseButton.isSelected = false
                return
            }
            
            afternoonRemindLabel.isHidden = true

            if afternoonCount <= 0 {
                afternoonDecreaseButton.isSelected = false
                afternoonCount = 0
            }else {
                afternoonCount -= 1
                afternoonDecreaseButton.isSelected = afternoonCount > 0
            }
            
            if afternoonReservedNum > 0, afternoonCount <= afternoonReservedNum {
                afternoonRemindLabel.isHidden = false
                afternoonDecreaseButton.isSelected = false
            }
        }else if button == afternoonAddButton {
            afternoonRemindLabel.isHidden = true

            afternoonCount += 1
            afternoonDecreaseButton.isSelected = true
        }
        
        morningCountLabel.text = "\(morningCount)"
        afternoonCountLabel.text = "\(afternoonCount)"
    }
    
    @objc func tapAction() {
        dismiss(animated: true, completion: nil)
    }
    
    private func doneAction() {
                
        dismiss(animated: true) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.submitSubject.onNext(["morningNum":"\(strongSelf.morningCount)", "afternoonNum":"\(strongSelf.afternoonCount)"])
        }
    }
}

extension HCQueryScheduleConsultSettingPicker: UIGestureRecognizerDelegate {

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return !containerView.frame.contains(gestureRecognizer.location(in: view))
    }
}
