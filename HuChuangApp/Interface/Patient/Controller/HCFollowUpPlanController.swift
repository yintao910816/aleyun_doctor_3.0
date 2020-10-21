//
//  HCFollowUpPlanController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/9/19.
//  Copyright © 2020 sw. All rights reserved.
//  随访计划

import UIKit

class HCFollowUpPlanController: BaseViewController, VMNavigation {

    override func setupUI() {
        navigationItem.title = "随访计划"
    }
    
    override func rxBind() {
        addBarItem(title: "新增", titleColor: RGB(12, 12, 12))
            .drive(onNext: { HCMyPatientController.push(HCFollowUpAddViewController.self) })
            .disposed(by: disposeBag)

    }
}
