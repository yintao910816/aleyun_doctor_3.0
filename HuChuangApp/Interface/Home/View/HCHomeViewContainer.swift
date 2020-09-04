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
    private var bannerItems: [HCBannerModel] = []
    private var animotionMenuItems: [HCAninotionMenuModel] = HCAninotionMenuModel.creatHomeMenuItems()

    private var pageIdx: Int = 0
    
    public var menuChanged: ((HCMenuItemModel)->())?
    public var funcItemClicked: ((HCFunctionsMenuModel)->())?
    public var menuChangeCallBack: (((HCAninotionMenuModel, Int))->())?

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
   
    public func reloadData(menuItems: [HCFunctionsMenuModel], bannerItems: [HCBannerModel], page: Int) {
        pageIdx = page
        self.menuItems = menuItems
        self.bannerItems = bannerItems
        
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
        collectionView.register(HCMenuReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HCMenuReusableView_identifier)

        collectionView.register(HCBannerItemCell.self, forCellWithReuseIdentifier: HCBannerItemCell_identifier)
    }

}

extension HCHomeViewContainer: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return bannerItems.count > 0 ? 1 : 0
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        if indexPath.section == 0 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: HCBannerItemCell_identifier, for: indexPath)
            (cell as! HCBannerItemCell).bannerDatas = bannerItems
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            if bannerItems.count > 0 {
                return .init(width: width, height: HCBannerItemCell_height)
            }
        default:
            return .zero
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var header = UICollectionReusableView()
        if kind == UICollectionView.elementKindSectionHeader {
            if indexPath.section == 0 {
                header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HCHomeHeaderReusableView_identifier, for: indexPath)
                (header as? HCHomeHeaderReusableView)?.funcMenuModels = menuItems
                (header as? HCHomeHeaderReusableView)?.funcItemClicked = { [weak self] in self?.funcItemClicked?($0) }
            }else if indexPath.section == 1 {
                header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HCMenuReusableView_identifier, for: indexPath)
                (header as? HCMenuReusableView)?.menuItems = animotionMenuItems
                (header as? HCMenuReusableView)?.menuChangeCallBack = { [weak self] in self?.menuChangeCallBack?($0) }
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
        case 1:
            return .init(width: width, height: HCMenuReusableView_height)
        default:
            return .zero
        }
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case 0:
            return .init(top: 0, left: 0, bottom: 10, right: 0)
        case 1:
            return .init(top: 0, left: 0, bottom: 0, right: 0)
        default:
            return .zero
        }
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
