//
//  HCServerSettingController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/12/17.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCServerSettingController: BaseViewController, VMNavigation {

    private var container: HCServerSettingContainer!
    private var viewModel: HCServerSettingViewModel!
    
    override func setupUI() {
        navigationItem.title = "服务设置"
        
        container = HCServerSettingContainer.init(frame: view.bounds)
        view.addSubview(container)
        
        container.selectedCallBack = { [unowned self] in
            if $0.title == "图文咨询" {
                HCServerSettingController.push(HCPicConsultSettingController.self,
                                               ["model": viewModel.openStatusModel.picModel])
            }else if $0.title == "视频咨询" {
                HCServerSettingController.push(HCVideoConsultSettingController.self,
                                               ["model": viewModel.openStatusModel.videoModel])
            }else if $0.title == "精准预约" {
                HCServerSettingController.push(HCqueryScheduleConsultSettingController.self,
                                               ["model": viewModel.queryPreciseScheduleModel])
            }
        }
    }
    
    override func rxBind() {
        viewModel = HCServerSettingViewModel()
        
        viewModel.datasource.asDriver()
            .drive(onNext: { [weak self] in
                self?.container.datasource = $0
            })
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
    }
}
