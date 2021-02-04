//
//  HCTeamContainMeController.swift
//  HuChuangApp
//
//  Created by sw on 2021/2/4.
//  Copyright © 2021 sw. All rights reserved.
//

import UIKit

class HCTeamContainMeController: HCSlideItemController {

    private var container: HCTeamContainMeContainer!
    
    private var viewModel: HCTeamContainMeViewModel!
    
    override func setupUI() {
        container = HCTeamContainMeContainer(frame: view.bounds)
        view.addSubview(container)
    }
    
    override func rxBind() {
        viewModel = HCTeamContainMeViewModel()
        
        viewModel.datasource.asDriver()
            .skip(1)
            .drive(container.datasource)
            .disposed(by: disposeBag)
        
        container.tableView.prepare(viewModel, isAddNoMoreContent: false)
        container.tableView.headerRefreshing()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        container.frame = view.bounds
    }
}
