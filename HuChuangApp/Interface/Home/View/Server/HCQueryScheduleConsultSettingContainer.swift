//
//  HCQueryScheduleConsultSettingContainer.swift
//  HuChuangApp
//
//  Created by yintao on 2020/12/17.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

import RxSwift

class HCQueryScheduleConsultSettingContainer: UIView {
    
    private var actionView: HCConsultSettingBottomActionView!
    private var collectionView: UICollectionView!
    
    private var lastSelected = IndexPath.init(row: 0, section: 3)

    public var dayItemSelectedCallBack: ((HCQueryScheduleSettingModel)->())?
    public let updateConsultUserStatusSubject = PublishSubject<Void>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let layout = UICollectionViewFlowLayout()
        
        collectionView = UICollectionView.init(frame: bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        
        actionView = HCConsultSettingBottomActionView(frame: .init(x: 0, y: height - 50, width: width, height: 50))
        actionView.actionCallBack = { [unowned self] in
            if $0 == .save {
                self.updateConsultUserStatusSubject.onNext(Void())
            }else {
                
            }
        }
        addSubview(actionView)
        addSubview(collectionView)
        
        collectionView.register(HCSwitchCollectionCell.self,
                                forCellWithReuseIdentifier: HCSwitchCollectionCell_identifier)
        collectionView.register(HCDetailTextFiledCollectionCell.self,
                                forCellWithReuseIdentifier: HCDetailTextFiledCollectionCell_identifier)
        collectionView.register(HCQueryScheduleDaySettingCell.self,
                                forCellWithReuseIdentifier: HCQueryScheduleDaySettingCell_identifier)
        collectionView.register(HCCollectionSectionTitleView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HCCollectionSectionTitleView_identifier)
        collectionView.register(UICollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "UICollectionReusableView_header")
        collectionView.register(UICollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "UICollectionReusableView_footer")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var datasource: [[Any]] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        actionView.frame = .init(x: 0, y: height - 50, width: width, height: 50)
        collectionView.frame = .init(x: 0, y: 0, width: width, height: actionView.y)
    }
}

extension HCQueryScheduleConsultSettingContainer: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 3 {
            let model = datasource[indexPath.section][indexPath.row] as! HCQueryScheduleSettingModel
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HCQueryScheduleDaySettingCell_identifier, for: indexPath) as! HCQueryScheduleDaySettingCell
            cell.model = model
            return cell
        }else {
            let model = datasource[indexPath.section][indexPath.row] as! HCListCellItem
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: model.cellIdentifier,
                                                          for: indexPath) as! HCCollectionCell
            cell.model = model
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            if indexPath.section == 3 {
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HCCollectionSectionTitleView_identifier, for: indexPath) as! HCCollectionSectionTitleView
                header.title = "排班设置"
                return header
            }else {
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "UICollectionReusableView_header", for: indexPath)
                header.backgroundColor = RGB(247, 247, 247)
                return header
            }
        }else {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "UICollectionReusableView_footer", for: indexPath)
            footer.backgroundColor = RGB(247, 247, 247)
            return footer
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 3 {
            return .init(width: collectionView.width, height: 50)
        }
        return .init(width: collectionView.width, height: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 2 {
            return .init(width: collectionView.width, height: 10)
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 3 {
            return .init(top: 0, left: 15, bottom: 0, right: 15)
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return section == 3 ? 10 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return section == 3 ? 10 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 3 {
            return .init(width: (collectionView.width - 40) / 2, height: HCVideoConsultDaySettingCell_height)
        }
        let model = datasource[indexPath.section][indexPath.row] as! HCListCellItem
        return .init(width: collectionView.width, height: model.cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {        
        if let model = datasource[indexPath.section][indexPath.row] as? HCQueryScheduleSettingModel {
            
            if let lastItem = datasource[lastSelected.section][lastSelected.row] as? HCQueryScheduleSettingModel {
                lastItem.isSelected = false
            }
            
            model.isSelected = true
            
            lastSelected = indexPath
            
            collectionView.reloadData()
            
            dayItemSelectedCallBack?(model)
        }

    }

}
