//
//  AppDelegate.swift
//  HuChuangApp
//
//  Created by sw on 02/02/2019.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit
import StoreKit
import RxSwift
import HandyJSON
import IQKeyboardManagerSwift

@UIApplicationMain
class HCAppDelegate: UIResponder, UIApplicationDelegate {

     var window: UIWindow?

    public var deviceToken: String = ""
    
    public var isAuthorizedPush: Bool = false
    
    public var allowRotation: Bool = false
    
    public var disposeBag = DisposeBag()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        setupTRTC()
        setupUM(launchOptions: launchOptions)
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        window?.rootViewController = HCTabBarViewController()
        
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
                
        setupAppLogic()
        return true
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if allowRotation {
            return .landscapeLeft
        }else {
            return .portrait
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        HCHelper.requestUnreplyNum()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

}
