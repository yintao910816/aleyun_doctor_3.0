//
//  TYSlideMenuController.swift
//  HuChuangApp
//
//  Created by sw on 2019/9/27.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit
import RxSwift

class TYSlideMenuController: UIViewController {

    private var headerMenu: TYSlideMenu!
    private var pageCtrl: UIPageViewController!
    
    private var currentPage: Int = 0
    
    private var pendingCtrl: UIViewController?
        
    public var isPagingEnabled: Bool = true

    public var isFullScreen: Bool = true
    public var pageScroll: ((Int)->())?
    public let pageScrollSubject = PublishSubject<Int>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        headerMenu = TYSlideMenu()
        headerMenu.isFullScreen = isFullScreen
        headerMenu.backgroundColor = .white
        view.addSubview(headerMenu)
        
        headerMenu.datasource = menuItems
        headerMenu.menuSelect = { [weak self] page in
            guard let strongSelf = self else { return }
            strongSelf.selectedPage(page: page, needCallBack: true)
        }
        
        pageCtrl = UIPageViewController.init(transitionStyle: .scroll,
                                             navigationOrientation: .horizontal,
                                             options: [UIPageViewController.OptionsKey.interPageSpacing : 0])
        pageCtrl.dataSource = self
        pageCtrl.delegate = self
        addChild(pageCtrl)
        view.addSubview(pageCtrl.view)
    }
         
    public func selectedPage(page: Int, needCallBack: Bool, needMenuScroll: Bool = false) {
        if page == currentPage || page >= menuCtrls.count { return }
        
        pageCtrl.setViewControllers([menuCtrls[page]],
                                               direction: page > currentPage ? .forward : .reverse,
                                               animated: true) { if $0 {  } }
        
        currentPage = page
        
        if needCallBack {
            pageScroll?(page)
            pageScrollSubject.onNext(page)
        }
        
        if needMenuScroll {
            headerMenu.setMenu(index: page)
        }
    }
    
    public var menuCtrls: [HCSlideItemController] = [] {
        didSet {
            pageCtrl.scrollView?.isScrollEnabled = isPagingEnabled

            for idx in 0..<menuCtrls.count {
                menuCtrls[idx].pageIdx = idx
            }
            
            if menuCtrls.count > currentPage {
                let ctrl = menuCtrls[currentPage]
                ctrl.view.frame = pageCtrl.view.bounds
                pageCtrl.setViewControllers([ctrl],
                                            direction: .reverse,
                                            animated: false,
                                            completion: nil)
            }else {
                pageCtrl.setViewControllers(nil,
                                            direction: .reverse,
                                            animated: false,
                                            completion: nil)
            }
        }
    }
    
    public var menuItems: [TYSlideItemModel] = [] {
        didSet {
            headerMenu.datasource = menuItems
        }
    }

    public func reloadList(listMode: [Any], page: Int) {
        if menuCtrls.count > page {
            menuCtrls[page].reloadData(data: listMode)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        headerMenu.frame = .init(x: 0, y: 0, width: view.width, height: 50)
        pageCtrl.view.frame = .init(x: 0, y: headerMenu.frame.maxY, width: view.width, height: view.height - headerMenu.height)
    }
}

extension TYSlideMenuController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    // 获取上一页
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if menuCtrls.count > (currentPage - 1) && currentPage > 0 {
            currentPage -= 1
            let ctrl = menuCtrls.first(where: { $0.pageIdx == currentPage })
            ctrl?.view.frame = pageCtrl.view.bounds
            
            return ctrl
        }
        
        return nil
    }
    
    // 获取下一页
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if menuCtrls.count > (currentPage + 1) {
            currentPage += 1
            let ctrl = menuCtrls.first(where: { $0.pageIdx == currentPage })
            
            ctrl?.view.frame = pageCtrl.view.bounds

            return ctrl
        }
        
        return nil
    }
    
    //MARK: - UIPageViewControllerDelegate
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        pendingCtrl = pendingViewControllers.first
    }
    
    // 动画过渡完成 - previousViewControllers为过渡之前的视图控制器
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        PrintLog("动画过渡完成: \(completed)")
        
        if !completed { return }
        
        for idx in 0..<menuCtrls.count {
            // //判断视图控制器是否与正在转换的视图控制器为同一个
            if pendingCtrl == menuCtrls[idx] {
                currentPage = idx
                           
                headerMenu.setMenu(index: currentPage)
                pageScroll?(currentPage)
                pageScrollSubject.onNext(currentPage)
                break
            }
        }
    }
}

