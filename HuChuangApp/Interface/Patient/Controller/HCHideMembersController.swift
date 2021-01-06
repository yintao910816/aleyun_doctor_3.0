//
//  HCHideMembersController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/11/19.
//  Copyright © 2020 sw. All rights reserved.
//  屏蔽患者列表

import UIKit

class HCHideMembersController: BaseViewController, VMNavigation {

    private var container: HCHideMembersContainer!
    private var viewModel: HCHideMembersViewModel!
    
    override func setupUI() {
        navigationItem.title = "屏蔽患者"
        
        container = HCHideMembersContainer.init(frame: view.bounds)
        view.addSubview(container)
    }

    override func rxBind() {
        viewModel = HCHideMembersViewModel()
        container.tableView.prepare(viewModel)
        
        viewModel.datasource.asDriver()
            .drive(container.tableView.rx.items(cellIdentifier: HCMyPatientListCell_identifier, cellType: HCMyPatientListCell.self)) { _, model, cell in
                cell.model = model
            }
            .disposed(by: disposeBag)
        
        container.tableView.rx.modelSelected(HCPatientItemModel.self)
            .subscribe(onNext: { HCHideMembersController.push(HCPatientManageController.self, ["memberId": $0.memberId, "consultId": $0.consultId]) })
            .disposed(by: disposeBag)
        
        container.tableView.headerRefreshing()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        container.frame = view.bounds
    }
}
