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
    
//    private var keyboardManager = HCKeyBoardManager()

    public var chatStatusView: HCConsultChatStatusView!
        
    public var tableView: UITableView!
    
    public let dataSignal = Variable([SectionModel<HCChatDataModel, HCChatListModel>]())
    /// 文字回复
    public let sendTextSubject = PublishSubject<String>()
    /// 图片回复
    public var mediaClickedCallBack:((Int)->())?
    /// 语音回复
    public let sendAudioSubject = PublishSubject<(Data, UInt)>()
    /// 点击输入框右边多功能按钮
    public var clickedFuncCallBack:(()->())?
    /// 咨询退回
    public let cancelSignal = PublishSubject<Void>()

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
    
    public lazy var startConsultView: HCConsultSettingBottomActionView = {
        let view = HCConsultSettingBottomActionView()
        view.setTitle(leftTitle: "退回", rightTitle: "开始接诊")
        view.actionCallBack = { [unowned self] in
            if $0 == .save {
                self.startConsultView.removeFromSuperview()
            }else if $0 == .close {
                self.cancelSignal.onNext(Void())
            }
        }
        return view
    }()

    deinit {
//        keyboardManager.removeNotification()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        

        initUI()
        bindData()
        
//        keyboardManager.prepare(containerView: self, inputView: chatKeyboardView, moveView: self)
//        keyboardManager.registerNotification()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var consultStatus: HCOrderDetailStatus = .unknow {
        didSet {
            switch consultStatus {
            case .finish, .cancel:
                chatKeyboardView.removeFromSuperview()
                if startConsultView.superview != nil {
                    startConsultView.removeFromSuperview()
                }
                setNeedsLayout()
                layoutIfNeeded()
            case .unReplay:
                addSubview(chatKeyboardView)
                addSubview(startConsultView)
                setNeedsLayout()
                layoutIfNeeded()
            case .replay:
                if startConsultView.superview != nil {
                    startConsultView.removeFromSuperview()
                }
                addSubview(chatKeyboardView)
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
            
            if consultStatus == .unReplay {
                startConsultView.frame = chatKeyboardView.frame
            }
            
            tableView.frame = .init(x: 0,
                                    y: chatStatusView.frame.maxY,
                                    width: width,
                                    height: chatKeyboardView.y - chatStatusView.frame.maxY)
        case .finish, .cancel:
            tableView.frame = .init(x: 0,
                                    y: chatStatusView.frame.maxY,
                                    width: width,
                                    height: height - chatStatusView.frame.maxY)
        default:
            break
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
        tableView.register(HCConsultEndCell.self, forCellReuseIdentifier: HCConsultEndCell_identifier)
    }
    
    private func bindData() {
        let datasource = RxTableViewSectionedReloadDataSource<SectionModel<HCChatDataModel, HCChatListModel>>.init(configureCell: { _,tb,indexPath,model ->UITableViewCell in
            let cell = tb.dequeueReusableCell(withIdentifier: model.cellIdentifier) as! HCBaseConsultCell
            cell.model = model
            cell.contentBgTagCallBack = { [weak self] in
                AudioPlayHelper.share.prepare(with: $0.content)
            }
            return cell
        })

        dataSignal.asDriver()
            .do(onNext: { [weak self] in
                guard let sectionModel = $0.last?.model else { return }
                self?.consultStatus = sectionModel.mainInfo.statusMode
                self?.chatStatusView.sectionModel = sectionModel.mainInfo
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
        header.sectionModel = dataSignal.value[section].model.mainInfo
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return dataSignal.value[section].model.mainInfo.getSectionHeaderSize.height
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataSignal.value[indexPath.section].items[indexPath.row].getCellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }

}
