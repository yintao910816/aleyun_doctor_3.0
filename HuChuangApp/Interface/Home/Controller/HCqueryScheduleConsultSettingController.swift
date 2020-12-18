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
        
        container.dayItemSelectedCallBack = { [unowned self] in
            let picker = HCQueryScheduleConsultSettingPicker()
            if let m = $0.settingModel {
                picker.afternoonCount = m.afternoonReservedNum > 0 ? m.afternoonReservedNum : m.afternoonNum
                picker.morningCount = m.morningReservedNum > 0 ? m.morningReservedNum : m.morningNum
                picker.morningReservedNum = m.morningReservedNum
                picker.afternoonReservedNum = m.afternoonReservedNum
                picker.mode = (m.morningReservedNum > 0 || m.afternoonReservedNum > 0) ? .hasReceive : .enable
            }else {
                picker.mode = .noSetting
            }
            picker.submitSubject
                .bind(to: self.viewModel.submitSubject)
                .disposed(by: disposeBag)
            picker.cancelScheduleSubject
                .bind(to: self.viewModel.cancelScheduleSubject)
                .disposed(by: disposeBag)
            self.model(for: picker, controllerHeight: self.view.height)
        }

    }
    
    override func rxBind() {
        viewModel = HCqueryScheduleConsultSettingViewModel(model: model)
        
        viewModel.datasource.asDriver()
            .drive(onNext: { [unowned self] in self.container.datasource = $0 })
            .disposed(by: disposeBag)
        
        container.updateConsultUserStatusSubject
            .bind(to: viewModel.updateConsultUserStatusSubject)
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
