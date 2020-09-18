//
//  HCPatientGroupContainer.swift
//  HuChuangApp
//
//  Created by yintao on 2020/9/18.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCPatientGroupContainer: UIView {

    public var tableView: UITableView!

    public var didSelectedCallBack: ((HCPatientGroupListItemModel)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    public var groupDatas: [HCPatientGroupListModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tableView.frame = bounds
    }

}

extension HCPatientGroupContainer {

    private func initUI() {
        tableView = UITableView.init(frame: .zero, style: .grouped)
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.tableFooterView = UIView()

        addSubview(tableView)
                
        tableView.register(HCPatientGroupHeaderView.self, forHeaderFooterViewReuseIdentifier: HCPatientGroupHeaderView_identifier)
        tableView.register(HCMyPatientListCell.self, forCellReuseIdentifier: HCMyPatientListCell_identifier)
    }
}

extension HCPatientGroupContainer: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return groupDatas.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let model = groupDatas[section]
        return model.isExpand ? model.memberList.count : 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HCMyPatientListCell_identifier) as! HCMyPatientListCell
        cell.groupPatientModel = groupDatas[indexPath.section].memberList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HCPatientGroupHeaderView_identifier) as? HCPatientGroupHeaderView
        header?.model = groupDatas[section]
        header?.expandAction = { [weak self] in self?.tableView.reloadData() }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return HCPatientGroupHeaderView_height
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        didSelectedCallBack?(groupDatas[indexPath.section].memberList[indexPath.row])
    }
}
