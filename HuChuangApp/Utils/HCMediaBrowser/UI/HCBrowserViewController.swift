//
//  HCBrowserViewController.swift
//  HuChuangApp
//
//  Created by sw on 2021/1/17.
//  Copyright © 2021 sw. All rights reserved.
//

import UIKit

open class HCBrowserViewController: UIViewController {
    
    private var datasource: [HCMediaSectionModel] = []

    // 表示了当前显示图片的序号，从(0,0)开始计数
    var pageIndexPath: IndexPath = IndexPath.init(row: 0, section: 0)

    /// 左右两张图之间的间隙
    var photoSpacing: CGFloat = 30

    /// 转场动画打开时的frame
    var presentZoomRect: CGRect?
    /// 打开浏览器时的媒体文件
    var zoomFileData: HCPhotoBrowserModel?


    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = transDelegate
        
        configUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// 转场动画代理
    var transDelegate: HCBrowserTransitioningDelegate? {
        didSet {
            transDelegate?.browser = self
            self.transitioningDelegate = transDelegate
        }
    }
    
    func configData(datasource: [HCMediaSectionModel], pageIndexPath: IndexPath) {
        self.datasource = datasource
        self.pageIndexPath = pageIndexPath
        
        collectionView.performBatchUpdates({

        }, completion: { [weak self] finished in
            if finished, let strongSelf = self {
                strongSelf.scrollToItem(strongSelf.pageIndexPath, at: .left, animated: false)
            }
        })
    }


    /// 流型布局
    lazy var flowLayout: HCBrowserFlowlayout = {
        let layout = HCBrowserFlowlayout()
        layout.delegate = self
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 30
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .init(top: 0, left: 0, bottom: 30, right: 0)
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.alwaysBounceVertical = false
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    deinit {
        print("deinit:\(self)")
    }

}

extension HCBrowserViewController {
    
    private func configUI() {
        view.addSubview(collectionView)
        
                
        collectionView.register(HCBrowserPhotoCell.self, forCellWithReuseIdentifier: "HCBrowserPhotoCell")
                
        collectionView.frame = .init(x: 0,
                                     y: 0,
                                     width: view.frame.size.width + photoSpacing,
                                     height: view.frame.size.height)
    }

    /// 滑到哪张图片
    /// - parameter index: 图片序号，从0开始
    private func scrollToItem(_ indexPath: IndexPath, at position: UICollectionView.ScrollPosition, animated: Bool) {
        let safeSection = min(indexPath.section, datasource.count - 1)
        if safeSection < 0 { return }
        
        let safeRow     = min(indexPath.row, datasource[safeSection].items.count - 1)
        let safeIndex = IndexPath.init(row: safeRow, section: safeSection)
        
        collectionView.scrollToItem(at: safeIndex, at: position, animated: animated)
    }

}

extension HCBrowserViewController {
    
    /// 取转场动画视图
    public var transitionZoomView: UIView? {
        if let model = zoomFileData, let rect = presentZoomRect {
            let imgV = UIImageView.init(frame: rect)

            if model.mediaType == .photo {
                // 图片
                imgV.contentMode = .scaleAspectFill
                imgV.clipsToBounds = true

                imgV.setImage(model.picPath)
                return imgV
            }
        }
        return nil
    }
    
    public var presentZoomEndRect: CGRect? {
//        guard let fileDB = zoomFileData else {
            return UIScreen.main.bounds
//        }

//        let endFrame = HCBrowserImageScaleHelper.calculateImage(imageSize: .init(width: fileDB.picwidth,
//                                                                                 height: fileDB.picHeight),
//                                                                maxSize: UIScreen.main.bounds.size,
//                                                                offset: false)
        
//        return endFrame
    }
    
    public var dismissZoomStartRect: CGRect? {
        if datasource[pageIndexPath.section].browserType == .photo,
            let cell = collectionView.cellForItem(at: pageIndexPath) as? HCBrowserPhotoCell {
            return cell.imageView.superview?.convert(cell.imageView.frame, to: UIApplication.shared.keyWindow)
        }
//        else if datasource[pageIndexPath.section].browserType == .video,
//            let cell = collectionView.cellForItem(at: pageIndexPath) as? HCBrowserVideoCell {
//            return cell.imageView.superview?.convert(cell.imageView.frame, to: UIApplication.shared.keyWindow)
//        }
        else {
            return nil
        }
    }
    
    public var transitionDismissZoomView: UIView? {
        if datasource.count <= pageIndexPath.section { return nil }
                
        let imgV = UIImageView()
        imgV.contentMode = .scaleAspectFill
        imgV.clipsToBounds = true

        if datasource[pageIndexPath.section].browserType == .photo,
            let cell = collectionView.cellForItem(at: pageIndexPath) as? HCBrowserPhotoCell {
            
            imgV.setImage((datasource[pageIndexPath.section].items[pageIndexPath.row] as? HCPhotoBrowserModel)?.picPath)
            imgV.frame = cell.imageView.superview?.convert(cell.imageView.frame, to: UIApplication.shared.keyWindow) ?? UIScreen.main.bounds

            return imgV
        }
//        else if datasource[pageIndexPath.section].browserType == .video,
//            let cell = collectionView.cellForItem(at: pageIndexPath) as? PTBrowserVideoCell {
//
//            imgV.frame = cell.imageView.superview?.convert(cell.imageView.frame, to: UIApplication.shared.keyWindow) ?? UIScreen.main.bounds
//
//            imgV.image = SourceManager.videoCover(for: cell.thumbnailKey,
//                                                  isJustLocation: cell.isJustLocation,
//                                                  contentSize: .init(width: cell.picWidth, height: cell.picHeight))
//
////            imgV.image = SourceManager.videoCover(for: cell.fileKey,
////                                                  coverImagePath: cell.thumbnailKey,
////                                                  isJustLocation: cell.isJustLocation,
////                                                  contentSize: .init(width: cell.picWidth, height: cell.picHeight))
//
////            cell.stopPlay()
//
//            return imgV
//
//        }else if datasource[pageIndexPath.section].browserType == .audio {
//            return nil
//        }

        return nil
    }
        
    public var currentMid: Int64? { return nil }
    
}

extension HCBrowserViewController: UICollectionViewDelegate, HCBrowserFlowlayoutDelegate {
    
    //MARK: HCBrowserFlowlayoutDelegate
    var currentIndexPath: IndexPath? { return pageIndexPath }
        
}

extension HCBrowserViewController: UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return datasource.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource[section].items.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HCBrowserPhotoCell", for: indexPath) as! HCBrowserPhotoCell
        cell.sourceModel = datasource[indexPath.section].items[indexPath.row]
        configCellCallBack(cell: cell, indexPath: indexPath)
        return cell
    }
}

extension HCBrowserViewController {
    
    private func configCellCallBack(cell: HCBrowserBaseCell, indexPath: IndexPath) {
        // 拖
        cell.panChangedCallback = { [weak self] scale in
            let alpha = scale * scale
            self?.transDelegate?.maskAlpha = alpha
        }
        
        weak var weakCell = cell
        // 拖完松手
        cell.panReleasedCallback = { [weak self] isDown in
            guard let strongSelf = self else { return }
            
            if isDown {
                strongSelf.dismiss(animated: true, completion: nil)
            } else {
                strongSelf.transDelegate?.maskAlpha = 1.0
            }
        }
        
        cell.clickCallback = { [weak self] t in
            guard let strongSelf = self else { return }
            
            strongSelf.dismiss(animated: true, completion: nil)
        }
        cell.longPressedCallback = { [weak self] data in

        }
    }
    
}
