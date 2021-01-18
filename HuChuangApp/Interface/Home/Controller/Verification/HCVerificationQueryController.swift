//
//  HCVerificationQueryController.swift
//  HuChuangApp
//
//  Created by sw on 2021/1/7.
//  Copyright © 2021 sw. All rights reserved.
//

import UIKit

class HCVerificationQueryController: BaseViewController {
    
    private var infoModel: HCVerificationItemModel?
    private var errorText: String = ""

    private var container: HCVerificationQueryContainer!
    private var viewModel: HCVerificationQueryViewModel!
    
    public var scanCallBack: (()->())?
    
    override func setupUI() {
        navigationItem.title = "核销"
        
        container = HCVerificationQueryContainer.init(frame: view.bounds)
        view.addSubview(container)
    }
    
    override func rxBind() {
        container.infoModel = infoModel ?? HCVerificationItemModel()
        
        viewModel = HCVerificationQueryViewModel(infoModel: infoModel ?? HCVerificationItemModel(),
                                                 queryTap: container.queryButton.rx.tap.asDriver())

        viewModel.verificationStatusSignal
            .bind(to: container.verificationStatusSignal)
            .disposed(by: disposeBag)
        
        viewModel.reScanSignal
            .subscribe(onNext: { [weak self] in self?.scanCallBack?() })
            .disposed(by: disposeBag)
        
        viewModel.popSubject
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popToRootViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        if infoModel == nil {
            container.verificationStatusSignal.onNext((false, errorText))
        }
    }
    
    override func prepare(parameters: [String : Any]?) {
        infoModel = (parameters?["model"] as? HCVerificationItemModel)
        errorText = (parameters?["error"] as? String) ?? "核销失败"
    }
}
