//
//  HCBrowserPhotoCell.swift
//  HuChuangApp
//
//  Created by sw on 2021/1/17.
//  Copyright © 2021 sw. All rights reserved.
//

import UIKit

class HCBrowserPhotoCell: HCBrowserBaseCell {
    
    /// ImageView
    var imageView = UIImageView.init(frame: .init(x: 0, y: 0, width: 100, height: 100))
    
    /// 图片缩放容器
    open var imageContainer = UIScrollView()
    
    /// 图片允许的最大放大倍率
    open var imageMaximumZoomScale: CGFloat = 2.0
    
    /// 记录pan手势开始时imageView的位置
    private var beganFrame = CGRect.zero
    
    /// 记录pan手势开始时，手势位置
    private var beganTouch = CGPoint.zero
        
    deinit {
        print("deinit --- \(self)")
//        imageView.loadingRequestDispose()
    }
    
    override var sourceModel: HCBaseBrowserModel! {
        didSet {
            if let photoModel = sourceModel as? HCPhotoBrowserModel {
                picWidth = photoModel.picwidth
                picHeight = photoModel.picHeight
                if photoModel.image == nil {
                    imageView.setImage(photoModel.picPath)
                }else {
                    imageView.image = photoModel.image
                }
                
                reloadFrame(maxSize: UIScreen.main.bounds.size)
            }
        }
    }
            
    override func longPressAction() {
//        longPressedCallback?((photoData, nil, mid))
    }
    
    override func didInit() {
        contentView.addSubview(imageContainer)
        imageContainer.maximumZoomScale = imageMaximumZoomScale
        imageContainer.delegate = self
        imageContainer.showsVerticalScrollIndicator = false
        imageContainer.showsHorizontalScrollIndicator = false
        if #available(iOS 11.0, *) {
            imageContainer.contentInsetAdjustmentBehavior = .never
        }
        
        imageContainer.addSubview(imageView)
        imageView.clipsToBounds = true
        imageView.contentMode   = .scaleAspectFill
        
        // 双击手势
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(onDoubleClick(_:)))
        doubleTap.numberOfTapsRequired = 2
        contentView.addGestureRecognizer(doubleTap)
        
        // 单击手势
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(onClick(_:)))
        contentView.addGestureRecognizer(singleTap)
        singleTap.require(toFail: doubleTap)
        
        // 拖动手势
        let pan = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        pan.delegate = self
        // 必须加在图片容器上。不能加在contentView上，否则长图下拉不能触发
        imageContainer.addGestureRecognizer(pan)
        
        imageContainer.setZoomScale(1.0, animated: false)
        imageContainer.snp.makeConstraints{ $0.edges.equalTo(UIEdgeInsets.zero) }
    }
}

//
// MARK: - UIScrollViewDelegate
//
extension HCBrowserPhotoCell: UIScrollViewDelegate {
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        let offsetX: CGFloat = (scrollView.bounds.size.width > scrollView.contentSize.width) ? (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
        let offsetY: CGFloat = (scrollView.bounds.size.height > scrollView.contentSize.height) ? (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
        imageView.center = .init(x: scrollView.contentSize.width * 0.5 + offsetX,
                                 y: scrollView.contentSize.height * 0.5 + offsetY)

    }
}


extension HCBrowserPhotoCell {
    
