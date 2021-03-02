//
//  HCPicConsultSettingContainer.swift
//  HuChuangApp
//
//  Created by yintao on 2020/12/17.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

import RxSwift

class HCPicConsultSettingContainer: UIView {

    private var collectionView: UICollectionView!
    private var actionView: HCConsultSettingBottomActionView!
    
    public var cellDidSelected: ((IndexPath)->())?
    public var closeCallBack: (()->())?
    public let updateConsultUserStatusSubject = PublishSubject<Void>()
    
    private var currentResponder: UIResponder?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: width, height: 50)
        layout.sectionInset = .init(top: 10, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        
        collectionView = UICollectionView.init(frame: bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = RGB(247, 247, 247)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.keyboardDismissMode = .onDrag
        
        actionView = HCConsultSettingBottomActionView(frame: .init(x: 0, y: height - 50, width: width, height: 50))
        actionView.actionCallBack = { [unowned self] in
            if $0 == .save {
                self.updateConsultUserStatusSubject.onNext(Void())
            }else {
                self.closeCallBack?()
            }
        }

        addSubview(actionView)
        addSubview(collectionView)
        
        collectionView.register(HCSwitchCollectionCell.self,
                                forCellWithReuseIdentifier: HCSwitchCollectionCell_identifier)
        collectionView.register(HCDetailTextFiledCollectionCell.self,
                                forCellWithReuseIdentifier: HCDetailTextFiledCollectionCell_identifier)
        collectionView.register(HCDetailCollectionCell.self,
                                forCellWithReuseIdentifier: HCDetailCollectionCell_identifier)
        collectionView.register(HCPicConsultSettingUnitFooterView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: "footer")
        
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(tapAction(tapGes:)))
        tapGes.delegate = self
        collectionView.addGestureRecognizer(tapGes)
    }
    
    @objc private func tapAction(tapGes: UITapGestureRecognizer) {
        currentResponder?.resignFirstResponder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var datasource: [HCListCellItem] = [] {
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

extension HCPicConsultSettingContainer: UIGestureRecognizerDelegate {
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return self.currentResponder != nil
    }
}

extension HCPicConsultSettingContainer: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: datasource[indexPath.row].cellIdentifier,
                                                      for: indexPath) as! HCCollectionCell
        cell.model = datasource[indexPath.row]
        cell.responderChangeCallBack = { [weak self] in self?.currentResponder = $0 }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cellDidSelected?(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter,
                                                                   withReuseIdentifier: "footer",
                                                                   for: indexPath)
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .init(width: collectionView.width, height: 30)
    }
}

class HCPicConsultSettingUnitFooterView: UICollectionReusableView {
    
    private var remindLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        remindLabel = UILabel()
        remindLabel.textAlignment = .right
        remindLabel.font = .font(fontSize: 12, fontName: .PingFRegular)
        remindLabel.textColor = RGB(40, 151, 248)
        remindLabel.text = "建议3回合"
        addSubview(remindLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        remindLabel.frame = .init(x: width - 15 - 60, y: (height - 14) / 2, width: 60, height: 14)
    }
}
