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
    public let dataSignal = PublishSubject<[HCConsultListItemModel]>()
    
    public var tableView: UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tableView.frame = bounds
    }
    
}

extension HCConsultListContainer {
    
    private func initUI() {
        
        tableView = UITableView.init(frame: .zero, style: .plain)
        tableView.showsVerticalScrollIndicator = true
        tableView.separatorStyle = .none
        tableView.rowHeight = HCConsultListCell_height
        addSubview(tableView)
        
        tableView.register(HCConsultListCell.self, forCellReuseIdentifier: HCConsultListCell_identifier)
        
        bindData()
    }
    
    private func bindData() {
        
        dataSignal
            .bind(to: tableView.rx.items(cellIdentifier: HCConsultListCell_identifier, cellType: HCConsultListCell.self)) { _, model, cell in
                cell.model = model
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] in
                self?.tableView.deselectRow(at: $0, animated: true)
            })
            .disposed(by: disposeBag)
            
    }
}
