//
//  HCqueryScheduleConsultSettingController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/12/17.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCqueryScheduleConsultSettingController: BaseViewController {
    
    private var model: HCQueryPreciseScheduleModel!
    private var container: HCQueryScheduleConsultSettingContainer!
    private var viewModel: HCqueryScheduleConsultSettingViewModel!

    override func setupUI() {
        navigationItem.title = "精准预约设置"
        
        container = HCQueryScheduleConsultSettingContainer.init(frame: view.bounds)
        view.addSubview(container)
    }
    
    override func rxBind() {
        viewModel = HCqueryScheduleConsultSettingViewModel(model: model)
        
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
        model = (parameters!["model"] as! HCQueryPreciseScheduleModel)
    }
}
