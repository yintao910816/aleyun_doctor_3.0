//
//  HCHomeViewContainer.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/8.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCHomeViewContainer: UIView {

    private var collectionView: UICollectionView!

    private var menuItems: [HCFunctionsMenuModel] = []
    private var pageIdx: Int = 0
    
    public var menuChanged: ((HCMenuItemModel)->())?
    public var funcItemClicked: ((HCFunctionsMenuModel)->())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
        
        collectionView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.frame = bounds
    }
   
    public func reloadData(menuItems: [HCFunctionsMenuModel], page: Int) {
        pageIdx = page
        self.menuItems = menuItems
        
        collectionView.reloadData()
    }
    
//    public func reloadArticleDatas(datas: [HCCmsArticleModel], page: Int){
//        pageIdx = page
//        articleDatas = datas
//        collectionView.reloadData()
//    }
}

extension HCHomeViewContainer {
    
    private func initUI() {
        backgroundColor = RGB(247, 247, 247)
        
        collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = backgroundColor
        collectionView.dataSource = self
        collectionView.delegate = self
        addSubview(collectionView)
        
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }

        collectionView.register(HCHomeHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HCHomeHeaderReusableView_identifier)
    }

}

extension HCHomeViewContainer: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var header = UICollectionReusableView()
        if kind == UICollectionView.elementKindSectionHeader {
            if indexPath.section == 0 {
                header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HCHomeHeaderReusableView_identifier, for: indexPath)
                (header as? HCHomeHeaderReusableView)?.funcMenuModels = menuItems
                (header as? HCHomeHeaderReusableView)?.funcItemClicked = { [weak self] in self?.funcItemClicked?($0) }
            }
        }

        return header
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section {
        case 0:
            if #available(iOS 11.0, *) {
                return .init(width: width, height: HCHomeHeaderReusableView.viewHeight(with: width, funcCount: menuItems.count, safeAreaTop: safeAreaInsets.top))
            } else {
                return .init(width: width, height: HCHomeHeaderReusableView.viewHeight(with: width, funcCount: menuItems.count, safeAreaTop: 0))
            }
        default:
            return .zero
        }
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        switch section {
//        case 0:
//            return .init(top: 20, left: 15, bottom: 0, right: 15)
//        case 1:
//            return .init(top: 20, left: 20, bottom: 0, right: 20)
//        case 2:
//            return .init(top: 15, left: 20, bottom: 0, right: 15)
//
//        default:
//            return .zero
//        }
        return .zero
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        switch section {
//        case 1:
//            return 10
//        default:
//            return 0
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        switch section {
//        case 0:
//            return 15
//        case 1:
//            return 10
//        default:
//            return 0
//        }
//    }

//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        switch indexPath.section {
//        case 0:
//            funcItemClicked?(menuItems[3 + indexPath.row])
//        case 1:
//            break
//        case 2:
//            articleClicked?(articleDatas[indexPath.row])
//        default:
//            break
//        }
//    }
}
