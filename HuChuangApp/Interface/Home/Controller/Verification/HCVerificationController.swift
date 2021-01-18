//
//  HCVerificationController.swift
//  HuChuangApp
//
//  Created by sw on 2021/1/6.
//  Copyright © 2021 sw. All rights reserved.
//

import UIKit

class HCVerificationController: BaseViewController {
    
    private var container: HCVerificationContainer!
    private var viewModel: HCVerificationViewModel!
    
    override func setupUI() {
        navigationItem.title = "核销"
        
        container = HCVerificationContainer.init(frame: view.bounds)
        view.addSubview(container)
        
        container.actionCallBack = { [unowned self] in
            switch $0.0 {
            case .search:
                viewModel.getVerificationByCodeSignal.onNext((false, $0.1))
            case .scan:
                pushScan()
            }
        }
    }
    
    override func rxBind() {
        viewModel = HCVerificationViewModel()
                
        container.tableView.prepare(viewModel, isAddNoMoreContent: false)
        
        viewModel.datasource.asDriver()
            .drive(container.datasource)
            .disposed(by: disposeBag)
        
        viewModel.scanErrorSignal
            .subscribe(onNext: { [weak self] in
                if $0.0 {
                    self?.navigationController?.popViewController(animated: false)
                }

                let ctrl = HCVerificationQueryController()
                ctrl.prepare(parameters: ["error": $0.1])
                self?.navigationController?.pushViewController(ctrl, animated: true)
                
                ctrl.scanCallBack = { [weak self] in
                    self?.navigationController?.popViewController(animated: false)
                    self?.pushScan()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.scaanResultSignal
            .subscribe(onNext: { [weak self] in
                if $0.0 {
                    self?.navigationController?.popViewController(animated: false)
                }
                let ctrl = HCVerificationQueryController()
                ctrl.prepare(parameters: ["model": $0.1])
                self?.navigationController?.pushViewController(ctrl, animated: true)
                
                ctrl.scanCallBack = { [weak self] in
                    self?.navigationController?.popViewController(animated: false)
                    self?.pushScan()
                }
            })
            .disposed(by: disposeBag)
        
        container.tableView.headerRefreshing()
    }
    
    private func pushScan() {
        let scanCtrl = HCScanViewController()
        scanCtrl.scanResultCallBack = { [weak self] in
            self?.viewModel.getVerificationByCodeSignal.onNext((true, $0))
        }
        navigationController?.pushViewController(scanCtrl, animated: true)
    }
}
