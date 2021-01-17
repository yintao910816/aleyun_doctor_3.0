//
//  HCBrowserTransitioning.swift
//  HuChuangApp
//
//  Created by sw on 2021/1/17.
//  Copyright © 2021 sw. All rights reserved.
//

import Foundation

open class HCBrowserTransitioning: NSObject, HCBrowserTransitioningDelegate {
    
    /// 弱引用 PhotoBrowser
    public weak var browser: HCBrowserViewController?
    
    public var maskAlpha: CGFloat {
        set {
            presentCtrl?.maskView.alpha = newValue
        }
        get {
            return presentCtrl?.maskView.alpha ?? 0
        }
    }
    
    /// present转场动画
    open var presentingAnimator: UIViewControllerAnimatedTransitioning?
    
    /// dismiss转场动画
    open var dismissingAnimator: UIViewControllerAnimatedTransitioning?
    
    private weak var presentCtrl: HCBrowserPresentationController?
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentingAnimator
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissingAnimator
    }
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let ctrl = HCBrowserPresentationController(presentedViewController: presented, presenting: presenting)
        presentCtrl = ctrl
        return ctrl
    }
}
