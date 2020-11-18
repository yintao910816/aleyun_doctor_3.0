//
//  HCFuncMenuCel.swift
//  HuChuangApp
//
//  Created by yintao on 2020/9/2.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCFuncMenuCell_identifier: String = "HCFuncMenuCell"
public let HCFuncMenuCell_height: CGFloat = 180

class HCFuncMenuCell: UICollectionViewCell {
    
    private var funcCollectionView: UICollectionView!

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
}

extension HCFuncMenuCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return funcMenuModels.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: (width - 25 * 2 - 36*3) / 4, height: (height - 10 - 15 - 25) / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HCFuncMenuItemCell_identifer, for: indexPath) as! HCFuncMenuItemCell
        cell.funcModel = funcMenuModels[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 25
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 36
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 10, left: 25, bottom: 15, right: 25)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

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
        title.textColor = RGB(12, 12, 12)
        title.font = .font(fontSize: 12)
        title.textAlignment = .center
        
        addSubview(icon)
        addSubview(title)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        icon.frame = .init(x: 0, y: 0, width: width, height: width)
        title.frame = .init(x: 0, y: icon.frame.maxY + 10, width: width, height: 12)
    }
}
