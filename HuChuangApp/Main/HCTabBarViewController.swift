//
//  HCTabBarViewController.swift
//  HuChuangApp
//
//  Created by sw on 02/02/2019.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit
import RxSwift

class HCTabBarViewController: UITabBarController {

    private var lastSelectedIndex: Int = NSNotFound
    
    private let disposeBag = DisposeBag()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        setupTabBar()
        
        NotificationCenter.default.rx.notification(NotificationName.UILogic.gotoClassRoom)
            .subscribe(onNext: { [weak self] data in
                self?.selectedIndex = 3
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(NotificationName.UserInterface.selectedHomeTabBar)
            .subscribe(onNext: { [weak self] data in
                self?.selectedIndex = 0
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(NotificationName.UILogic.gotoRecord)
            .subscribe(onNext: { [weak self] data in
                self?.selectedIndex = 2
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(NotificationName.UserInterface.consultList)
            .subscribe(onNext: { [weak self] data in
                self?.selectedIndex = 1
            })
            .disposed(by: disposeBag)
    }

    private func setupTabBar() {
        let homeCtrl = HCHomeViewController()
        let homeNav = MainNavigationController.init(rootViewController: homeCtrl)
        homeNav.tabBarItem.title = "首页"
        homeNav.tabBarItem.image = UIImage(named: "tabBar_home_unselected")
        homeNav.tabBarItem.selectedImage = UIImage(named: "tabBar_home_selected")
        homeNav.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : RGB(51, 51, 51)], for: .normal)
        homeNav.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : RGB(51, 51, 51)], for: .selected)

        let consultCtrl = HCConsultListController()
        let consultNav = MainNavigationController.init(rootViewController: consultCtrl)
        
        let patientCtrl = HCMyPatientController()
        let patientNav = MainNavigationController.init(rootViewController: patientCtrl)
        patientCtrl.title = "我的患者"
        patientNav.tabBarItem.title = "患者"
        patientNav.tabBarItem.image = UIImage(named: "patient_unselected")
        patientNav.tabBarItem.selectedImage = UIImage(named: "patient_selected")
        patientNav.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : RGB(51, 51, 51)], for: .normal)
        patientNav.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : RGB(51, 51, 51)], for: .selected)

        viewControllers = [homeNav, consultNav, patientNav]
        
        let customBar = HCCustomTabBar()
        customBar.itemImage = UIImage(named: "message")
        setValue(customBar, forKey: "tabBar")
        customBar.clickedCustomBarItem = { [unowned self] in
            if lastSelectedIndex != 1 {
                selectedIndex = 1
                lastSelectedIndex = 1
                HCHelper.requestUnreplyNum()
            }
        }
    }
}

extension HCTabBarViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if lastSelectedIndex != selectedIndex {
            HCHelper.requestUnreplyNum()
            lastSelectedIndex = selectedIndex
        }
    }
}
