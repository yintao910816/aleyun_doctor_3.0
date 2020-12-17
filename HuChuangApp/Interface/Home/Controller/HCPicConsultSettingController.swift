//
//  HCPicConsultSettingController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/12/17.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCPicConsultSettingController: BaseViewController {

    private var model: HCConsultStatusModel!
    private var container: HCPicConsultSettingContainer!
    private var viewModel: HCPicConsultSettingViewModel!
    
    override func setupUI() {
        navigationItem.title = "图文咨询设置"
        
        container = HCPicConsultSettingContainer.init(frame: view.bounds)
        view.addSubview(container)
    }
    
    override func rxBind() {
        viewModel = HCPicConsultSettingViewModel(model: model)
        
        viewModel.datasource.asDriver()
            .drive(onNext: { [unowned self] in self.container.datasource = $0 })
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        container.frame = view.bounds
    }
    
    override func prepare(parameters: [String : Any]?) {
        model = (parameters!["model"] as! HCConsultStatusModel)
    }
}
