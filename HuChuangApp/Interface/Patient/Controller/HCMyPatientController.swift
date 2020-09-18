//
//  HCMyPatientController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/9/18.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCMyPatientController: BaseViewController {

    private var container: HCMyPatientContainer!
    
    private var viewModel: HCMyPatientViewModel!
    
    override func setupUI() {
        container = HCMyPatientContainer.init(frame: view.bounds)
        view.addSubview(container)
    }
    
    override func rxBind() {
        viewModel = HCMyPatientViewModel.init()
        
        viewModel.listSignal
            .subscribe(onNext: { [weak self] in self?.container.reload(with: $0.1, patientDatas: $0.0) })
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        container.frame = view.bounds
    }
}
