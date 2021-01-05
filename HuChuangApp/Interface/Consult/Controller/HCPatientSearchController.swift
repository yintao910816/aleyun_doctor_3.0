//
//  HCPatientSearchController.swift
//  HuChuangApp
//
//  Created by yintao on 2021/1/4.
//  Copyright © 2021 sw. All rights reserved.
//

import UIKit

class HCPatientSearchController: BaseViewController {

    private var container: HCPatientSearchContainer!

    private var viewModel: HCPatientSearchViewModel!
    
    override func setupUI() {
        navigationItem.title = "搜索"
        
        container = HCPatientSearchContainer.init(frame: view.bounds)
        view.addSubview(container)
    }
    
    override func rxBind() {
        viewModel = HCPatientSearchViewModel()
        
        viewModel.datasource.asDriver()
            .drive(container.datasource)
            .disposed(by: disposeBag)
        
        container.beginSearchSignal
            .bind(to: viewModel.beginSearchSignal)
            .disposed(by: disposeBag)
        
        container.tableView.rx.modelSelected(HCPatientGroupListItemModel.self)
            .bind(to: viewModel.selectedSignal)
            .disposed(by: disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        container.frame = view.bounds
    }
}
