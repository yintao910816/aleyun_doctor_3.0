//
//  HCAddTeamMemberContainer.swift
//  HuChuangApp
//
//  Created by sw on 2021/2/4.
//  Copyright © 2021 sw. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa
import RxDataSources

class HCAddTeamMemberContainer: UIView {
    private let disposeBag = DisposeBag()

    public var searchBar: TYSearchBar!
    public var tableView: UITableView!
    public var addMemberButton: UIButton!

    public let datasource = Variable([HCTeamItemModel]())

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
        rxBind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        searchBar.frame = .init(x: 0, y: 0, width: width, height: 35 + 20)
        addMemberButton.frame = .init(x: 0, y: height - 49, width: width, height: 49)

        tableView.frame = .init(x: 0, y: searchBar.frame.maxY, width: width, height: addMemberButton.y - searchBar.frame.maxY)
    }
}

extension HCAddTeamMemberContainer {
    
    private func initUI() {
        searchBar = TYSearchBar()
        searchBar.coverButtonEnable = false
        searchBar.hasBottomLine = true
        searchBar.viewConfig = TYSearchBarConfig.createAddMemberList()
        searchBar.backgroundColor = .white

        tableView = UITableView.init(frame: .zero, style: .plain)
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = HCTeamCell_height

        addMemberButton = UIButton()
        addMemberButton.setTitle("确认添加", for: .normal)
        addMemberButton.setTitleColor(.white, for: .normal)
        addMemberButton.backgroundColor = HC_MAIN_COLOR
        addMemberButton.titleLabel?.font = .font(fontSize: 16)

        addSubview(searchBar)
        addSubview(tableView)
        addSubview(addMemberButton)

        tableView.register(HCTeamCell.self, forCellReuseIdentifier: HCTeamCell_identifier)
    }

    private func rxBind() {        
        datasource.asDriver()
            .drive(tableView.rx.items(cellIdentifier: HCTeamCell_identifier, cellType: HCTeamCell.self)) { _, model, cell in
                cell.mode = .addMember
                cell.model = model
            }
            .disposed(by: disposeBag)
    }

}
