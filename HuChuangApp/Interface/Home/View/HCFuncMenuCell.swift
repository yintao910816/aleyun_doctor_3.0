//
//  HCFuncMenuCel.swift
//  HuChuangApp
//
//  Created by yintao on 2020/9/2.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCFuncMenuCell_identifier: String = "HCFuncMenuCell"

private let minimumInteritemSpacing: CGFloat = 24
private let minimumLineSpacing: CGFloat = 35
private let inset: UIEdgeInsets = .init(top: 10, left: 25, bottom: 15, right: 25)
private let itemHeight: CGFloat = 55
private let iconSize: CGSize = .init(width: 28, height: 28)
private let titleHeight: CGFloat = 17
private let titleTop: CGFloat = 10

class HCFuncMenuCell: UICollectionViewCell {
    
    private var funcCollectionView: UICollectionView!

    public var itemClicked: ((HCFunctionsMenuModel)->())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let layout = UICollectionViewFlowLayout()
        funcCollectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        funcCollectionView.backgroundColor = .white
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
        height += lines == 2 ? minimumInteritemSpacing : 0
        return height
    }
}

extension HCFuncMenuCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return funcMenuModels.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w: CGFloat = (width - inset.left - inset.right - 3 * minimumLineSpacing) / 4.0
        return .init(width: w, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HCFuncMenuItemCell_identifer, for: indexPath) as! HCFuncMenuItemCell
        cell.funcModel = funcMenuModels[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumInteritemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return inset
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        itemClicked?(funcMenuModels[indexPath.row])
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
