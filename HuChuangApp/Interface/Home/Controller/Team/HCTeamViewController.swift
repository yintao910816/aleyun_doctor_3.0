//
//  HCTeamViewController.swift
//  HuChuangApp
//
//  Created by sw on 2021/2/4.
//  Copyright © 2021 sw. All rights reserved.
//

import UIKit

class HCTeamViewController: BaseViewController {

    private var viewModel: HCTeamViewModel!
    
    private var slideCtrl: TYSlideMenuController!
    private var myteamCtrl: HCMyTeamViewController!
    private var teamContainMeCtrl: HCTeamContainMeController!

    override func setupUI() {
        navigationItem.title = "我的团队"
        
        slideCtrl = TYSlideMenuController()
        slideCtrl.isPagingEnabled = false
        addChild(slideCtrl)
        view.addSubview(slideCtrl.view)

        myteamCtrl = HCMyTeamViewController()
        myteamCtrl.addMemberClicked = { [unowned self] in
            navigationController?.pushViewController(HCAddTeamMemberController(), animated: true)
        }
        
        teamContainMeCtrl = HCTeamContainMeController()
        
        slideCtrl.menuItems = TYSlideItemModel.createTeamData()
        slideCtrl.menuCtrls = [myteamCtrl, teamContainMeCtrl]
    }
    
    override func rxBind() {
        viewModel = HCTeamViewModel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
    }
}
