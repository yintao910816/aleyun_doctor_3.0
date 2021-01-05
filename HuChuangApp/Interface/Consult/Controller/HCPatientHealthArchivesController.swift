//
//  HCPatientHealthArchivesController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/5/15.
//  Copyright © 2020 sw. All rights reserved.
//  健康档案

import UIKit
import RxDataSources

class HCPatientHealthArchivesController: HCSlideItemController {

    private var tableView: UITableView!

    private var datasource: [SectionModel<HCPatientDetailSectionModel, Any>] = []

    public var expandChangeCallBack: (((Bool, Int))->())?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        tableView = UITableView.init(frame: view.bounds)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)

        tableView.register(HCListDetailCell.self, forCellReuseIdentifier: HCListDetailCell_identifier)
        tableView.register(UINib.init(nibName: "HCPatientCycleCell", bundle: nil), forCellReuseIdentifier: HCPatientCycleCell_identifier)

        tableView.register(HCPatientHealthArchivesHeaderView.self, forHeaderFooterViewReuseIdentifier: HCPatientHealthArchivesHeaderView_identifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = RGB(245, 245, 245)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        tableView.frame = view.bounds
    }

    override func reloadData(data: Any?) {
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear

        if let models = data as? [SectionModel<HCPatientDetailSectionModel, Any>] {
            datasource.removeAll()
            datasource.append(contentsOf: models)
            tableView.reloadData()
        }
    }
}

extension HCPatientHealthArchivesController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        PrintLog("numberOfSections：\(datasource.count)")
        return datasource.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        PrintLog("行数：\(datasource[section].items.count)")
        return datasource[section].items.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 55 : 150
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = datasource[indexPath.section].items[indexPath.row]
        if indexPath.section == 0 {
            let tempModel = model as! HCListCellItem
            let cell = tableView.dequeueReusableCell(withIdentifier: tempModel.cellIdentifier) as! HCBaseListCell
            cell.model = tempModel
            cell.selectionStyle = .none
            return cell
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: HCPatientCycleCell_identifier) as! HCPatientCycleCell
        cell.model = (model as! HCPatientCircleModel)
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HCPatientHealthArchivesHeaderView_identifier) as! HCPatientHealthArchivesHeaderView
        header.model = datasource[section].model
        header.expandChangeCallBack = { [weak self] in self?.expandChangeCallBack?(($0, section)) }
        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
}

