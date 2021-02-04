//
//  HCAddTeamMemberController.swift
//  HuChuangApp
//
//  Created by sw on 2021/2/4.
//  Copyright © 2021 sw. All rights reserved.
//

import UIKit

class HCAddTeamMemberController: BaseViewController {

    private var container: HCAddTeamMemberContainer!
    private var viewModel: HCAddTeamMemberViewModel!
    
    override func setupUI() {
        navigationItem.title = "添加组员"
        
        container = HCAddTeamMemberContainer(frame: view.bounds)
        container.searchBar.beginSearch = { [unowned self] in
            viewModel.searchSignal.onNext($0)
        }
        view.addSubview(container)
    }
    
    override func rxBind() {
        viewModel = HCAddTeamMemberViewModel(addTap: container.addMemberButton.rx.tap.asDriver())
        
        container.tableView.prepare(viewModel, isAddNoMoreContent: true)
        
        viewModel.datasource.asDriver()
            .drive(container.datasource)
            .disposed(by: disposeBag)
        
        viewModel.popSubject
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        container.tableView.headerRefreshing()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        container.frame = view.bounds
    }
}
