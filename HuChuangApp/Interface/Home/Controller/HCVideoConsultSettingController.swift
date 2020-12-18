//
//  HCVideoConsultSettingController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/12/17.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCVideoConsultSettingController: BaseViewController {
   
    private var model: HCConsultStatusModel!
    private var container: HCVideoConsultSettingContainer!
    private var viewModel: HCVideoConsultSettingViewModel!
    
    override func setupUI() {
        navigationItem.title = "视频咨询设置"
        
        container = HCVideoConsultSettingContainer.init(frame: view.bounds)
        view.addSubview(container)
        
        container.dayItemSelectedCallBack = { [unowned self] _ in
            let picker = HCVideoConsultSettingPicker()
            picker.pickerHeight = 230
            picker.datasource = HCPickerSectionData.createVideoConsultSettingDatas()
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
        viewModel = HCVideoConsultSettingViewModel(model: model)
        
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
        model = (parameters!["model"] as! HCConsultStatusModel)
    }
}

