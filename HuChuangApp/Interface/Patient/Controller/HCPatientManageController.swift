//
//  HCPatientManageController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/9/18.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCPatientManageController: HCSlideItemController {

    private var container: HCPatientManageContainer!
    
    private var viewModel: HCPatientManageViewModel!
    private var memberId: String = ""
    private var consultId: String = ""

    override func setupUI() {
        navigationItem.title = "患者管理"
        
        container = HCPatientManageContainer.init(frame: view.bounds)
        view.addSubview(container)
    }
    
    override func rxBind() {
        viewModel = HCPatientManageViewModel(memberId: memberId, consultId: consultId)
        
        viewModel.reloadSignal.asObservable()
            .subscribe(onNext: { [weak self] in self?.container.reload(listDatas: $0.1, patientInfo: $0.0) })
            .disposed(by: disposeBag)
        
        container.cellSelectedSignal
            .bind(to: viewModel.cellSelectedSignal)
            .disposed(by: disposeBag)
        
        container.saveSignal
            .bind(to: viewModel.saveSignal)
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        container.frame = view.bounds
    }
    
    override func prepare(parameters: [String : Any]?) {
        memberId = (parameters!["memberId"] as! String)
        consultId = (parameters!["consultId"] as! String)
    }
}
