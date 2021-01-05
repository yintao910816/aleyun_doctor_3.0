//
//  HCPatientCycleCell.swift
//  HuChuangApp
//
//  Created by yintao on 2020/5/15.
//  Copyright © 2020 sw. All rights reserved.
//  周期档案

import UIKit

public let HCPatientCycleCell_identifier = "HCPatientCycleCell_identifier"

class HCPatientCycleCell: UITableViewCell {

    @IBOutlet weak var circleOutlet: UILabel!
    @IBOutlet weak var timeOutlet: UILabel!
    @IBOutlet weak var nameWOutlet: UILabel!
    @IBOutlet weak var nameMOutlet: UILabel!
    @IBOutlet weak var opsnameOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        circleOutlet.layer.cornerRadius = 15
        circleOutlet.layer.borderWidth = 1
        circleOutlet.layer.borderColor = HC_MAIN_COLOR.cgColor
    }
    
    public var model: HCPatientCircleModel! {
        didSet {
            let endTime = model.enddate.count == 0 ? "无" : model.enddate
            timeOutlet.text = "\(model.begindate)/\(endTime)"
            nameWOutlet.text = model.name_w
            nameMOutlet.text = model.name_m
            circleOutlet.text = model.patientmemo.count > 0 ? model.patientmemo : "无"
            opsnameOutlet.text = model.opsname
        }
    }
}
