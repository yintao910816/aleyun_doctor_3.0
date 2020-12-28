//
//  HCPhotoSelectedView.swift
//  HuChuangApp
//
//  Created by yintao on 2020/12/28.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCPhotoSelectedView: UIView {

    private var collectionView: UICollectionView!
    
    public var delCallBack: ((IndexPath)->())?
    public var addCallBack: (()->())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .zero
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = backgroundColor
        addSubview(collectionView)
        
        collectionView.register(HCPhotoSelectedViewCell.self, forCellWithReuseIdentifier: "HCPhotoSelectedViewCell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var datasource: [HCPhotoViewModel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.frame = bounds
    }
}

extension HCPhotoSelectedView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HCPhotoSelectedViewCell", for: indexPath) as! HCPhotoSelectedViewCell
        cell.model = datasource[indexPath.row]
        cell.delCallBack = { [unowned self] in delCallBack?(indexPath) }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 70, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if datasource[indexPath.row].isAdd {
            addCallBack?()
        }
    }
}

class HCPhotoSelectedViewCell: UICollectionViewCell {
    
    private var content: UIImageView!
    private var delButton: UIButton!
    
    public var delCallBack: (()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        content = UIImageView()
        content.clipsToBounds = true
        content.backgroundColor = RGB(238, 238, 238)
        content.layer.cornerRadius = 10
        
        delButton = UIButton()
        delButton.setImage(UIImage(named: "chat_del_image"), for: .normal)
        delButton.addTarget(self, action: #selector(delAction), for: .touchUpInside)
        
        contentView.addSubview(content)
        contentView.addSubview(delButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var model: HCPhotoViewModel! {
        didSet {
            content.image = model.image
            
            if model.url.count > 0 {
                content.setImage(model.url)
            }
            
            delButton.isHidden = model.isAdd
            content.contentMode = model.isAdd ? .center : .scaleAspectFill
        }
    }
    
    @objc private func delAction() {
        delCallBack?()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        content.frame = .init(x: 0, y: 5, width: width - 5, height: height - 5)
        delButton.frame = .init(x: width - 15, y: 0, width: 15, height: 15)
    }
}

class HCPhotoViewModel {
    var image: UIImage?
    var url: String = ""
    var isAdd: Bool = false
    
    init(image: UIImage?, url: String = "", isAdd: Bool = false) {
        self.image = image
        self.url = url
        self.isAdd = isAdd
    }
}
