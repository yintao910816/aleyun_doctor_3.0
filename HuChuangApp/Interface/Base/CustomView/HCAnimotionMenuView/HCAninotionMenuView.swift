//
//  HCAninotionMenuView.swift
//  HuChuangApp
//
//  Created by sw on 2020/9/4.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCAninotionMenuView: UIView {

    private var contentView: UIView!
    private var bgImgV: UIImageView!
    private var collectionView: UICollectionView!
    
    private var isFullLayout: Bool = true
    private var currentIdx: Int = 0
    
    public var menuChangeCallBack: (((HCAninotionMenuModel, Int))->())?
    
    init(frame: CGRect, isFullLayout: Bool = true) {
        super.init(frame: frame)
        
        self.isFullLayout = isFullLayout
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var menuItems: [HCAninotionMenuModel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = bounds
        collectionView.frame = .init(x: 0, y: 0, width: contentView.width, height: contentView.height)
        
        let info = cacluteAnimotionView()
        bgImgV.frame = .init(x: info.0, y: 0, width: info.1, height: height)
    }
    
}

extension HCAninotionMenuView {
    
    private func initUI() {
        contentView = UIView()
        contentView.backgroundColor = RGB(247, 247, 247)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        
        bgImgV = UIImageView.init(image: UIImage(named: "menu_item_selected_bg"))

        addSubview(contentView)
        contentView.addSubview(bgImgV)
        contentView.addSubview(collectionView)
        
        collectionView.register(HCAninotionMenuCell.self, forCellWithReuseIdentifier: HCAninotionMenuCell_identifier)
    }
    
    private func cacluteAnimotionView() ->((CGFloat, CGFloat)) {
        var textTotleW: CGFloat = 0
        var bgImgX: CGFloat = 0
        var bgW: CGFloat = 0
        
        for idx in 0..<menuItems.count {
            let textW: CGFloat = menuItems[idx].width
            textTotleW += textW
            
            if idx < currentIdx {
                bgImgX += textW
            }
            
            if idx == currentIdx {
                bgW = textW + 30
            }
        }

        var margin: CGFloat = 25
        if isFullLayout {
            margin = menuItems.count > 1 ? (width - textTotleW - 30) / CGFloat(menuItems.count - 1) : 0
        }
        
        bgImgX += CGFloat(currentIdx) * margin
        
        return (bgImgX, bgW)
    }
}

extension HCAninotionMenuView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HCAninotionMenuCell_identifier, for: indexPath) as! HCAninotionMenuCell
        cell.model = menuItems[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: menuItems[indexPath.row].width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 15, bottom: 0, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        var margin: CGFloat = 25
        var textTotleW: CGFloat = 0
        
        for idx in 0..<menuItems.count {
            textTotleW += menuItems[idx].width
        }

        if isFullLayout {
            margin = menuItems.count > 1 ? (width - textTotleW - 30) / CGFloat(menuItems.count - 1) : 0
        }

        return margin
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if currentIdx != indexPath.row {
            menuItems[indexPath.row].statu = .selected
            menuItems[currentIdx].statu = .normal
            currentIdx = indexPath.row
            collectionView.reloadData()
            
            isUserInteractionEnabled = false
            let info = cacluteAnimotionView()
            UIView.animate(withDuration: 0.25, animations: { [weak self] in
                self?.bgImgV.frame = .init(x: info.0, y: 0, width: info.1, height: self?.height ?? 0)
            }) { [weak self] in
                if $0 {
                    self?.isUserInteractionEnabled = true
                }
            }
            
            menuChangeCallBack?((menuItems[indexPath.row], indexPath.row))
        }
    }
}

//MARK:
//MARK: cell

private let HCAninotionMenuCell_identifier = "HCAninotionMenuCell"
private let HCAninotionMenuCell_height: CGFloat = 40

class HCAninotionMenuCell: UICollectionViewCell {

    private var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var model: HCAninotionMenuModel! {
        didSet {
            titleLabel.text = model.title
            titleLabel.font = model.statu.titleFont
            titleLabel.textColor = model.statu.titleColor
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.frame = bounds
    }

    private func initUI() {
        backgroundColor = .clear
        
        titleLabel = UILabel()
        titleLabel.contentMode = .center
        
        addSubview(titleLabel)
    }
}
