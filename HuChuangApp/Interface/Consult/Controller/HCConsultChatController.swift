//
//  HCConsultDetailController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/10/19.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCConsultChatController: HCSlideItemController {
    
    private var container: HCConsultChatContainer!
    
    private var memberId: String = ""
    private var consultId: String = ""

    private var viewModel: HCConsultChatViewModel!

    override func setupUI() {        
        container = HCConsultChatContainer.init(frame: view.bounds)
        view.addSubview(container)

    }
    
    override func rxBind() {
        viewModel = HCConsultChatViewModel(memberId: memberId, consultId: consultId)
        
        viewModel.datasource.asDriver()
            .drive(container.dataSignal)
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
//        container.tableView.prepare(viewModel, showFooter: false, showHeader: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        container.frame = view.bounds
    }
    
    override func prepare(parameters: [String : Any]?) {
        memberId = parameters!["memberId"] as! String
        consultId = parameters!["consultId"] as! String
    }
}
