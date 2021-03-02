//
//  HCHomeViewController.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/8.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCHomeViewController: BaseViewController, VMNavigation {

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
        
        containerView.funcItemClicked = { [unowned self] in
            if $0.primordial == 1 {
                if $0.name == "设置" {
                    navigationController?.pushViewController(HCSettingViewController(), animated: true)
                }else if $0.name == "服务设置" {
                    navigationController?.pushViewController(HCServerSettingController(), animated: true)
                }else if $0.name == "扫码核销" {
                    navigationController?.pushViewController(HCVerificationController(), animated: true)
                }else if $0.name == "我的团队" {
//                    navigationController?.pushViewController(HCTeamViewController(), animated: true)
                }
            }else {
                var url = $0.functionUrl
                var title = $0.name
                if $0.name == "返回旧版" {
                    url = "\($0.functionUrl)?doctorId=\(HCHelper.share.userInfoModel?.uid ?? "")"
                    title = "旧版咨询"
                }
                HCHomeViewController.push(BaseWebViewController.self, ["url": url, "title": title])
            }
        }
        
        containerView.buttonClicked = { [unowned self] in
            switch $0 {
            case .qrCode:
                HCHomeViewController.push(BaseWebViewController.self, ["url": APIAssistance.doctorCardLink, "title": "我的名片"])
            case .message:
                navigationController?.pushViewController(HCMessageViewController(), animated: true)
            case .setting:
                navigationController?.pushViewController(HCAccountSettingViewController(), animated: true)
            case .newOrder:
                NotificationCenter.default.post(name: NotificationName.UserInterface.consultList, object: nil)
            }
        }

    }
    
    override func rxBind() {
        viewModel = HCHomeViewModel()
        
        viewModel.functionsMenuSignal.asObservable()
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
