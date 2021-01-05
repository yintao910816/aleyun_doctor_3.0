//
//  HCAccountSettingContainer.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/13.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCAccountSettingContainer: UIView {

    private var listData: [[HCListCellItem]] = []
    private var tableView: UITableView!
    
    public var saveButton: UIButton!

    public var didSelected: ((HCListCellItem)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func reloadData(data: [[HCListCellItem]]) {
        listData = data
        tableView.reloadData()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        tableView.frame = .init(x: 0, y: 0, width: width, height: height - 49)
        saveButton.frame = .init(x: 0, y: tableView.frame.maxY, width: width, height: 49)
    }
}

extension HCAccountSettingContainer {
    
    private func initUI() {
        tableView = UITableView.init(frame: bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false

        saveButton = UIButton()
        saveButton.setTitle("保存", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.titleLabel?.font = .font(fontSize: 16)
        saveButton.backgroundColor = HC_MAIN_COLOR
        
        tableView.register(HCListDetailCell.self, forCellReuseIdentifier: HCListDetailCell_identifier)
        tableView.register(HCListDetailIconCell.self, forCellReuseIdentifier: HCListDetailIconCell_identifier)
        tableView.register(HCListTextViewAndTitleCell.self, forCellReuseIdentifier: HCListTextViewAndTitleCell_identifier)

        addSubview(tableView)
        addSubview(saveButton)
    }
}

extension HCAccountSettingContainer: UITableViewDelegate, UITableViewDataSource {
           
    func numberOfSections(in tableView: UITableView) -> Int {
        return listData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return listData[indexPath.section][indexPath.row].cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = listData[indexPath.section][indexPath.row]
        let cell = (tableView.dequeueReusableCell(withIdentifier: model.cellIdentifier) as! HCBaseListCell)
        cell.model = model
        return cell
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section < listData.count - 1 {
            let view = UIView()
            view.backgroundColor = RGB(247, 247, 247)
            return view
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return (section < listData.count - 1) ? 8 : 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        didSelected?(listData[indexPath.section][indexPath.row])
    }
    
}
