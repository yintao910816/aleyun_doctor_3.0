//
//  HCBoxPhotoView.swift
//  HuChuangApp
//
//  Created by yintao on 2020/5/23.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCBoxPhotoView: UIView {

    private var collectionView: UICollectionView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = .zero
        
        collectionView = UICollectionView.init(frame: bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        addSubview(collectionView)
        
        collectionView.register(HCPhotoCell.self, forCellWithReuseIdentifier: "HCPhotoCell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var filles: [HCPhotoBoxProtocol] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
    }
}

extension HCBoxPhotoView {
    
    public static func itemSize(with dataCount: Int) ->CGSize {
        guard dataCount > 0 else { return .zero }
        if dataCount == 1 {
            return .init(width: 77, height: 150)
        }else {
            return .init(width: 80, height: 80)
        }
    }
    
    public static func contentSize(with dataCount: Int) ->CGSize {
        guard dataCount > 0 else { return .zero }

        let itemSize = HCBoxPhotoView.itemSize(with: dataCount)
        if dataCount == 1 {
            return itemSize
        }else if dataCount <= 3 {
            return .init(width: itemSize.width * CGFloat(dataCount) + 5 * CGFloat(dataCount - 1), height: itemSize.height)
        }else if dataCount <= 6 {
            return .init(width: itemSize.width * 3 + 5 * 2, height: itemSize.height * 2 + 5)
        }else {
            return .init(width: itemSize.width * 3 + 5 * 2, height: itemSize.height * 3 + 5 * 2)
        }
    }
}

extension HCBoxPhotoView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HCPhotoCell", for: indexPath) as! HCPhotoCell
        cell.photo = filles[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return HCBoxPhotoView.itemSize(with: filles.count)
    }
}

class HCPhotoCell: UICollectionViewCell {
    
    private var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView()
        imageView.backgroundColor = RGB(240, 240, 240)
//        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true
        addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var photo: HCPhotoBoxProtocol! {
        didSet {
            if let url = photo.imageURL {
                imageView.setImage(url)
            }else {
                imageView.image = photo.image
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = bounds
    }
}

protocol HCPhotoBoxProtocol {
    var imageURL: String? { get }
    var image: UIImage? { get }
}

extension HCPhotoBoxProtocol {
    var imageURL: String? { return nil }
    var image: UIImage? { return nil }
}
