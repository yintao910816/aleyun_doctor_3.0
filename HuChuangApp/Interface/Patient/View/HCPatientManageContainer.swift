//
//  HCPatientManageContainer.swift
//  HuChuangApp
//
//  Created by yintao on 2020/9/18.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit
import RxSwift

class HCPatientManageContainer: UIView {

    private var listDatas: [[HCListCellItem]] = []
    private var patientInfo: HCPatientItemModel = HCPatientItemModel()
    
    private var tableView: UITableView!
    private var saveButton: UIButton!

    public let cellSelectedSignal = PublishSubject<HCListCellItem>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func reload(listDatas: [[HCListCellItem]], patientInfo: HCPatientItemModel) {
        self.listDatas = listDatas
        self.patientInfo = patientInfo
        
        tableView.reloadData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        saveButton.frame = .init(x: 0, y: height - 50, width: width, height: 50)
        tableView.frame = .init(x: 0, y: 0, width: width, height: height - 50)
    }

}

extension HCPatientManageContainer {
    
    private func initUI() {
        tableView = UITableView.init(frame: .zero, style: .grouped)
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.tableFooterView = UIView()

        saveButton = UIButton(type: .system)
        saveButton.setTitle("保存", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.titleLabel?.font = .font(fontSize: 16)
        saveButton.backgroundColor = RGB(75, 138, 239)
        
        addSubview(tableView)
        addSubview(saveButton)
                
        tableView.register(HCPatientManageHeaderView.self, forHeaderFooterViewReuseIdentifier: HCPatientManageHeaderView_identifier)
        tableView.register(HCBaseListCell.self, forCellReuseIdentifier: HCBaseListCell_identifier)
        tableView.register(HCListSwitchCell.self, forCellReuseIdentifier: HCListSwitchCell_identifier)
        tableView.register(HCListTextViewAndTitleCell.self, forCellReuseIdentifier: HCListTextViewAndTitleCell_identifier)
    }
}

extension HCPatientManageContainer: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return listDatas.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listDatas[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return listDatas[indexPath.section][indexPath.row].cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = listDatas[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: model.cellIdentifier) as! HCBaseListCell
        cell.model = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HCPatientManageHeaderView_identifier) as? HCPatientManageHeaderView
            header?.model = patientInfo
            return header
        }
        
        if section == 1 {
            let view = UIView()
            view.backgroundColor = RGB(241, 241, 241)
            return view
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return HCPatientManageHeaderView_height
        case 1:
            return 8
        default:
            return 0.01
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        cellSelectedSignal.onNext(listDatas[indexPath.section][indexPath.row])
    }
}
