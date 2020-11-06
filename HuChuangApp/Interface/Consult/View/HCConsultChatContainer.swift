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
    
    private var keyboardManager = KeyboardManager()

    private var chatStatusView: HCConsultChatStatusView!
    
    public var tableView: UITableView!
    
    public let dataSignal = Variable([SectionModel<HCConsultDetailItemModel, HCConsultDetailConsultListModel>]())
    /// 文字回复
    public let sendTextSubject = PublishSubject<String>()
    /// 图片回复
    public var mediaClickedCallBack:((Int)->())?
    /// 语音回复
    public let sendAudioSubject = PublishSubject<(Data, UInt)>()
    /// 点击输入框右边多功能按钮
    public var clickedFuncCallBack:(()->())?

    private lazy var chatKeyboardView: TYChatKeyBoardView = {
        let view = TYChatKeyBoardView()
        
        view.mediaClickedCallBack = { [unowned self] in self.mediaClickedCallBack?($0) }
        view.sendAudioCallBack = { [unowned self] in self.sendAudioSubject.onNext($0) }
        view.sendTextCallBack = { [unowned self] in self.sendTextSubject.onNext($0) }
        view.clickedFuncCallBack = { [unowned self] in self.clickedFuncCallBack?() }
        return view
    }()
    
    private lazy var publicViewContent: UIView = {
        let view = UIView()
        view.backgroundColor = RGB(75, 138, 239)
        
        let button = UIButton()
        button.backgroundColor = RGB(75, 138, 239)
        button.tag = 100
        button.setTitle("公开展示", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .font(fontSize: 16, fontName: .PingFSemibold)
        button.addTarget(self, action: #selector(publicViewAction), for: .touchUpInside)
        view.addSubview(button)
        
        return view
    }()

    deinit {
        keyboardManager.removeNotification()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        keyboardManager.registerNotification()

        initUI()
        bindData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var consultStatus: HCOrderDetailStatus = .unknow {
        didSet {
            switch consultStatus {
            case .replay, .unReplay:
                publicViewContent.removeFromSuperview()
                addSubview(chatKeyboardView)
                setNeedsLayout()
                layoutIfNeeded()
            case .finish:
                chatKeyboardView.removeFromSuperview()
                addSubview(publicViewContent)
                setNeedsLayout()
                layoutIfNeeded()
            default:
                break
            }
        }
    }
    
    @objc private func publicViewAction() {
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        chatStatusView.frame = .init(x: 0, y: 0, width: width, height: 45)
        
        switch consultStatus {
        case .replay, .unReplay:
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
            
            tableView.frame = .init(x: 0,
                                    y: chatStatusView.frame.maxY,
                                    width: width,
                                    height: chatKeyboardView.y - chatStatusView.frame.maxY)
        case .finish:
            if #available(iOS 11.0, *) {
                publicViewContent.frame = .init(x: 0,
                                             y: height - 50 - safeAreaInsets.bottom,
                                             width: width,
                                             height: 50 + safeAreaInsets.bottom)
            } else {
                publicViewContent.frame = .init(x: 0,
                                             y: height - 50,
                                             width: width,
                                             height: 50)
            }
            publicViewContent.viewWithTag(100)?.frame = .init(x: 0, y: 0, width: publicViewContent.width, height: 50)
            
            tableView.frame = .init(x: 0,
                                    y: chatStatusView.frame.maxY,
                                    width: width,
                                    height: publicViewContent.y - chatStatusView.frame.maxY)
        default:
            tableView.frame = .init(x: 0,
                                    y: chatStatusView.frame.maxY,
                                    width: width,
                                    height: height - chatStatusView.frame.maxY)
        }
        
        if chatKeyboardView.superview != nil {
            keyboardManager.move(coverView: chatKeyboardView, moveView: chatKeyboardView)
        }
    }
}

extension HCConsultChatContainer {
    
    private func initUI() {
        backgroundColor = RGB(247, 247, 247)
        
        chatStatusView = HCConsultChatStatusView()
        
        tableView = UITableView.init(frame: .zero, style: .grouped)
        tableView.backgroundColor = RGB(247, 247, 247)
        tableView.separatorStyle = .none
        
        addSubview(tableView)
        addSubview(chatStatusView)
                
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
            .do(onNext: { [weak self] in
                self?.consultStatus = $0.last?.model.status ?? .unknow
                self?.chatStatusView.sectionModel = $0.last?.model
            })
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
