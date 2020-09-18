//
//  HCPatientGroupController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/9/18.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCPatientGroupController: BaseViewController {

    private var viewModel: HCPatientGroupViewModel!
    private var container: HCPatientGroupContainer!
    
    override func setupUI() {
        navigationItem.title = "分组"

        container = HCPatientGroupContainer(frame: view.bounds)
        view.addSubview(container)
        
        container.didSelectedCallBack = { [weak self] in
            PrintLog($0.memberName)
        }
    }
    
    override func rxBind() {
        addBarItem(title: "分组管理", titleColor: RGB(12, 12, 12))
            .drive(onNext: { [unowned self] in
                PrintLog("分组管理")
            })
            .disposed(by: disposeBag)

        viewModel = HCPatientGroupViewModel()
        
        viewModel.datasource.asDriver()
            .drive(onNext: { [weak self] in self?.container.groupDatas = $0 })
            .disposed(by: disposeBag)
        
        container.tableView.prepare(viewModel, showFooter: false, showHeader: true)
        container.tableView.headerRefreshing()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        container.frame = view.bounds
    }
}
