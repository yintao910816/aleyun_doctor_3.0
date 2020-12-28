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
    
    public var sendActionCallBack:((HCFastReplyModel)->())?

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func setupUI() {
        hiddenNavBg = true
        view.backgroundColor = .clear
        
        container = HCFastReplyContainer.init(frame: view.bounds)
        container.sendActionCallBack = { [unowned self] in sendActionCallBack?($0) }
        container.addActionCallBack = { [unowned self] in presentFastReplyEditCtrl() }
        container.editCallBack = { [unowned self] in presentFastReplyEditCtrl(replyModel: $0) }
        container.dismissActionCallBack = { [weak self] in self?.dismiss(animated: true, completion: nil) }
        container.moveTopActionCallBack = { [weak self] in self?.viewModel.moveTopSignal.onNext($0) }
        container.delActionCallBack = { [weak self] in self?.viewModel.removeSignal.onNext($0) }

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
    
    private func presentFastReplyEditCtrl(replyModel: HCFastReplyModel? = nil) {
        let rootVC = HCEditFastReplyController()
        let presentCtrl = MainNavigationController.init(rootViewController: rootVC)
        presentCtrl.view.backgroundColor = .clear
        if let m = replyModel {
            rootVC.prepare(parameters: ["model": m])
        }
        model(for: presentCtrl, controllerHeight: view.size.height)
    }
}
