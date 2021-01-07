//
//  HCVerificationQueryController.swift
//  HuChuangApp
//
//  Created by sw on 2021/1/7.
//  Copyright © 2021 sw. All rights reserved.
//

import UIKit

class HCVerificationQueryController: BaseViewController {
    
    private var infoModel: HCVerificationItemModel!
    
    private var container: HCVerificationQueryContainer!
    private var viewModel: HCVerificationQueryViewModel!
    
    override func setupUI() {
        navigationItem.title = "核销"
        
        container = HCVerificationQueryContainer.init(frame: view.bounds)
        view.addSubview(container)
    }
    
    override func rxBind() {
        container.infoModel = infoModel
        
        viewModel = HCVerificationQueryViewModel(infoModel: infoModel,
                                                 queryTap: container.queryButton.rx.tap.asDriver())

        viewModel.verificationSuccessSignal
            .bind(to: container.verificationSuccessSignal)
            .disposed(by: disposeBag)
        
        viewModel.popSubject
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popToRootViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    override func prepare(parameters: [String : Any]?) {
        infoModel = (parameters!["model"] as! HCVerificationItemModel)
    }
}
