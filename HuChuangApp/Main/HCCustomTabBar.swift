//
//  HCCustomTabBar.swift
//  HuChuangApp
//
//  Created by yintao on 2020/10/22.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

import RxSwift

class HCCustomTabBar: UITabBar {

    private let disposeBag = DisposeBag()

    private var barButton: UIButton!
    private var countLabel: UILabel!
    
    public var clickedCustomBarItem:(()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        barButton = UIButton(type: .custom)
        barButton.setImage(UIImage(named: "message"), for: .normal)
        barButton.imageView?.contentMode = .scaleAspectFill
        barButton.addTarget(self, action: #selector(clickedCustomBar), for: .touchUpInside)
        addSubview(barButton)
        bringSubviewToFront(barButton)
        
        countLabel = UILabel()
        countLabel.text = "0"
        countLabel.font = .font(fontSize: 21, fontName: .PingFSemibold)
        countLabel.textAlignment = .center
        countLabel.backgroundColor = .clear
        countLabel.textColor = .white
        countLabel.adjustsFontSizeToFitWidth = true
        barButton.addSubview(countLabel)
        
        NotificationCenter.default.rx.notification(NotificationName.Message.unreadMessageCount, object: nil)
            .subscribe(onNext: { [weak self] in
                if let count = $0.object as? Int {
                    self?.countLabel.text = "\(count)"
                }
            })
            .disposed(by: disposeBag)
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
        
        countLabel.frame = .init(x: (barButton.width - 30) / 2, y: (barButton.height - 21) / 2, width: 30, height: 21)
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
