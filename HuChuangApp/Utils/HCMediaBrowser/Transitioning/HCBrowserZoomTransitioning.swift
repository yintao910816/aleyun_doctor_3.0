//
//  HCBrowserZoomTransitioning.swift
//  HuChuangApp
//
//  Created by sw on 2021/1/17.
//  Copyright © 2021 sw. All rights reserved.
//

import Foundation

public class HCBrowserZoomTransitioning: HCBrowserTransitioning {
    /// present转场时，内容缩张模式
    public var presentingZoomViewMode: () -> UIView.ContentMode = {
        return UIView.ContentMode.scaleAspectFill
    }
    
    /// dismiss转场时，内容缩张模式
    public var dismissingZoomViewMode: () -> UIView.ContentMode = {
        return UIView.ContentMode.scaleAspectFill
    }
    
    //
    // MARK: - 用户传入 ZoomView 的前置页面 Frame
    //
    
    public typealias FrameClosure = (
        _ browser: HCBrowserViewController,
        _ mid: Int64?,
        _ index: Int,
        _ transContainer: UIView) -> CGRect?
    
    /// 取前置视图的Frame
    public var originFrameCallback: FrameClosure
    
    /// 初始化，传入动画"起始/结束"的前置视图实际需求Frame
    /// 如果打开后是超出一屏的长图，请传入与长图一致宽高比的Frame
    public init(originFrameCallback: @escaping FrameClosure) {
        self.originFrameCallback = originFrameCallback
        super.init()
        setupPresenting()
        setupDismissing()
    }
    
    private func setupPresenting() {
        weak var `self` = self
        presentingAnimator = HCBrowserZoomPresentingAnimator(zoomView: { () -> UIView? in
            guard let `self` = self else {
                print("PTBrowserZoomTransitioning deinit")
                return nil
            }
            let view = self.browser?.transitionZoomView
            view?.contentMode = self.presentingZoomViewMode()
            view?.clipsToBounds = true
            return view
        }, startFrame: { view -> CGRect? in
            if let browser = self?.browser {
                return self?.originFrameCallback(browser, browser.currentMid, browser.pageIndexPath.row, view)
            }
            return nil
        }, endFrame: { view -> CGRect? in
            return self?.browser?.presentZoomEndRect ?? UIScreen.main.bounds
        })
    }
    
    private func setupDismissing() {
        weak var `self` = self
        dismissingAnimator = HCBrowserZoomDismissingAnimator(zoomView: { () -> UIView? in
            guard let `self` = self else {
                print("JXPhotoBrowserZoomTransitioning deinit")
                return nil
            }
            let view = self.browser?.transitionDismissZoomView
            view?.contentMode = self.dismissingZoomViewMode()
            view?.clipsToBounds = true
            return view
        }, startFrame: { view -> CGRect? in
            return self?.browser?.dismissZoomStartRect
        }, endFrame: { view -> CGRect? in
            if let browser = self?.browser {
                return self?.originFrameCallback(browser, browser.currentMid, browser.pageIndexPath.row, view)
            }
            return nil
        })
    }
}

///// 转场动画原资源。如转场之前的缩略图。
//public protocol HCBrowserZoomTransitioningOriginResource {
//
//    /// 资源视图
//    var originResourceView: UIView { get }
//
//    /// 图像实际需求宽高比例，width / height
//    var originResourceAspectRatio: CGFloat { get }
//}
//
///// 让UIImageView实现
//extension UIImageView: HCBrowserZoomTransitioningOriginResource {
//
//    public var originResourceView: UIView {
//        return self
//    }
//
//    public var originResourceAspectRatio: CGFloat {
//        if let image = image, image.size.height > 0 {
//            return image.size.width / image.size.height
//        }
//        if bounds.height > 0 {
//            return bounds.width / bounds.height
//        }
//        return 0
//    }
//
//
////    public var _originResourceView: UIView {
////        return self
////    }
////
////    public var _originResourceAspectRatio: CGFloat {
////        if let image = image, image.size.height > 0 {
////            return image.size.width / image.size.height
////        }
////        if bounds.height > 0 {
////            return bounds.width / bounds.height
////        }
////        return 0
////    }
//}
