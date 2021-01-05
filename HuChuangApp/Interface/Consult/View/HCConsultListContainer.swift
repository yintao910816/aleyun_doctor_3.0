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
    
    private var searchBar: TYSearchBar!

    public var tableView: UITableView!
    
    public var tapInputCallBack: (()->())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        searchBar.frame = .init(x: 0, y: 0, width: width, height: TYSearchBar.baseHeight)
        tableView.frame = .init(x: 0, y: searchBar.frame.maxY, width: width, height: height - searchBar.frame.maxY)
    }
    
}

extension HCConsultListContainer {
    
    private func initUI() {
        searchBar = TYSearchBar()
        searchBar.viewConfig = TYSearchBarConfig.createConsultList()
        searchBar.backgroundColor = .white
        searchBar.tapInputCallBack = { [unowned self] in self.tapInputCallBack?() }

        tableView = UITableView.init(frame: .zero, style: .plain)
        tableView.showsVerticalScrollIndicator = true
        tableView.separatorStyle = .none
        tableView.rowHeight = HCConsultListCell_height
        
        tableView.register(HCConsultListCell.self, forCellReuseIdentifier: HCConsultListCell_identifier)

        addSubview(tableView)
        addSubview(searchBar)

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
}

extension HCConsultListContainer: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataSignal.value[indexPath.row].cellHeight
    }
}
