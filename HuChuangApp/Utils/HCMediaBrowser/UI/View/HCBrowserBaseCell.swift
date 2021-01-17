//
//  HCBrowserBaseCell.swift
//  HuChuangApp
//
//  Created by sw on 2021/1/17.
//  Copyright © 2021 sw. All rights reserved.
//

import UIKit

class HCBrowserBaseCell: UICollectionViewCell {
    
    var picWidth: CGFloat = 0.0
    var picHeight: CGFloat = 0.0
    
    /// 单击时回调
    open var clickCallback: ((UITapGestureRecognizer) -> Void)?
    
    /// 长按时回调
    open var longPressedCallback: (((Data?, String?, Int64)) -> Void)?
    
    /// 图片拖动时回调
    open var panChangedCallback: ((_ scale: CGFloat) -> Void)?
    
    /// 图片拖动松手回调。isDown: 是否向下
    open var panReleasedCallback: ((_ isDown: Bool) -> Void)?
    
    /// 是否需要添加长按手势。子类可重写本属性，返回`false`即可避免添加长按手势
    open var isNeededLongPressGesture: Bool {
        return true
    }
        
    //
    // MARK: - Life Cycle
    //
    
    /// 初始化
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 长按手势
        if isNeededLongPressGesture {
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress(_:)))
            contentView.addGestureRecognizer(longPress)
        }
                
        // 子类作进一步初始化
        didInit()
    }
    
    public var sourceModel: HCBaseBrowserModel! {
        didSet {
            
        }
    }
    
    /// 初始化完成时调用，空实现。子类可重写本方法以作进一步初始化
    open func didInit() {
        // 子类重写
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func longPressAction() { }

}

//
// MARK: - Events
//

extension HCBrowserBaseCell {
    /// 响应长按
    @objc private func onLongPress(_ press: UILongPressGestureRecognizer) {
        if press.state == .began {
            longPressAction()
        }
    }
}
