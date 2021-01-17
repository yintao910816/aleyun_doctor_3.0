//
//  HCFuncMenuCel.swift
//  HuChuangApp
//
//  Created by yintao on 2020/9/2.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCFuncMenuCell_identifier: String = "HCFuncMenuCell"

private let lineSpacing: CGFloat = 24
private let inset: UIEdgeInsets = .init(top: 10, left: 25, bottom: 15, right: 25)
private let itemHeight: CGFloat = 55
private let iconSize: CGSize = .init(width: 28, height: 28)
private let titleHeight: CGFloat = 17
private let titleTop: CGFloat = 10

class HCFuncMenuCell: UICollectionViewCell {
    
    private var funcCollectionView: UICollectionView!

    private var itemSizeW: CGFloat = 0
    private var minimumInteritemSpacing: CGFloat = 0
    
    public var itemClicked: ((HCFunctionsMenuModel)->())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let layout = HCHorizontalLayout()
        layout.layoutDelegate = self
        layout.scrollDirection = .horizontal
        
        funcCollectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        funcCollectionView.backgroundColor = .white
        funcCollectionView.isPagingEnabled = true
        funcCollectionView.showsVerticalScrollIndicator = false
        funcCollectionView.showsHorizontalScrollIndicator = false
        funcCollectionView.delegate = self
        funcCollectionView.dataSource = self
        addSubview(funcCollectionView)
        
        funcCollectionView.register(HCFuncMenuItemCell.self, forCellWithReuseIdentifier: HCFuncMenuItemCell_identifer)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public var funcMenuModels: [HCFunctionsMenuModel] = [] {
        didSet {
            caculteItemData()
            funcCollectionView.reloadData()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        funcCollectionView.frame = bounds
    }
    

    public class func cellHeight(itemCount: Int) ->CGFloat {
        let lines: Int = itemCount > 4 ? 2 : 1
        
        var height = CGFloat(lines) * itemHeight + inset.top + inset.bottom
        height += lines == 2 ? lineSpacing : 0
        return height
    }
    
    private func caculteItemData() {
        var textMaxW: CGFloat = 0
        
        for item in funcMenuModels {
            let w = item.name.ty_textSize(font: .font(fontSize: 14), width: CGFloat.greatestFiniteMagnitude, height:15).width
            if w > textMaxW {
                textMaxW = w
            }
        }
        textMaxW = max(textMaxW, iconSize.width)
        
        let maxW: CGFloat = (width - inset.left - inset.right - 20 * 3) / 4.0
        if maxW >= textMaxW {
            itemSizeW = textMaxW
            minimumInteritemSpacing = (width - 1 - inset.left - inset.right - itemSizeW * 4) / 3.0
        }else {
            itemSizeW = maxW
            minimumInteritemSpacing = 20
        }
    }
    
}

extension HCFuncMenuCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return funcMenuModels.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HCFuncMenuItemCell_identifer, for: indexPath) as! HCFuncMenuItemCell
        cell.funcModel = funcMenuModels[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        itemClicked?(funcMenuModels[indexPath.row])
    }
}

extension HCFuncMenuCell: HCLayoutDelegate {
    
    func itemSize(for indexPath: IndexPath, layout: UICollectionViewFlowLayout) -> CGSize {
        return .init(width: itemSizeW, height: itemHeight)
    }
    
    func referenceSize(forHeader insSection: Int, layout: UICollectionViewFlowLayout) -> CGSize {
        return .zero
    }
    
    func minimumLineSpacing(in section: Int, layout: UICollectionViewFlowLayout) -> CGFloat {
        return lineSpacing
    }
    
    func minimumInterSpacing(in section: Int, layout: UICollectionViewFlowLayout) -> CGFloat {
        return minimumInteritemSpacing
    }
    
    func sectionInset(in section: Int, layout: UICollectionViewFlowLayout) -> UIEdgeInsets {
        return inset
    }
    
}

public let HCFuncMenuItemCell_identifer = "HCFuncMenuItemCell"

class HCFuncMenuItemCell: UICollectionViewCell {
    
    private var icon: UIImageView!
    private var title: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var funcModel: HCFunctionsMenuModel! {
        didSet {
            icon.setImage(funcModel.iconPath)
            title.text = funcModel.name
        }
    }
    
    private func initUI() {
        icon = UIImageView()
        
        title = UILabel()
        title.textColor = RGB(70, 70, 70)
        title.font = .font(fontSize: 14)
        title.textAlignment = .center
        
        addSubview(icon)
        addSubview(title)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        icon.frame = .init(origin: CGPoint.init(x: (width - iconSize.width) / 2,
                                                y: 0),
                           size: iconSize)
        title.frame = .init(x: 0, y: icon.frame.maxY + titleTop, width: width, height: titleHeight)
    }
}
