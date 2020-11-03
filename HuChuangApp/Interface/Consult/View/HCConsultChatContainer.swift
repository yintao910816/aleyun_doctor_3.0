//
//  HCConsultDetailContainer.swift
//  HuChuangApp
//
//  Created by yintao on 2020/10/19.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

import RxDataSources
import RxSwift
import RxCocoa

class HCConsultChatContainer: UIView {

    private let disposeBag = DisposeBag()
    
    private var chatKeyboardView: TYChatKeyBoardView!
    private var keyboardManager = KeyboardManager()

    public var tableView: UITableView!
    
    public let dataSignal = Variable([SectionModel<HCConsultDetailItemModel, HCConsultDetailConsultListModel>]())
    /// 文字回复
    public let sendTextSubject = PublishSubject<String>()
    /// 图片回复
    public var mediaClickedCallBack:((Int)->())?
    /// 语音回复
    public let sendAudioSubject = PublishSubject<(Data, UInt)>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        keyboardManager.registerNotification()

        initUI()
        bindData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        keyboardManager.removeNotification()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        if #available(iOS 11.0, *) {
            chatKeyboardView.frame = .init(x: 0,
                                         y: height - 50 - safeAreaInsets.bottom,
                                         width: width,
                                         height: 50)
        } else {
            chatKeyboardView.frame = .init(x: 0,
                                         y: height - 50,
                                         width: width,
                                         height: 50)
        }
        
        tableView.frame = .init(x: 0, y: 0, width: width, height: chatKeyboardView.y)
        
        keyboardManager.move(coverView: chatKeyboardView, moveView: chatKeyboardView)
    }
}

extension HCConsultChatContainer {
    
    private func initUI() {
        backgroundColor = RGB(247, 247, 247)
        
        tableView = UITableView.init(frame: .zero, style: .grouped)
        tableView.backgroundColor = RGB(247, 247, 247)
        tableView.separatorStyle = .none
        addSubview(tableView)
                
        chatKeyboardView = TYChatKeyBoardView()
        addSubview(chatKeyboardView)
        chatKeyboardView.mediaClickedCallBack = { [unowned self] in self.mediaClickedCallBack?($0) }
        chatKeyboardView.sendAudioCallBack = { [unowned self] in self.sendAudioSubject.onNext($0) }
        chatKeyboardView.sendTextCallBack = { [unowned self] in self.sendTextSubject.onNext($0) }

        tableView.register(HCConsultDetailSectionHeader.self, forHeaderFooterViewReuseIdentifier: HCConsultDetailSectionHeader_identifier)
        tableView.register(HCConsultDetalCell.self, forCellReuseIdentifier: HCConsultDetalCell_identifier)
        tableView.register(HCConsultDetailPhotoCell.self, forCellReuseIdentifier: HCConsultDetailPhotoCell_identifier)
        tableView.register(HCConsultDetailTextPhotoCell.self, forCellReuseIdentifier: HCConsultDetailTextPhotoCell_identifier)
        tableView.register(HCConsultDetailTimeCell.self, forCellReuseIdentifier: HCConsultDetailTimeCell_identifier)
        tableView.register(HCConsultDetailAudioCell.self, forCellReuseIdentifier: HCConsultDetailAudioCell_identifier)
    }
    
    private func bindData() {
        let datasource = RxTableViewSectionedReloadDataSource<SectionModel<HCConsultDetailItemModel, HCConsultDetailConsultListModel>>.init(configureCell: { _,tb,indexPath,model ->UITableViewCell in
            let cell = tb.dequeueReusableCell(withIdentifier: model.cellIdentifier) as! HCBaseConsultCell
            cell.model = model
            cell.contentBgTagCallBack = {
                AudioPlayHelper.share.prepare(with: $0.fileList.first ?? "")
            }
            return cell
        })

        dataSignal.asDriver()
            .drive(tableView.rx.items(dataSource: datasource))
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}

extension HCConsultChatContainer: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HCConsultDetailSectionHeader_identifier) as! HCConsultDetailSectionHeader
        header.sectionModel = dataSignal.value[section].model
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return dataSignal.value[section].model.getSectionHeaderSize.height
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataSignal.value[indexPath.section].items[indexPath.row].getCellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }

}
