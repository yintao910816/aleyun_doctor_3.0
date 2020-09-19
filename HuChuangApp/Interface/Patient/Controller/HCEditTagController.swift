//
//  HCEditTagController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/9/19.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCEditTagController: BaseViewController {

    private var patientGroup: HCPatientGroupListModel!
    private var viewModel: HCEditTagViewModel!

    private var container: HCEditTagContainer!
    
    override func setupUI() {
        navigationItem.title = "编辑"
        
        container = HCEditTagContainer(frame: view.bounds)
        container.defaultContent = patientGroup.tagName
        view.addSubview(container)
    }
    
    override func rxBind() {
        viewModel = HCEditTagViewModel(patientGroup: patientGroup,
                                       textDriver: container.textTf.rx.text.orEmpty.asDriver(),
                                       commitDriver: container.saveButton.rx.tap.asDriver())
        
        viewModel.popSubject
            .subscribe(onNext: { [unowned self] in self.navigationController?.popViewController(animated: true) })
            .disposed(by: disposeBag)
        
        container.removeButton.rx.tap.asDriver()
            .drive(onNext: { [unowned self] in
                NoticesCenter.alert(title: "是否删除该组", message: "", cancleTitle: "取消", okTitle: "确定", presentCtrl: self) {
                    
                }
            })
            .disposed(by: disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        container.frame = view.bounds
    }
    
    override func prepare(parameters: [String : Any]?) {
        patientGroup = (parameters!["model"] as! HCPatientGroupListModel)
    }
}
