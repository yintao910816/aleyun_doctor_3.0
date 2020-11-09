//
//  HCRegisterPatientContainer.swift
//  HuChuangApp
//
//  Created by yintao on 2020/9/19.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class HCRegisterPatientContainer: UIView {

    private let disposeBag = DisposeBag()
    
    public var tableView: UITableView!
    public let dataSignal = PublishSubject<[HCPatientItemModel]>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView = UITableView.init(frame: frame, style: .plain)
        tableView.rowHeight = 50
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        addSubview(tableView)
        
        tableView.register(HCMyPatientListCell.self, forCellReuseIdentifier: HCMyPatientListCell_identifier)
        
        dataSignal
            .bind(to: tableView.rx.items(cellIdentifier: HCMyPatientListCell_identifier, cellType: HCMyPatientListCell.self)) { _, model, cell in
                cell.model = model
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [unowned self] in self.tableView.deselectRow(at: $0, animated: true) })
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tableView.frame = bounds
    }
}

