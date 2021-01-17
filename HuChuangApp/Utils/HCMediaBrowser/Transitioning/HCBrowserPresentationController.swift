//
//  HCBrowserPresentationController.swift
//  HuChuangApp
//
//  Created by sw on 2021/1/17.
//  Copyright © 2021 sw. All rights reserved.
//

import Foundation

/// 转场协调器，主要处理转场蒙板
class HCBrowserPresentationController: UIPresentationController {
    
    /// 蒙板
    var maskView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        return view
    }()
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        guard let containerView = self.containerView else { return }
        
        containerView.addSubview(maskView)
        maskView.frame = containerView.bounds
        maskView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        maskView.alpha = 0
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.maskView.alpha = 1
        }, completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.maskView.alpha = 0
        })
    }
}