//MARK: -- TYSlideMenu
class TYSlideMenu: UIView {
    
    private var collectionView: UICollectionView!
    private var lineView: UIView!
    
    private var lastSelected: Int = 0
    public var menuSelect: ((Int)->())?
    public var isFullScreen: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .zero
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView.init(frame: frame, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        
        lineView = UIView()
        lineView.backgroundColor = RGB(243, 243, 243)
        
        addSubview(collectionView)
        addSubview(lineView)
        
        collectionView.register(TYSlideCell.self, forCellWithReuseIdentifier: UICollectionViewCell_identifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setMenu(index: Int) {
        if index != lastSelected {
            datasource[index].isSelected = true
            datasource[lastSelected].isSelected = false
            collectionView.reloadData()
            
            lastSelected = index
        }
    }
    
    public var datasource: [TYSlideItemModel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.frame = .init(x: 0, y: 0, width: width, height: height - 0.5)
        lineView.frame = .init(x: 0, y: collectionView.frame.maxY, width: width, height: 0.5)
    }
}

extension TYSlideMenu: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: UICollectionViewCell_identifier, for: indexPath) as! TYSlideCell)
        cell.model = datasource[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemW: CGFloat = isFullScreen ? width / CGFloat(datasource.count) : datasource[indexPath.row].contentWidth
        return .init(width: itemW, height: collectionView.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        menuSelect?(indexPath.row)

        if lastSelected != indexPath.row {
            datasource[indexPath.row].isSelected = true
            datasource[lastSelected].isSelected = false
            collectionView.reloadData()
            
            lastSelected = indexPath.row
        }
    }
}

//MARK: -- Cell
private let UICollectionViewCell_identifier = "UICollectionViewCell"
class TYSlideCell: UICollectionViewCell {
    private var titleLabel: UILabel!
    private var iconImgV: UIImageView!
    private var bottomLine: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel = UILabel()
        titleLabel.backgroundColor = .clear
        titleLabel.textAlignment = .center
        titleLabel.font = .font(fontSize: 14)
        
        iconImgV = UIImageView()
        
        addSubview(iconImgV)
        addSubview(titleLabel)
        
        bottomLine = UIView()
        insertSubview(bottomLine, aboveSubview: titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var model: TYSlideItemModel! {
        didSet {
            titleLabel.text = model.title
            titleLabel.font = model.textFont
            iconImgV.image = model.icon
            
            titleLabel.textColor = model.isSelected ? model.selectedTextColor : model.textColor
            bottomLine.backgroundColor = model.lineColor
            bottomLine.isHidden = (!model.isSelected || model.isHiddenAnimotionView)
            
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if iconImgV.image == nil {
            titleLabel.frame = bounds
        }else {
            var titleWidth: CGFloat = titleLabel.sizeThatFits(.init(width: CGFloat(MAXFLOAT), height: height)).width
            var x: CGFloat = (width - titleWidth - 7) / 2.0

            if x < 0 {
                x = 7
                titleWidth = width - 21 - 10
            }
            
            titleLabel.frame = .init(x: x, y: 0, width: titleWidth, height: height)
            iconImgV.frame = .init(x: titleLabel.frame.maxX + 7, y: (height - 5) / 2.0, width: 10, height: 5)
        }
        bottomLine.frame = .init(x: (width - model.lineWidth) / 2, y: height - 2, width: model.lineWidth, height: 2)
    }
}

extension UIPageViewController {
   
    public func removeGestureRecognizers() {
        view.gestureRecognizers?.forEach{ view.removeGestureRecognizer($0) }
    }
    
    public var scrollView: UIScrollView? {
        return view.subviews.compactMap { $0 as? UIScrollView }.first
    }
    
}
