//
//  HCRegisterPatientController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/9/19.
//  Copyright © 2020 sw. All rights reserved.
//  报到患者

import UIKit

class HCRegisterPatientController: BaseViewController {

    private var container: HCRegisterPatientContainer!
    private var viewModel: HCRegisterPatientViewModel!
    
    override func setupUI() {
        navigationItem.title = "报到患者"
        
        container = HCRegisterPatientContainer(frame: view.bounds)
        view.addSubview(container)
    }
    
    override func rxBind() {
        viewModel = HCRegisterPatientViewModel()
        
        container.tableView.prepare(viewModel)
        viewModel.datasource.asDriver()
            .drive(container.dataSignal)
            .disposed(by: disposeBag)
        
        container.tableView.headerRefreshing()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        container.frame = view.bounds
    }
}
