//
//  HCConsultListController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/10/14.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCConsultListController: BaseViewController, VMNavigation {

    private var container: HCConsultListContainer!
    
    private var viewModel: HCConsultListViewModel!

    override func setupUI() {
        navigationItem.title = "消息"
        
        container = HCConsultListContainer.init(frame: view.bounds)
        view.addSubview(container)

    }
    
    override func rxBind() {
        viewModel = HCConsultListViewModel()
        
        viewModel.datasource.asDriver()
            .drive(container.dataSignal)
            .disposed(by: disposeBag)
        
        container.tableView.prepare(viewModel)
        container.tableView.headerRefreshing()
        
        container.tableView.rx.modelSelected(HCConsultListItemModel.self)
            .asDriver()
            .drive(onNext: { HCConsultListController.push(HCConsultDetailController.self, ["model":$0]) })
            .disposed(by: disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        container.frame = view.bounds
    }
    
}
