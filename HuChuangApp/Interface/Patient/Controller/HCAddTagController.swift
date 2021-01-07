//
//  HCAddTagController.swift
//  HuChuangApp
//
//  Created by sw on 2021/1/7.
//  Copyright © 2021 sw. All rights reserved.
//

import UIKit

class HCAddTagController: BaseViewController {
    
    private var viewModel: HCAddTagViewModel!

    private var container: HCAddTagContainer!
    
    override func setupUI() {
        navigationItem.title = "添加分组"
        
        container = HCAddTagContainer(frame: view.bounds)
        view.addSubview(container)
    }
    
    override func rxBind() {
        viewModel = HCAddTagViewModel(textDriver: container.textTf.rx.text.orEmpty.asDriver(),
                                       commitDriver: container.saveButton.rx.tap.asDriver())
        
        viewModel.popSubject
            .subscribe(onNext: { [unowned self] in self.navigationController?.popViewController(animated: true) })
            .disposed(by: disposeBag)        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        container.frame = view.bounds
    }    
}
