//
//  HCPicConsultSettingPicker.swift
//  HuChuangApp
//
//  Created by yintao on 2020/12/18.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

import RxSwift

class HCPicConsultSettingPicker: HCPickerView {
    
    private var titleView: UIView!
    private var infoView: UIView!
    
    private var selectedInfo: [Int: Int] = [0: 0, 1: 0]
    
    public let submitSubject = PublishSubject<[String: String]>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        toolBar.removeFromSuperview()
        
        //
        titleView = UIView()
        titleView.backgroundColor = .white
        
        let closeButton = UIButton()
        closeButton.addTarget(self, action: #selector(actions(button:)), for: .touchUpInside)
        closeButton.tag = 200
        closeButton.setTitle("取消", for: .normal)
        closeButton.setTitleColor(HC_MAIN_COLOR, for: .normal)
        closeButton.titleLabel?.font = .font(fontSize: 15)
        
        let okButton = UIButton()
        okButton.addTarget(self, action: #selector(actions(button:)), for: .touchUpInside)
        okButton.tag = 201
        okButton.setTitle("确定", for: .normal)
        okButton.setTitleColor(HC_MAIN_COLOR, for: .normal)
        okButton.titleLabel?.font = .font(fontSize: 15)

        let titleLabel = UILabel()
        titleLabel.text = "排班设置"
        titleLabel.textAlignment = .center
        titleLabel.textColor = RGB(12, 12, 12)
        titleLabel.font = .font(fontSize: 16, fontName: .PingFSemibold)
        titleLabel.tag = 202
        
        let line = UIView()
        line.backgroundColor = RGB(241, 241, 241)
        line.tag = 203
        
        //
        infoView = UIView()
        infoView.backgroundColor = .white
        
        let startTimeLabel = UILabel()
        startTimeLabel.text = "开始时间"
        startTimeLabel.font = .font(fontSize: 12, fontName: .PingFSemibold)
        startTimeLabel.textColor = RGB(12, 12, 12)
        startTimeLabel.textAlignment = .center
        startTimeLabel.tag = 100
        
        let endTimeLabel = UILabel()
        endTimeLabel.text = "结束时间"
        endTimeLabel.font = .font(fontSize: 12, fontName: .PingFSemibold)
        endTimeLabel.textColor = RGB(12, 12, 12)
        endTimeLabel.textAlignment = .center
        endTimeLabel.tag = 101

        containerView.addSubview(titleView)
        containerView.addSubview(infoView)

        titleView.addSubview(titleLabel)
        titleView.addSubview(closeButton)
        titleView.addSubview(okButton)
        titleView.addSubview(line)
        
        infoView.addSubview(startTimeLabel)
        infoView.addSubview(endTimeLabel)
    }
    
    override func viewDidLayoutSubviews() {
        let containViewHeight = pickerHeight + 44 + 30
        containerView.frame = .init(x: 0, y: view.height - containViewHeight, width: view.width, height: containViewHeight)

        titleView.frame = .init(x: 0, y: 0, width: containerView.width, height: 44)
        titleView.viewWithTag(200)?.frame = .init(x: 10, y: 0, width: 35, height: 44)
        titleView.viewWithTag(201)?.frame = .init(x: containerView.width - 10 - 33, y: (44 - 33) / 2, width: 33, height: 33)
        titleView.viewWithTag(202)?.frame = .init(x: (titleView.width - 200) / 2.0,
                                                  y: 0, width: 200,
                                                  height: 44)
        titleView.viewWithTag(203)?.frame = .init(x: 0, y: titleView.height - 0.5, width: titleView.width, height: 0.5)

        infoView.frame = .init(x: 0, y: 44, width: containerView.width, height: 30)
        let w = containerView.width / 2.0
        infoView.viewWithTag(100)?.frame = .init(x: 0, y: 0, width: w, height: 30)
        infoView.viewWithTag(101)?.frame = .init(x: w, y: 0, width: w, height: 30)

        picker.frame = .init(x: 0, y: 44 + 30, width: containerView.width, height: pickerHeight)
        
        if containerView.layer.mask == nil {
            containerView.set(cornerRadius: 15, borderCorners: [.topLeft, .topRight])
        }
    }
    
    @objc private func actions(button: UIButton) {
        
        dismiss(animated: true) { [weak self] in
            guard let strongSelf = self else { return }
            if let firstRow = strongSelf.selectedInfo[0],
               let secondRow = strongSelf.selectedInfo[1] {
                strongSelf.submitSubject.onNext(["startTime":strongSelf.datasource[0].items[firstRow].title, "endTime":strongSelf.datasource[1].items[secondRow].title])
            }
        }
    }
    
    override func doneAction() {
                
        dismiss(animated: true) { [weak self] in
            guard let strongSelf = self else { return }
            if let firstRow = strongSelf.selectedInfo[0],
               let secondRow = strongSelf.selectedInfo[1],
               let thirdRow = strongSelf.selectedInfo[2] {
                strongSelf.submitSubject.onNext(["startTime":strongSelf.datasource[0].items[firstRow].title, "endTime":strongSelf.datasource[1].items[secondRow].title, "recevieNum":strongSelf.datasource[2].items[thirdRow].title])
            }
        }
    }
}

extension HCPicConsultSettingPicker {
    
    override func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        super.pickerView(pickerView, didSelectRow: row, inComponent: component)
        
        selectedInfo[component] = row
    }

}
