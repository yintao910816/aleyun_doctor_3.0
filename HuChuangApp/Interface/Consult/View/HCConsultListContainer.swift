//
//  HCConsultListContainer.swift
//  HuChuangApp
//
//  Created by yintao on 2020/10/14.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class HCConsultListContainer: UIView {

    private let disposeBag = DisposeBag()
    public let dataSignal = Variable([HCConsultListItemModel]())
    
    private var topView: UIView!
    private var searchBar: TYSearchBar!
    private var navRightView: UIView!
    private var sortButton: UIButton!

    public var tableView: UITableView!
    
    public var tapInputCallBack: (()->())?
    public let sortedSignal = PublishSubject<Bool>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        topView.frame = .init(x: 0, y: 0, width: width, height: TYSearchBar.baseHeight + 0.5)
        topView.viewWithTag(100)?.frame = .init(x: 0, y: height - 0.5, width: width, height: 0.5)
        
        navRightView.frame = .init(x: width - 10 - 60, y: 0, width: 60, height: topView.height)
        navRightView.viewWithTag(200)!.frame = .init(x: 0, y: (navRightView.height - 20) / 2, width: 42, height: 20)
//        sortButton.frame = .init(x: navRightView.viewWithTag(200)!.frame.maxX, y: navRightView.viewWithTag(200)!.y, width: navRightView.width - navRightView.viewWithTag(200)!.width, height: navRightView.viewWithTag(200)!.height)
//        sortButton.viewWithTag(201)!.frame = .init(x: (sortButton.width - 12) / 2.0, y: 3, width: 12, height: 5)
//        sortButton.viewWithTag(202)!.frame = .init(x: (sortButton.width - 12) / 2.0, y: sortButton.height - 3 - 5, width: 12, height: 5)
        sortButton.frame = .init(x: 0, y: 0, width: navRightView.width, height: navRightView.height)
        sortButton.viewWithTag(201)!.frame = .init(x: navRightView.viewWithTag(200)!.frame.maxX + 6, y: (navRightView.height - navRightView.viewWithTag(200)!.height) / 2 + 3, width: 12, height: 5)
        sortButton.viewWithTag(202)!.frame = .init(x: sortButton.viewWithTag(201)!.x, y: navRightView.height - (navRightView.height - navRightView.viewWithTag(200)!.height) / 2 - 3 - 5, width: 12, height: 5)

        searchBar.frame = .init(x: 0, y: 0, width: navRightView.x, height: TYSearchBar.baseHeight)
        tableView.frame = .init(x: 0, y: topView.frame.maxY, width: width, height: height - topView.frame.maxY)
    }
    
}

extension HCConsultListContainer {
    
    private func initUI() {
        topView = UIView()
        topView.backgroundColor = .white
        
        let line = UIView()
        line.backgroundColor = RGB(241, 241, 241)
        line.tag = 100
        
        searchBar = TYSearchBar()
        searchBar.viewConfig = TYSearchBarConfig.createConsultList()
        searchBar.backgroundColor = .white
        searchBar.tapInputCallBack = { [unowned self] in self.tapInputCallBack?() }
        
        navRightView = UIView()
        let label = UILabel()
        label.text = "按时间"
        label.textColor = RGB(51, 51, 51)
        label.font = .font(fontSize: 14)
        label.tag = 200
        
        sortButton = UIButton()
        sortButton.addTarget(self, action: #selector(actions(button:)), for: .touchUpInside)
        sortButton.isSelected = true
        
        let upButton = UIButton()
        upButton.isUserInteractionEnabled = false
        upButton.setImage(UIImage(named: "sort_up_selected"), for: .selected)
        upButton.setImage(UIImage(named: "sort_up_unselected"), for: .normal)
        upButton.tag = 201
        upButton.isSelected =  true

        let downButton = UIButton()
        downButton.isUserInteractionEnabled = false
        downButton.setImage(UIImage(named: "sort_down_selected"), for: .selected)
        downButton.setImage(UIImage(named: "sort_down_unselected"), for: .normal)
        downButton.tag = 202

        tableView = UITableView.init(frame: .zero, style: .plain)
        tableView.showsVerticalScrollIndicator = true
        tableView.separatorStyle = .none
        tableView.rowHeight = HCConsultListCell_height
        
        tableView.register(HCConsultListCell.self, forCellReuseIdentifier: HCConsultListCell_identifier)

        addSubview(tableView)
        addSubview(topView)
        topView.addSubview(searchBar)
        topView.addSubview(navRightView)
        topView.addSubview(line)
        navRightView.addSubview(sortButton)
        sortButton.addSubview(upButton)
        sortButton.addSubview(downButton)
        navRightView.addSubview(label)
        
        bindData()
    }
    
    private func bindData() {
        
        dataSignal.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: HCConsultListCell_identifier, cellType: HCConsultListCell.self)) { _, model, cell in
                cell.model = model
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] in
                self?.tableView.deselectRow(at: $0, animated: true)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    @objc private func actions(button: UIButton) {
        sortButton.isSelected = !sortButton.isSelected
        (sortButton.viewWithTag(201) as? UIButton)?.isSelected = sortButton.isSelected
        (sortButton.viewWithTag(202) as? UIButton)?.isSelected = !sortButton.isSelected

        sortedSignal.onNext(sortButton.isSelected)
    }
}

extension HCConsultListContainer: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataSignal.value[indexPath.row].cellHeight
    }
}