    public func reloadFrame(maxSize: CGSize) {
        DispatchQueue.main.async {
            let imageSize = CGSize.init(width: self.picWidth, height: self.picHeight)
            let frame: CGRect = HCBrowserImageScaleHelper.calculateImage(imageSize: imageSize,
                                                                         maxSize: maxSize,
                                                                         offset: true)

            let widthZoomScale: CGFloat = imageSize.width / frame.size.width
            let heightZoomScale: CGFloat = imageSize.height / frame.size.height
            let maximumZoomScale: CGFloat = max(2, min(widthZoomScale, heightZoomScale))
            if (self.imageContainer.maximumZoomScale != maximumZoomScale) {
                self.imageContainer.maximumZoomScale = maximumZoomScale
            }
            if (self.imageContainer.zoomScale != 1.0) {
                self.imageContainer.zoomScale = 1.0
            }
            
            if (!self.imageContainer.contentSize.equalTo(frame.size)) {
                self.imageContainer.contentSize = frame.size
            }
            if (!self.imageView.frame.equalTo(frame)) {
                self.imageView.frame = frame
                print("图片设置frame：\(self.imageView.frame)")
            }
            if (!self.imageContainer.frame.equalTo(self.bounds)) {
                self.imageContainer.frame = self.bounds
            }
//            if (frame.size.height > self.imageContainer.frame.size.height) {
//                self.imageContainer.setContentOffset(.init(x: 0,
//                                                           y: (frame.size.height - self.imageContainer.frame.size.height) * 0.5),
//                                                     animated: false)
//            }
//            if (frame.size.width > self.imageContainer.frame.size.width) {
//                self.imageContainer.setContentOffset(.init(x: (frame.size.width - self.imageContainer.frame.size.width) * 0.5,
//                                                           y: 0),
//                                                     animated: false)
//            }
        }
    }
    
    func remakeImageVCns() {
        imageContainer.setZoomScale(1.0, animated: false)
        imageContainer.contentOffset = .zero
        
        if picWidth <= 0 || picHeight <= 0 {
            imageView.snp.remakeConstraints { make in
                make.left.equalTo(imageContainer.snp.left)
                make.width.equalTo(imageContainer.snp.width)
                make.top.equalTo(imageContainer.snp.top)
                make.height.equalTo(imageContainer.snp.height)
            }
            return
        }

        let deviceOrientation = UIApplication.shared.statusBarOrientation

        if deviceOrientation == .landscapeLeft || deviceOrientation == .landscapeRight {
            // 横屏
            let vH = min(contentView.bounds.height, contentView.bounds.width)
            let vW = max(contentView.bounds.width, contentView.bounds.height)
            if picWidth == 0 { picWidth = vW }
            if picHeight == 0 { picHeight = vH }

            let imgVW = vH * picWidth/picHeight
            let leftCns: CGFloat = imgVW > vW ? 0 : (vW - imgVW)/2.0
            imageView.snp.remakeConstraints { make in
                make.left.equalTo(imageContainer.snp.left).offset(leftCns)
                make.width.equalTo(imgVW)
                make.top.equalTo(imageContainer.snp.top)
                make.height.equalTo(vH)
            }
            imageContainer.contentSize = imgVW > vW ? .init(width: imgVW, height: vH) : .init(width: vW, height: vH)
        } else {
            // 竖屏
            let vH = max(contentView.bounds.height, contentView.bounds.width)
            let vW = min(contentView.bounds.width, contentView.bounds.height)
            if picWidth == 0 { picWidth = vW }
            if picHeight == 0 { picHeight = vH }

            let imgVH = vW * picHeight/picWidth
            let topCns: CGFloat = imgVH > vH ? 0 : (vH - imgVH)/2.0
            imageView.snp.remakeConstraints { make in
                make.left.equalTo(imageContainer.snp.left)
                make.width.equalTo(vW)
                make.top.equalTo(imageContainer.snp.top).offset(topCns)
                make.height.equalTo(imgVH)
            }
            imageContainer.contentSize = imgVH > vH ? .init(width: vW, height: imgVH) : .init(width: vW, height: vH)
        }
        
        imageContainer.setNeedsLayout()
        imageContainer.layoutIfNeeded()
    }
    
    /// 复位ImageView
    private func resetImageView() {
//        imageContainer.setZoomScale(1.0, animated: false)
//        imageContainer.contentOffset = .zero
        
        let imageSize = CGSize.init(width: self.picWidth, height: self.picHeight)
        let frame = HCBrowserImageScaleHelper.calculateImage(imageSize: imageSize, maxSize: UIScreen.main.bounds.size, offset: true)
        UIView.animate(withDuration: 0.25) {
            self.imageView.frame = frame;
        }
    }
}

extension HCBrowserPhotoCell {
    
