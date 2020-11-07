//
//  HCFastReplyController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/11/7.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCFastReplyController: BaseViewController {

    private var container: HCFastReplyContainer!
    private var viewModel: HCFastReplyViewModel!
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func setupUI() {
        hiddenNavBg = true
        view.backgroundColor = .clear
        
        container = HCFastReplyContainer.init(frame: view.bounds)
        container.sendActionCallBack = { _ in  }
        container.addActionCallBack = {  }
        container.dismissActionCallBack = { [weak self] in self?.dismiss(animated: true, completion: nil) }
        view.addSubview(container)
    }
    
    override func rxBind() {
        viewModel = HCFastReplyViewModel()
        
        viewModel.datasource.asDriver()
            .drive(onNext: { [weak self] in self?.container.datas = $0 })
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        container.frame = view.bounds
    }
}
