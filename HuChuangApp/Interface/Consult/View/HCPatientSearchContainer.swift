//
//  HCPatientSearchContainer.swift
//  HuChuangApp
//
//  Created by yintao on 2021/1/4.
//  Copyright © 2021 sw. All rights reserved.
//

import UIKit

import RxSwift
import RxDataSources

class HCPatientSearchContainer: UIView {

    private let disposeBag = DisposeBag()

    private var searchBar: TYSearchBar!

    public var tableView: UITableView!
    
    public let datasource = Variable([HCPatientGroupListItemModel]())
    public let beginSearchSignal = PublishSubject<String>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        
        datasource.asDriver()
            .drive(tableView.rx.items(cellIdentifier: HCPatientSearchCell_identifier,
                                      cellType: HCPatientSearchCell.self)) { _, model, cell in
                cell.groupPatientModel = model
            }
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        searchBar.frame = .init(x: 0, y: 0, width: width, height: 50)
        tableView.frame = .init(x: 0, y: searchBar.frame.maxY, width: width, height: height - searchBar.frame.maxY)
    }
}

extension HCPatientSearchContainer {
    
    private func setupUI() {
        searchBar = TYSearchBar()
        searchBar.viewConfig = TYSearchBarConfig.createPatientSearch()
        searchBar.coverButtonEnable = false
        searchBar.backgroundColor = .white
        searchBar.beginSearch = { [unowned self] in
            if $0.count > 0 {
                beginSearchSignal.onNext($0)
            }
        }

        tableView = UITableView.init(frame: .zero, style: .grouped)
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.rowHeight = HCPatientSearchCell_height

        addSubview(tableView)
        addSubview(searchBar)
        
        tableView.register(HCPatientSearchCell.self, forCellReuseIdentifier: HCPatientSearchCell_identifier)
    }
}