    /// 响应拖动
    @objc private func onPan(_ pan: UIPanGestureRecognizer) {
        guard imageView.image != nil else {
            return
        }
        switch pan.state {
        case .began:
            beganFrame = imageView.frame
            beganTouch = pan.location(in: imageContainer)
        case .changed:
            let result = panResult(pan)
            imageView.frame = result.0
            panChangedCallback?(result.1)
        case .ended, .cancelled:
            imageView.frame = panResult(pan).0
            let isDown = pan.velocity(in: imageContainer).y > 0
            self.panReleasedCallback?(isDown)
            if !isDown {
                resetImageView()
            }
        default:
            resetImageView()
        }
    }
    
    /// 计算拖动时图片应调整的frame和scale值
    private func panResult(_ pan: UIPanGestureRecognizer) -> (CGRect, CGFloat) {
        // 拖动偏移量
        let translation = pan.translation(in: imageContainer)
        let currentTouch = pan.location(in: imageContainer)
        
        // 由下拉的偏移值决定缩放比例，越往下偏移，缩得越小。scale值区间[0.3, 1.0]
        let scale = min(1.0, max(0.3, 1 - translation.y / bounds.height))
        
        let width = beganFrame.size.width * scale
        let height = beganFrame.size.height * scale
        
        // 计算x和y。保持手指在图片上的相对位置不变。
        // 即如果手势开始时，手指在图片X轴三分之一处，那么在移动图片时，保持手指始终位于图片X轴的三分之一处
        let xRate = (beganTouch.x - beganFrame.origin.x) / beganFrame.size.width
        let currentTouchDeltaX = xRate * width
        let x = currentTouch.x - currentTouchDeltaX
        
        let yRate = (beganTouch.y - beganFrame.origin.y) / beganFrame.size.height
        let currentTouchDeltaY = yRate * height
        let y = currentTouch.y - currentTouchDeltaY
        
        let resultRect = CGRect(x: x.isNaN ? 0 : x, y: y.isNaN ? 0 : y, width: width, height: height);
        
        return (resultRect, scale)
    }
    
    /// 响应单击
    @objc private func onClick(_ tap: UITapGestureRecognizer) {
        clickCallback?(tap)
    }
    
    /// 响应双击
    @objc private func onDoubleClick(_ tap: UITapGestureRecognizer) {
        // 如果当前没有任何缩放，则放大到目标比例，否则重置到原比例
        if imageContainer.zoomScale == 1.0 {
            // 以点击的位置为中心，放大
            let pointInView = tap.location(in: imageView)
            let width = imageContainer.bounds.size.width / imageContainer.maximumZoomScale
            let height = imageContainer.bounds.size.height / imageContainer.maximumZoomScale
            let x = pointInView.x - (width / 2.0)
            let y = pointInView.y - (height / 2.0)
            imageContainer.zoom(to: CGRect(x: x, y: y, width: width, height: height), animated: true)
        } else {
            imageContainer.setZoomScale(1.0, animated: true)
        }
    }
    
}

//
// MARK: - UIGestureRecognizerDelegate
//

extension HCBrowserPhotoCell: UIGestureRecognizerDelegate {
    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // 只响应pan手势
        guard let pan = gestureRecognizer as? UIPanGestureRecognizer else {
            return true
        }
        let velocity = pan.velocity(in: self)
        // 向上滑动时，不响应手势
        if velocity.y < 0 {
            return false
        }
        // 横向滑动时，不响应pan手势
        if abs(Int(velocity.x)) > Int(velocity.y) {
            return false
        }
        // 向下滑动，如果图片顶部超出可视区域，不响应手势
        if imageContainer.contentOffset.y > 0 {
            return false
        }
        // 响应允许范围内的下滑手势
        return true
    }
}
