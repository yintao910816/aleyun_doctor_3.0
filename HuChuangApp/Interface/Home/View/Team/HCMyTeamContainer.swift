//
//  HCMyTeamContainer.swift
//  HuChuangApp
//
//  Created by sw on 2021/2/4.
//  Copyright © 2021 sw. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa
import RxDataSources

class HCMyTeamContainer: UIView {

    private let disposeBag = DisposeBag()
    
    public var tableView: UITableView!
    public var addMemberButton: UIButton!
    
    public let errorSingle = PublishSubject<String>()
    public let datasource = Variable([HCTeamItemModel]())
    public let deleteSignal = PublishSubject<String>()
    
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
        
        addMemberButton.frame = .init(x: 0, y: height - 49, width: width, height: 49)
        tableView.frame = .init(x: 0, y: 0, width: width, height: height - 49)
    }
}

extension HCMyTeamContainer {
    
    private func setupUI() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.rowHeight = HCTeamCell_height
        tableView.dataSource = self
        tableView.delegate = self
        
        addMemberButton = UIButton()
        addMemberButton.setTitle("立即添加", for: .normal)
        addMemberButton.setTitleColor(.white, for: .normal)
        addMemberButton.backgroundColor = HC_MAIN_COLOR
        addMemberButton.titleLabel?.font = .font(fontSize: 16)
        
        addSubview(tableView)
        addSubview(addMemberButton)
        
        tableView.register(HCTeamCell.self, forCellReuseIdentifier: HCTeamCell_identifier)
    }
    
    private func rxBind() {
        errorSingle
            .subscribe(onNext: { [weak self] in
                let errorView = HCListEmptyView(frame: .init(x: 0, y: 0, width: self?.width ?? 0, height: 320))
                errorView.config(image: UIImage(named: "remind_limit"), remindText: $0)
                self?.tableView.tableFooterView = errorView
            })
            .disposed(by: disposeBag)
        
        datasource.asDriver()
            .skip(1)
            .do(onNext: { [weak self] in
                if $0.count == 0 {
                    let errorView = HCListEmptyView(frame: .init(x: 0, y: 0, width: self?.width ?? 0, height: 320))
                    errorView.config(image: UIImage(named: "remind_no_member"), remindText: "暂无成员，请立即添加")
                    self?.tableView.tableFooterView = errorView
                }else {
                    self?.tableView.tableFooterView = nil
                }
            })
            .drive(onNext: { [weak self] _ in self?.tableView.reloadData() })
            .disposed(by: disposeBag)
    }
}

extension HCMyTeamContainer: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HCTeamCell_identifier) as! HCTeamCell
        cell.mode = .myTeam
        cell.model = datasource.value[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        deleteSignal.onNext(datasource.value[indexPath.row].userId)
    }
}
