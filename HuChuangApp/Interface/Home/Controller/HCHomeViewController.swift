//
//  HCHomeViewController.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/8.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCHomeViewController: BaseViewController {

    private var containerView: HCHomeViewContainer!
    private var viewModel: HCHomeViewModel!
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func setupUI() {
        setContentInsetAdjustmentBehaviorNever()
        
        containerView = HCHomeViewContainer.init(frame: .init(x: 0, y: 0, width: view.width, height: view.height))
        view.addSubview(containerView)
        
        containerView.menuChanged = { [weak self] in self?.viewModel.articleTypeChangeSignal.onNext($0) }
//        containerView.articleClicked = { [weak self] in
//            PrintLog("点击：\($0.title)")
////            let webVC = BaseWebViewController()
////            webVC.url = $0.picPath
////            self?.navigationController?.pushViewController(webVC, animated: true)
//        }
        
        containerView.funcItemClicked = { [weak self] in
            if $0.name == "排班设置" {
                self?.navigationController?.pushViewController(HCServerSettingController(),
                                                               animated: true)
            }else {
                let webVC = BaseWebViewController()
                webVC.url = $0.functionUrl
                webVC.title = $0.name
                self?.navigationController?.pushViewController(webVC, animated: true)
            }
        }
        
        containerView.buttonClicked = { [weak self] in
            switch $0 {
            case .qrCode:
                break
            case .message:
                break
            case .setting:
                break;
            case .newOrder:
                NotificationCenter.default.post(name: NotificationName.UserInterface.consultList, object: nil)
            }
        }

    }
    
    override func rxBind() {
        viewModel = HCHomeViewModel()
        
        viewModel.functionsMenuSignal
            .subscribe(onNext: { [weak self] in self?.containerView.reloadData(menuItems: $0.0, bannerItems: $0.2, page: $0.3, userInfo: $0.4, userServerStatistics: $0.5) })
            .disposed(by: disposeBag)
        
//        viewModel.articleDataSignal
//            .subscribe(onNext: { [weak self] in self?.containerView.reloadArticleDatas(datas: $0.0, page: $0.1) })
//            .disposed(by: disposeBag)
                
        viewModel.reloadSubject.onNext(Void())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        containerView.frame = view.bounds
    }
}
