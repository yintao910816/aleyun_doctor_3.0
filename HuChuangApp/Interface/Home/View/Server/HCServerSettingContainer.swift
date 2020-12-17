//
//  HCServerSettingContainer.swift
//  HuChuangApp
//
//  Created by yintao on 2020/12/17.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCServerSettingContainer: UIView {

    private var collectionView: UICollectionView!
    
    public var selectedCallBack: ((HCServerSettingModel)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = .init(top: 10, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 10
        
        collectionView = UICollectionView.init(frame: frame, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = RGB(247, 247, 247)
        
        collectionView.register(HCServerSettingCell.self, forCellWithReuseIdentifier: HCServerSettingCell_identifier)
        
        addSubview(collectionView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var datasource: [HCServerSettingModel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.frame = bounds
    }
}

extension HCServerSettingContainer: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HCServerSettingCell_identifier, for: indexPath) as! HCServerSettingCell
        cell.model = datasource[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: width, height: HCServerSettingCell_height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCallBack?(datasource[indexPath.row])
    }
}
