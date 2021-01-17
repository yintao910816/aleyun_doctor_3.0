//
//  HCHorizontalLayout.swift
//  HuChuangApp
//
//  Created by sw on 2021/1/17.
//  Copyright © 2021 sw. All rights reserved.
//

import Foundation

protocol HCLayoutDelegate: class {
    /// 单个cell的大小
    func itemSize(for indexPath: IndexPath, layout: UICollectionViewFlowLayout) ->CGSize
    /// header 大小
    func referenceSize(forHeader insSection: Int, layout: UICollectionViewFlowLayout) ->CGSize
    /// minimumLineSpacing
    func minimumLineSpacing(in section: Int, layout: UICollectionViewFlowLayout) ->CGFloat
    /// minimumInteritemSpacing
    func minimumInterSpacing(in section: Int, layout: UICollectionViewFlowLayout) ->CGFloat
    /// insetForSection
    func sectionInset(in section: Int, layout: UICollectionViewFlowLayout) ->UIEdgeInsets
}

class HCHorizontalLayout: UICollectionViewFlowLayout {
    
    private var lastFrame: CGRect = .zero
    private var attributeArray: [UICollectionViewLayoutAttributes] = []
    
    public weak var layoutDelegate: HCLayoutDelegate?

    override func prepare() {
        lastFrame = .zero
        attributeArray.removeAll()
        
        let totalWidth: CGFloat = collectionView?.width ?? 0
        let totalHeight: CGFloat = collectionView?.height ?? 0
        let sections: Int = collectionView?.numberOfSections ?? 0
        
        var startX: CGFloat = 0
        
        for section in 0..<sections {
            let edgeInsets: UIEdgeInsets = layoutDelegate?.sectionInset(in: section, layout: self) ?? .zero
            let interSpace: CGFloat = layoutDelegate?.minimumInterSpacing(in: section, layout: self) ?? 0
            let lineSpacing: CGFloat = layoutDelegate?.minimumLineSpacing(in: section, layout: self) ?? 0
            let headerSize: CGSize = layoutDelegate?.referenceSize(forHeader: section, layout: self) ?? .zero
            
            lastFrame = .init(x: edgeInsets.left, y: lastFrame.maxY + edgeInsets.top, width: totalWidth - edgeInsets.left - edgeInsets.right, height: headerSize.height)
            let headerAtt = UICollectionViewLayoutAttributes.init(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                                                  with: IndexPath.init(row: 0, section: section))
            headerAtt.frame = lastFrame
            
            attributeArray.append(headerAtt)
            
            let rows = collectionView?.numberOfItems(inSection: section) ?? 0
            for row in 0..<rows {
                let contentSize: CGSize = layoutDelegate?.itemSize(for: IndexPath.init(row: row, section: section), layout: self) ?? .zero
                var x: CGFloat = 0
                var y: CGFloat = 0
                if row == 0 {
                    // 第一个
                    x = startX + edgeInsets.left
                }else {
                    x = lastFrame.maxX + interSpace
                }
                
                if x - startX + contentSize.width + edgeInsets.right > totalWidth {
                    // 需要换行
                    x = startX + edgeInsets.left
                    y = lastFrame.maxY + lineSpacing
                }else {
                    // 不需要换行
                    y = lastFrame.origin.y
                }
                
                if y + contentSize.height + edgeInsets.bottom > totalHeight {
                    // 需要往下一页布局
                    startX += totalWidth
                    x = startX + edgeInsets.left
                    y = edgeInsets.top
                }
                
                let att = UICollectionViewLayoutAttributes.init(forCellWith: IndexPath.init(row: row, section: section))
                att.frame = .init(x: x, y: y, width: contentSize.width, height: contentSize.height)

                attributeArray.append(att)
                                
                lastFrame = att.frame
            }
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var resultArray: [UICollectionViewLayoutAttributes] = []
        for attributes in attributeArray {
            if rect.intersects(attributes.frame) {
                resultArray.append(attributes)
            }
        }
        
        return resultArray
    }
    
    override var collectionViewContentSize: CGSize {
        if let width = collectionView?.width {
            var page: Int = Int(lastFrame.maxX / width)
            page += lastFrame.maxX.truncatingRemainder(dividingBy: width) == 0 ? 0 : 1
            return .init(width: CGFloat(page) * width,  height: lastFrame.maxY)
        }
        return .zero
    }
}
