//
//  HCPatientManageController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/9/18.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCPatientManageController: BaseViewController {

    private var container: HCPatientManageContainer!
    
    private var viewModel: HCPatientManageViewModel!
    private var patientInfo: HCPatientItemModel!
    
    override func setupUI() {
        navigationItem.title = "患者管理"
        
        container = HCPatientManageContainer.init(frame: view.bounds)
        view.addSubview(container)
    }
    
    override func rxBind() {
        viewModel = HCPatientManageViewModel.init(patientInfo: patientInfo)
        
        viewModel.reloadSignal
            .subscribe(onNext: { [weak self] in self?.container.reload(listDatas: $0.1, patientInfo: $0.0) })
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        container.frame = view.bounds
    }
    
    override func prepare(parameters: [String : Any]?) {
        patientInfo = (parameters!["model"] as! HCPatientItemModel)
    }
}
