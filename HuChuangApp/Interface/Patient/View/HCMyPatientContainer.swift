
//
//  HCMyPatientContainer.swift
//  HuChuangApp
//
//  Created by yintao on 2020/9/18.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCMyPatientContainer: UIView {

    private var staticDatas: [HCListCellItem] = []
    private var patientDatas: [HCPatientItemModel] = []
    
    private var searchBar: TYSearchBar!
    private var tableView: UITableView!

    public var tapInputCallBack: (()->())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func reload(with staticDatas: [HCListCellItem], patientDatas: [HCPatientItemModel]) {
        self.staticDatas = staticDatas
        self.patientDatas = patientDatas
        
        tableView.reloadData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if #available(iOS 11.0, *) {
            searchBar.frame = .init(x: 0, y: 0, width: width, height: TYSearchBar.baseHeight + safeAreaInsets.top)
            searchBar.safeArea = safeAreaInsets
        } else {
            searchBar.frame = .init(x: 0, y: 0, width: width, height: TYSearchBar.baseHeight + 20)
            searchBar.safeArea = .init(top: 20, left: 0, bottom: 0, right: 0)
        }

        tableView.frame = .init(x: 0, y: searchBar.frame.maxY, width: width, height: height - searchBar.frame.maxY)
    }

}

extension HCMyPatientContainer {
    
    private func initUI() {
        searchBar = TYSearchBar()
        searchBar.searchPlaceholder = "搜索医院"
        searchBar.rightItemIcon = "nav_message_gray"
        searchBar.inputBackGroundColor = RGB(243, 243, 243)
        searchBar.backgroundColor = .white
        
        tableView = UITableView.init(frame: .zero, style: .grouped)
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.tableFooterView = UIView()

        addSubview(searchBar)
        addSubview(tableView)
        
        searchBar.tapInputCallBack = { [unowned self] in self.tapInputCallBack?() }
        
        tableView.register(HCMyPatientListCell.self, forCellReuseIdentifier: HCMyPatientListCell_identifier)
        tableView.register(HCBaseListCell.self, forCellReuseIdentifier: HCBaseListCell_identifier)
    }
}

extension HCMyPatientContainer: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return patientDatas.count > 0 ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return staticDatas.count
        case 1:
            return patientDatas.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return staticDatas.first?.cellHeight ?? 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: HCBaseListCell_identifier) as! HCBaseListCell
            cell.model = staticDatas[indexPath.row]
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: HCMyPatientListCell_identifier) as! HCMyPatientListCell
        cell.model = patientDatas[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 || (patientDatas.count > 0 && section == 1) {
            let view = UIView()
            view.backgroundColor = RGB(241, 241, 241)
            return view
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 || (patientDatas.count > 0 && section == 1) {
            return 8
        }
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
