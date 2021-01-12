//
//  HCVideoConsultSettingPicker.swift
//  HuChuangApp
//
//  Created by yintao on 2020/12/18.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

import RxSwift

class HCVideoConsultSettingPicker: HCPickerView {

    private var titleView: UIView!
    
    private var infoView: UIView!
    private var bottomView: HCConsultSettingBottomActionView!
    
    private var selectedInfo: [Int: Int] = [0: 0, 1: 0, 2: 0]
    
    public let submitSubject = PublishSubject<[String: String]>()
    public let cancelScheduleSubject = PublishSubject<Void>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        toolBar.removeFromSuperview()
        
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
        
        bottomView = HCConsultSettingBottomActionView()
        bottomView.setTitle(leftTitle: "取消排班", rightTitle: "确定")
        bottomView.actionCallBack = { [unowned self] in
            if $0 == .save {
                self.doneAction()
            }else {
                NoticesCenter.alert(title: "提示", message: "确定要清空当前排班吗", cancleTitle: "取消", okTitle: "确定", callBackOK:  {
                    self.dismiss(animated: true) { [weak self] in
                        self?.cancelScheduleSubject.onNext(Void())
                    }
                })
            }
        }
        
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

        let peosLabel = UILabel()
        peosLabel.text = "人数"
        peosLabel.font = .font(fontSize: 12, fontName: .PingFSemibold)
        peosLabel.textColor = RGB(12, 12, 12)
        peosLabel.textAlignment = .center
        peosLabel.tag = 102

        containerView.addSubview(titleView)
        titleView.addSubview(titleLabel)
        titleView.addSubview(closeButton)
        titleView.addSubview(line)
        
        infoView.addSubview(startTimeLabel)
        infoView.addSubview(endTimeLabel)
        infoView.addSubview(peosLabel)
        
        containerView.addSubview(infoView)
        containerView.addSubview(bottomView)        
    }
    
    public func configData(dayModel: HCVideoDaySettingModel, pickerSource: [HCPickerSectionData]) {
        datasource = pickerSource
        
        if let item = dayModel.settingModel {
            if let startIdx = datasource[0].items.firstIndex(where: { $0.title == item.startTimeText }) {
                selectedInfo[0] = startIdx
                picker.selectRow(startIdx, inComponent: 0, animated: false)
            }
            if let endIdx = datasource[1].items.firstIndex(where: { $0.title == item.endTimeText }) {
                selectedInfo[1] = endIdx
                picker.selectRow(endIdx, inComponent: 1, animated: false)
            }
            if let numIdx = datasource[2].items.firstIndex(where: { $0.title == item.recevieNum }) {
                selectedInfo[2] = numIdx
                picker.selectRow(numIdx, inComponent: 2, animated: false)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        let containViewHeight = pickerHeight + 44 + 30 + 50
        containerView.frame = .init(x: 0, y: view.height - containViewHeight, width: view.width, height: containViewHeight)

        titleView.frame = .init(x: 0, y: 0, width: containerView.width, height: 44)
        titleView.viewWithTag(201)?.frame = .init(x: 0, y: 0, width: containerView.width, height: 44)
        titleView.viewWithTag(200)?.frame = .init(x: containerView.width - 10 - 33, y: (44 - 33) / 2, width: 33, height: 33)
        titleView.viewWithTag(202)?.frame = .init(x: 0, y: 43.5, width: titleView.width, height: 0.5)
        
        picker.frame = .init(x: 0, y: 44 + 30, width: containerView.width, height: pickerHeight)

        bottomView.frame = .init(x: 0, y: containViewHeight - 50, width: containerView.width, height: 50)
        
        infoView.frame = .init(x: 0, y: 44, width: containerView.width, height: 30)
        let w = containerView.width / 3.0
        infoView.viewWithTag(100)?.frame = .init(x: 0, y: 0, width: w, height: 30)
        infoView.viewWithTag(101)?.frame = .init(x: w, y: 0, width: w, height: 30)
        infoView.viewWithTag(102)?.frame = .init(x: 2 * w, y: 0, width: w, height: 30)
        
        if containerView.layer.mask == nil {
            containerView.set(cornerRadius: 15, borderCorners: [.topLeft, .topRight])
        }
    }
    
    @objc private func closeAction() {
        dismiss(animated: true, completion: nil)
    }
    
    override func doneAction() {
        
        guard let firstRow = selectedInfo[0],
              let secondRow = selectedInfo[1],
              let thirdRow = selectedInfo[2] else {
            NoticesCenter.alert(message: "时间格式化错误")
            return
        }
        
        let startTime = datasource[0].items[firstRow].title
        let endTime = datasource[1].items[secondRow].title
        
        let tempStartTime = "2020-12-01 \(startTime)"
        let tempEndTime = "2020-12-01 \(endTime)"
        
        let compare = TYDateCalculate.compare(dateStr: tempStartTime, other: tempEndTime, mode: .yymmddhhmm)
        if compare != .orderedAscending {
            NoticesCenter.alert(message: "结束时间必须大于开始时间")
            return
        }

        dismiss(animated: true) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.submitSubject.onNext(["startTime": startTime, "endTime": endTime, "recevieNum":strongSelf.datasource[2].items[thirdRow].title])
        }
    }
}

extension HCVideoConsultSettingPicker {
    
    
    override func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        super.pickerView(pickerView, didSelectRow: row, inComponent: component)
        
        selectedInfo[component] = row
    }

}
