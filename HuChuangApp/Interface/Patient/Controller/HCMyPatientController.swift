//
//  HCMyPatientController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/9/18.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCMyPatientController: BaseViewController, VMNavigation {

    private var container: HCMyPatientContainer!
    
    private var viewModel: HCMyPatientViewModel!
    
    override func setupUI() {
        container = HCMyPatientContainer.init(frame: view.bounds)
        view.addSubview(container)

        container.patientSelectedCallBack = {
            HCMyPatientController.push(HCPatientManageController.self, ["memberId": $0.memberId, "consultId": $0.consultId])
        }
        
        container.selectedCallBack = {
            switch $0.title {
            case "分组":
                HCMyPatientController.push(HCPatientGroupController.self)
            case "屏蔽患者":
                HCMyPatientController.push(HCHideMembersController.self)
            default:
                break
            }
        }
    }
    
    override func rxBind() {
//        addBarItem(title: "随访计划", titleColor: RGB(12, 12, 12))
//            .drive(onNext: { HCMyPatientController.push(HCFollowUpPlanController.self) })
//            .disposed(by: disposeBag)
        
        viewModel = HCMyPatientViewModel.init()
        
        container.tableView.prepare(viewModel, isAddNoMoreContent: false)
        
        viewModel.listSignal
            .subscribe(onNext: { [weak self] in self?.container.reload(with: $0.1, patientDatas: $0.0) })
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
        
        container.tableView.headerRefreshing()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        container.frame = view.bounds
    }
}
