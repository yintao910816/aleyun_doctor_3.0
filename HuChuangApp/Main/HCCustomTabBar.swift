//
//  HCCustomTabBar.swift
//  HuChuangApp
//
//  Created by yintao on 2020/10/22.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCCustomTabBar: UITabBar {

    private var barButton: UIButton!
    public var clickedCustomBarItem:(()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        barButton = UIButton(type: .custom)
        barButton.setImage(UIImage(named: "message"), for: .normal)
        barButton.imageView?.contentMode = .scaleAspectFill
        barButton.addTarget(self, action: #selector(clickedCustomBar), for: .touchUpInside)
        addSubview(barButton)
        bringSubviewToFront(barButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func clickedCustomBar(){
        clickedCustomBarItem?()
    }

    public var itemImage: UIImage? {
        didSet {
            barButton.setImage(itemImage, for: .normal)
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        if let itemSize = itemImage?.size {
            let x = (width - itemSize.width) / 2.0
            var y: CGFloat = 0

            if #available(iOS 11.0, *) {
                y = height - safeAreaInsets.bottom - itemSize.height
            } else {
                y = height - itemSize.height
            }

            barButton.frame = .init(x: x, y: y, width: itemSize.width, height: itemSize.height)
        }
    }
}

extension HCCustomTabBar {
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if isHidden {
            return super.hitTest(point, with: event)
        }else {
            let newPoint = convert(point, to: barButton)
            if barButton.point(inside: newPoint, with: event) {
                return barButton
            }else {
                return super.hitTest(point, with: event)
            }
        }
    }
}
