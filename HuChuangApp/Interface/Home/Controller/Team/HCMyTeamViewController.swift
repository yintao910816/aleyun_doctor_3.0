//
//  HCMyTeamViewController.swift
//  HuChuangApp
//
//  Created by sw on 2021/2/4.
//  Copyright © 2021 sw. All rights reserved.
//

import UIKit

class HCMyTeamViewController: HCSlideItemController {

    private var viewModel: HCMyTeamViewModel!
    
    private var container: HCMyTeamContainer!
    
    public var addMemberClicked: (()->())?
    
    override func setupUI() {
        container = HCMyTeamContainer(frame: view.bounds)
        view.addSubview(container)
        
        container.addMemberButton.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [unowned self] in addMemberClicked?() })
            .disposed(by: disposeBag)
    }
    
    override func rxBind() {
        viewModel = HCMyTeamViewModel()
        container.tableView.prepare(viewModel, showFooter: true, showHeader: true, isAddNoMoreContent: false)
        
        viewModel.datasource.asDriver()
            .skip(1)
            .drive(container.datasource)
            .disposed(by: disposeBag)
        
        container.deleteSignal
            .bind(to: viewModel.deleteSignal)
            .disposed(by: disposeBag)
        
        viewModel.errorSingle
            .bind(to: container.errorSingle)
            .disposed(by: disposeBag)
        
        container.tableView.headerRefreshing()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        container.frame = view.bounds
    }
}
