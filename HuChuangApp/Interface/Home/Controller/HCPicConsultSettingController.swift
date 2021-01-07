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
        
        container.cellDidSelected = { [unowned self] in
            if $0.row == 3 {
                let picker = HCPicConsultSettingPicker()
                picker.pickerHeight = 230
                picker.configData(model: model, pickerSource: HCPickerSectionData.createPicConsultSettingDatas())
                picker.submitSubject
                    .bind(to: self.viewModel.submitSubject)
                    .disposed(by: disposeBag)
                self.model(for: picker, controllerHeight: self.view.height)
            }
        }
        
        container.closeCallBack = { [unowned self] in
            navigationController?.popViewController(animated: true)
        }
    }
    
    override func rxBind() {
        viewModel = HCPicConsultSettingViewModel(model: model)
        
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
