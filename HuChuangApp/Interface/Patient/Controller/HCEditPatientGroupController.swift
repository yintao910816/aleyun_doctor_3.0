//
//  HCEditPatientGroupController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/11/18.
//  Copyright © 2020 sw. All rights reserved.
//  患者更换分组

import UIKit

class HCEditPatientGroupController: BaseViewController {

    private var memberId: String = ""
    private var viewModel: HCEditPatientGroupViewModel!
    
    private var container: HCEditPatientGroupContainer!

    override func setupUI() {
        navigationItem.title = "选择分组"
        
        container = HCEditPatientGroupContainer.init(frame: view.bounds)
        view.addSubview(container)
        
        container.contentView.cellDidSelected = { [unowned self] in self.viewModel.cellDidSelected.onNext(($0.title, $0.id)) }
        container.contentView.deleteCallBack = { [unowned self] in self.viewModel.deleteTagSubject.onNext($0.id) }
    }
    
    override func rxBind() {
        viewModel = HCEditPatientGroupViewModel(input: container.tagTf.rx.text.orEmpty.asDriver(),
                                                addTapDriver: container.addTagButton.rx.tap.asDriver(),
                                                memberId: memberId)
        
        viewModel.tagListSource.asDriver()
            .drive(onNext: { [weak self] in self?.container.contentView.datasource = $0 })
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        container.frame = view.bounds
    }

    override func prepare(parameters: [String : Any]?) {
        memberId = parameters!["memberId"] as! String
    }
}
