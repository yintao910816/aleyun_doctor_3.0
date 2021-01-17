//
//  HCBrowserFlowlayout.swift
//  HuChuangApp
//
//  Created by sw on 2021/1/17.
//  Copyright © 2021 sw. All rights reserved.
//

import Foundation

class HCBrowserFlowlayout: UICollectionViewFlowLayout {
    
    private let screenSize: CGSize = UIScreen.main.bounds.size
    
    private var lastFrame: CGRect = .zero
    private var attributeArray    = [UICollectionViewLayoutAttributes]()

    private var contentOffset: CGPoint = .zero
    
    public weak var delegate: HCBrowserFlowlayoutDelegate?
    
    override func prepare() {
        super.prepare()
        attributeArray.removeAll()
        contentOffset = collectionView?.contentOffset ?? .zero

        let deviceOrientation = UIDevice.current.orientation
        // 竖屏
        var w = min(screenSize.width, screenSize.height)
        var h = max(screenSize.width, screenSize.height)

        if deviceOrientation == .landscapeLeft || deviceOrientation == .landscapeRight {
            // 横屏
            w = max(screenSize.width, screenSize.height)
            h = min(screenSize.width, screenSize.height)
        }
        guard let numberOfSections = collectionView?.numberOfSections else { return }
        
        lastFrame = .zero
        for section in 0..<numberOfSections
        {
            guard let rows = collectionView?.numberOfItems(inSection: section) else { return }
            for row in 0..<rows
            {
                if lastFrame == .zero
                {
                    lastFrame = .init(x: sectionInset.left, y: sectionInset.top, width: w, height: h)
                }else
                {
                    lastFrame.origin.x += (minimumLineSpacing + w)
                }
                let indexPath = IndexPath.init(row: row, section: section)
                let attribute = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
                attribute.frame = lastFrame
                attributeArray.append(attribute)
            }
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributeArray.filter{ $0.frame.intersects(rect) }
    }
    
    override var collectionViewContentSize: CGSize {
        if let lastItemFrame = attributeArray.last?.frame
        {
            return .init(width: lastItemFrame.maxX + sectionInset.bottom, height: lastFrame.size.height)
        }

        return .zero
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        guard let curIndexPath = delegate?.currentIndexPath,
            let attr = attributeArray.first(where: { $0.indexPath == curIndexPath }) else {
                return proposedContentOffset
        }
        
        return attr.frame.origin
    }
}

protocol HCBrowserFlowlayoutDelegate: class {
    
    var currentIndexPath: IndexPath? { get }
}
