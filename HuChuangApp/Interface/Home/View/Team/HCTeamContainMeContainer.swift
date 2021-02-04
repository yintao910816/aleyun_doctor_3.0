//
//  HCTeamContainMeContainer.swift
//  HuChuangApp
//
//  Created by sw on 2021/2/4.
//  Copyright © 2021 sw. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa
import RxDataSources

class HCTeamContainMeContainer: UIView {

    private let disposeBag = DisposeBag()

    public var tableView: UITableView!

    public let datasource = Variable([HCTeamItemModel]())

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

extension HCTeamContainMeContainer {
    
    private func setupUI() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.rowHeight = HCTeamCell_height
        
        addSubview(tableView)
        
        tableView.register(HCTeamCell.self, forCellReuseIdentifier: HCTeamCell_identifier)
    }
    
    private func rxBind() {
        
        datasource.asDriver()
            .skip(1)
            .do(onNext: { [weak self] in
                if $0.count == 0 {
                    let errorView = HCListEmptyView(frame: .init(x: 0, y: 0, width: self?.width ?? 0, height: 320))
                    errorView.config(image: UIImage(named: "remind_no_team"), remindText: "暂未加入其它团队")
                    self?.tableView.tableFooterView = errorView
                }else {
                    self?.tableView.tableFooterView = nil
                }
            })
            .drive(tableView.rx.items(cellIdentifier: HCTeamCell_identifier, cellType: HCTeamCell.self)) { _, model, cell in
                cell.mode = .teamContainMe
                cell.model = model
            }
            .disposed(by: disposeBag)
    }
}
