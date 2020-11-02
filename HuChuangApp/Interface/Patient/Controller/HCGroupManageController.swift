//
//  HCGroupManageController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/9/18.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCGroupManageController: BaseViewController, VMNavigation {

    private var viewModel: HCGroupManageViewModel!
    private var groupDatas: [HCPatientGroupListModel] = []
    
    private var container: HCGroupManageContainer!
    
    override func setupUI() {
        navigationItem.title = "分组管理"
        
        container = HCGroupManageContainer.init(frame: view.bounds)
        container.didSelectedCallBack = { [unowned self] in
            HCPatientGroupController.push(HCEditTagController.self, ["model": self.groupDatas[$0]])
        }
        view.addSubview(container)
    }
    
    override func rxBind() {
        addBarItem(title: "新增", titleColor: RGB(12, 12, 12))
            .drive(onNext: { [unowned self] in
                PrintLog("新增")
            })
            .disposed(by: disposeBag)
        
        viewModel = HCGroupManageViewModel.init(groupPatientDatas: groupDatas)
        
        viewModel.listSignal
            .subscribe(onNext: { [weak self] in
                self?.container.listDatas = $0
            })
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
    }
    
    override func prepare(parameters: [String : Any]?) {
        groupDatas = parameters!["data"] as! [HCPatientGroupListModel]
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        container.frame = view.bounds
    }
}