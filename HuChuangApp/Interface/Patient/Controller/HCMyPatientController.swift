//
//  HCMyPatientController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/9/18.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCMyPatientController: BaseViewController, VMNavigation {

    private var container: HCMyPatientContainer!
    
    private var viewModel: HCMyPatientViewModel!
    
    override func setupUI() {
        container = HCMyPatientContainer.init(frame: view.bounds)
        view.addSubview(container)
        
        container.didSelectedCallBack = { [weak self] in
            HCMyPatientController.push(HCPatientManageController.self, ["model": $0])
        }
    }
    
    override func rxBind() {
        addBarItem(title: "随访计划", titleColor: RGB(12, 12, 12))
            .drive(onNext: { [unowned self] in
                PrintLog("随访计划")
            })
            .disposed(by: disposeBag)
        
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
