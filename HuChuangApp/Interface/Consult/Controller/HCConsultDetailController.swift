//
//  HCPatientDetailController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/5/15.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCConsultDetailController: BaseViewController {

    private var viewModel: HCPatientDetailViewModel!
    
    private var slideCtrl: TYSlideMenuController!
    private let consultChatCtrl = HCConsultChatController()
    private let healthArchivesCtrl = HCPatientHealthArchivesController()
    private let manageCtrl = HCPatientManageController()

    private var memberId: String = ""
    private var consultId: String = ""

    private var navTitle: String?

    deinit {
        if consultChatCtrl.viewModel != nil {
            consultChatCtrl.viewModel.customDeinit()
            consultChatCtrl.viewModel = nil
            consultChatCtrl.removeFromParent()
            
            slideCtrl.removeFromParent()
        }
    }
    
    override func setupUI() {
        slideCtrl = TYSlideMenuController()
        addChild(slideCtrl)
        view.addSubview(slideCtrl.view)
        
        slideCtrl.pageScroll = { [weak self] page in
            
        }

        healthArchivesCtrl.expandChangeCallBack = { [weak self] in
            self?.viewModel.healthArchivesExpand.onNext($0)
        }
        
        slideCtrl.menuItems = TYSlideItemModel.creatModel(for: ["咨询记录", "健康档案", "患者管理"])
        consultChatCtrl.prepare(parameters: ["memberId":memberId, "consultId":consultId])
        manageCtrl.prepare(parameters: ["memberId": memberId, "consultId": consultId])
        slideCtrl.menuCtrls = [consultChatCtrl,
                               healthArchivesCtrl,
                               manageCtrl]
        
        consultChatCtrl.imageClicked = { [unowned self] in presentBrowser(data: $0) }
    }
    
    override func rxBind() {
        viewModel = HCPatientDetailViewModel(memberId: memberId)
        
        viewModel.consultRecordData.asDriver()
            .drive(onNext: { [weak self] in
                self?.consultChatCtrl.reloadData(data: $0)
            })
            .disposed(by: disposeBag)
        
        viewModel.manageData.asDriver()
            .drive(onNext: { [weak self] in
                self?.manageCtrl.reloadData(data: $0)
            })
            .disposed(by: disposeBag)
        
        viewModel.healthArchivesData.asDriver()
            .drive(onNext: { [weak self] in
                self?.healthArchivesCtrl.reloadData(data: $0)
            })
            .disposed(by: disposeBag)
                
        consultChatCtrl.viewModel.navTitleSignal
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
    }
    
    override func prepare(parameters: [String : Any]?) {
        memberId = (parameters!["memberId"] as! String)
        consultId = (parameters!["consultId"] as! String)
    }
}

extension HCConsultDetailController {
    
    private func presentBrowser(data: (UIImage?, String)) {
        let sectionData = HCMediaSectionModel()
        let item = HCPhotoBrowserModel()
        item.image = data.0
        item.picPath = data.1
        item.picwidth = data.0?.size.width ?? view.width
        item.picHeight = data.0?.size.width ?? view.height
        sectionData.items = [item]
        
        let browserTrans = HCBrowserZoomTransitioning.init {[weak self] (browser, mid, index, view) -> CGRect? in
            return nil
        }
        
        let mediaBrowser = HCBrowserViewController(nibName: nil, bundle: nil)
        mediaBrowser.transDelegate = browserTrans

        mediaBrowser.configData(datasource: [sectionData], pageIndexPath: IndexPath(row: 0, section: 0))

        // 转场
        mediaBrowser.zoomFileData = item

        mediaBrowser.presentZoomRect = nil

        present(mediaBrowser, animated: true, completion: nil)

    }
}
