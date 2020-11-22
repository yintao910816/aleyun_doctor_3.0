//
//  HCHideMembersContainer.swift
//  HuChuangApp
//
//  Created by yintao on 2020/11/19.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit
import RxSwift

class HCHideMembersContainer: UIView {

    private let disposeBag = DisposeBag()
    public var tableView: UITableView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = RGB(247, 247, 247)
        
        tableView = UITableView.init(frame: .init(x: 0, y: 10, width: width, height: height - 10), style: .plain)
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.rowHeight = 50

        addSubview(tableView)
        
        tableView.register(HCMyPatientListCell.self, forCellReuseIdentifier: HCMyPatientListCell_identifier)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [unowned self] in self.tableView.deselectRow(at: $0, animated: true) })
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        tableView.frame = .init(x: 0, y: 10, width: width, height: height - 10)
    }

}
