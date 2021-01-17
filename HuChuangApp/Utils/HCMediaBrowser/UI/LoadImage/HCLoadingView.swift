//
//  HCLoadingView.swift
//  HuChuangApp
//
//  Created by sw on 2021/1/17.
//  Copyright © 2021 sw. All rights reserved.
//

import Foundation

class HCLoadingView: UIView, CAAnimationDelegate {
    
    private var duration: CGFloat = 2
    private var index: Int = 0
    private var realFinish: Bool = true

    private var loadingLayer: CAShapeLayer?
    
    private var strokeStartAnimation: CABasicAnimation!
    private var strokeEndAnimation: CABasicAnimation!
    private var strokeAniamtionGroup: CAAnimationGroup?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        loadingLayer = CAShapeLayer()
        loadingLayer?.lineWidth = 2.0
        loadingLayer?.fillColor = UIColor.clear.cgColor;
        loadingLayer?.strokeColor = UIColor.white.cgColor;
        loadingLayer?.lineCap = CAShapeLayerLineCap.round;

        layer.addSublayer(loadingLayer!)

        strokeStartAnimation = CABasicAnimation.init(keyPath: "strokeStart")
        strokeStartAnimation.fromValue = 0
        strokeStartAnimation.toValue = 1
        strokeStartAnimation.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut)

        
        strokeEndAnimation = CABasicAnimation.init(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = 0
        strokeEndAnimation.toValue = 1
        strokeEndAnimation.duration = CFTimeInterval(0.5 * self.duration)

        
        strokeAniamtionGroup = CAAnimationGroup()
        strokeAniamtionGroup?.duration = CFTimeInterval(self.duration);
        strokeAniamtionGroup?.delegate = self;
//            strokeAniamtionGroup?.repeatCount = MAXFLOAT
        strokeAniamtionGroup?.isRemovedOnCompletion = false;
        strokeAniamtionGroup?.fillMode = CAMediaTimingFillMode.forwards;
        
        strokeAniamtionGroup?.animations = [strokeEndAnimation, strokeStartAnimation]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("释放了：\(self)")
    }
    
    private func loadingAnimation() {
        guard let _group = strokeAniamtionGroup else {
            return
        }

        self.loadingLayer?.path = self.cycleBezierPathIndex().cgPath
        self.loadingLayer?.add(_group, forKey: "strokeAniamtionGroup")
    }

    private func cycleBezierPathIndex() -> UIBezierPath {
        if index > 3 { index = 1 }
        let startAngle = CGFloat(Double(index) * (.pi * 2)/3)
        let endAngle   = CGFloat(Double(index) * (.pi * 2)/3 + (.pi * 2) * 4/3)
        let path = UIBezierPath.init(arcCenter: CGPoint.init(x: self.bounds.size.width * 0.5,
                                                             y: self.bounds.size.height * 0.5),
                                     radius: self.bounds.size.width * 0.5,
                                     startAngle: startAngle,
                                     endAngle: endAngle,
                                     clockwise: true)
        return path
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if realFinish == true {
            destroyAnimation()
            return
        }
                
        if anim == loadingLayer?.animation(forKey: "strokeAniamtionGroup") {
            index += 1
            loadingAnimation()
        }
    }
    
    func starAnimation() {
        isHidden = false
        realFinish = false
        loadingAnimation()
    }
    
    func stopAnimation() {
        // 防止循环引用
        layer.removeAllAnimations()
        loadingLayer?.removeAllAnimations()
        
        index = 0
        realFinish = true
        isHidden = true
    }
    
    func destroyAnimation() {
        stopAnimation()
    }
    
}
