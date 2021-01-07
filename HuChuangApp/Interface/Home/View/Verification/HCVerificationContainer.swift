//
//  HCVerificationContainer.swift
//  HuChuangApp
//
//  Created by sw on 2021/1/6.
//  Copyright © 2021 sw. All rights reserved.
//

import UIKit

import RxSwift
import RxDataSources

class HCVerificationContainer: UIView {
    private var disposeBag = DisposeBag()

    private var headerView: HCVerificationHeaderView!
    private var footerView: HCVerificationEmptyFooterView!
    
    public let datasource = Variable([HCVerificationItemModel]())
    public var tableView: UITableView!
    public var actionCallBack: (((HCVerificationAction, String))->())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        rxBind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tableView.frame = bounds
    }
}

extension HCVerificationContainer {
    
    private func setupUI() {
        tableView = UITableView(frame: bounds, style: .plain)
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = HCVerificationCell_height
        
        headerView = HCVerificationHeaderView(frame: .init(x: 0, y: 0, width: width, height: HCVerificationHeaderView_height))
        headerView.actionCallBack = { [unowned self] in actionCallBack?($0) }
        footerView = HCVerificationEmptyFooterView()
        
        tableView.tableHeaderView = headerView
        
        addSubview(tableView)
        
        tableView.register(HCVerificationCell.self, forCellReuseIdentifier: HCVerificationCell_identifier)
    }
    
    private func rxBind() {
        datasource.asDriver()
            .do(onNext: { [weak self] in
                guard let strongSelf = self else { return }
                if $0.count > 0 {
                    strongSelf.tableView.tableFooterView = nil
                }else {
                    let footerH: CGFloat = strongSelf.height - HCVerificationHeaderView_height
                    strongSelf.footerView.frame = .init(x: 0, y: 0, width: strongSelf.tableView.width, height: footerH)
                    strongSelf.tableView.tableFooterView = strongSelf.footerView
                }
            })
            .drive(tableView.rx.items(cellIdentifier: HCVerificationCell_identifier, cellType: HCVerificationCell.self)) { _, model, cell in
                cell.model = model
            }
            .disposed(by: disposeBag)
    }
}
