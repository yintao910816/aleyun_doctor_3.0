//
//  HCFastReplyContainer.swift
//  HuChuangApp
//
//  Created by yintao on 2020/11/7.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit
import RxSwift

class HCFastReplyContainer: UIView {

    private var contentView: UIView!
    private var titleContentView: UIView!
    private var titleLabel: UILabel!
    private var rightButton: UIButton!

    private var emptyContent: UIView!
    private var emptyImgV: UIImageView!
    private var emptyLabel: UILabel!
    
    public var tableView: UITableView!
        
    public var sendActionCallBack:((HCFastReplyModel)->())?
    public var addActionCallBack:(()->())?
    public var dismissActionCallBack:(()->())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public var datas: [HCFastReplyModel] = [] {
        didSet {
            tableView.reloadData()
            
            emptyContent.isHidden = datas.count > 0
            tableView.isHidden = datas.count == 0
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleContentView.frame = .init(x: 0, y: height / 3, width: contentView.width, height: 40)
        contentView.frame = .init(x: 0,
                                  y: titleContentView.frame.maxY,
                                  width: width,
                                  height: height - titleContentView.frame.maxY)
        titleLabel.frame = .init(x: (width - 100) / 2, y: (titleContentView.height - 20) / 2, width: 100, height: 20)
        rightButton.frame = .init(x: titleContentView.width - 35 - 10,
                                  y: (titleContentView.height - 30) / 2,
                                  width: 35, height: 30)
        tableView.frame = .init(x: 0, y: 0, width: contentView.width, height: contentView.height)
        
        emptyContent.frame = .init(x: contentView.width / 4,
                                   y: (contentView.height - 170) / 2,
                                   width: contentView.width / 2,
                                   height: 170)
        emptyImgV.frame = .init(x: (emptyContent.width - 90) / 2,
                                y: 0, width: 90, height: 95)
        emptyLabel.frame = .init(x: 0, y: emptyImgV.frame.maxY + 25,
                                 width: emptyContent.width,
                                 height: 45)
        
        if titleContentView.layer.cornerRadius > 0 {
            
        }else {
            titleContentView.set(cornerRadius: 10, borderCorners: [.topLeft, .topRight])
        }
    }
}

extension HCFastReplyContainer {
        
    private func setupUI() {
        backgroundColor = .clear
        
        contentView = UIView()
        contentView.backgroundColor = .white
        
        titleContentView = UIView()
        titleContentView.backgroundColor = .white
        
        titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.text = "快捷回复"
        titleLabel.font = .font(fontSize: 16, fontName: .PingFSemibold)
        titleLabel.textColor = RGB(12, 12, 12)
        
        rightButton = UIButton()
        rightButton.setTitleColor(RGB(12, 12, 12), for: .normal)
        rightButton.setTitle("新增", for: .normal)
        rightButton.titleLabel?.font = .font(fontSize: 14, fontName: .PingFMedium)
        rightButton.addTarget(self, action: #selector(addAction), for: .touchUpInside)
        
        tableView = UITableView.init(frame: .zero, style: .plain)
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.rowHeight = HCFastReplyCell_height
        tableView.delegate = self
        tableView.dataSource = self
        
        emptyContent = UIView()
        emptyContent.backgroundColor = .white
        emptyContent.isHidden = true
        
        emptyImgV = UIImageView.init(image: UIImage.init(named: "fast_reply_empty"))
        emptyImgV.contentMode = .scaleAspectFill
        
        emptyLabel = UILabel()
        emptyLabel.textAlignment = .center
        emptyLabel.text = "没有任何快捷回复\n点击新增添加回复话语"
        emptyLabel.numberOfLines = 2
        emptyLabel.font = .font(fontSize: 16, fontName: .PingFMedium)
        emptyLabel.textColor = RGB(153, 153, 153)
        
        addSubview(contentView)
        addSubview(titleContentView)
        titleContentView.addSubview(titleLabel)
        titleContentView.addSubview(rightButton)
        
        contentView.addSubview(emptyContent)
        emptyContent.addSubview(emptyImgV)
        emptyContent.addSubview(emptyLabel)
        
        contentView.addSubview(tableView)
        
        tableView.register(HCFastReplyCell.self, forCellReuseIdentifier: HCFastReplyCell_identifier)
        
        let tapGes = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(ges:)))
        addGestureRecognizer(tapGes)
    }
    
    @objc private func addAction() {
        
    }
    
    @objc private func tapAction(ges: UITapGestureRecognizer) {
        dismissActionCallBack?()
    }
}

extension HCFastReplyContainer: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HCFastReplyCell_identifier)!
        (cell as! HCFastReplyCell).model = datas[indexPath.row]
        (cell as! HCFastReplyCell).sendActionCallBack = { [weak self] in self?.sendActionCallBack?($0) }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let moveTopAction = UITableViewRowAction.init(style: .normal, title: "上移") { (action, indexPath) in
            PrintLog("上移")
        }
        moveTopAction.backgroundColor = RGB(244, 176, 57)
        
        let deleteAction = UITableViewRowAction.init(style: .normal, title: "删除") { (action, indexPath) in
            PrintLog("删除")
        }
        deleteAction.backgroundColor = RGB(231, 93, 88)
        return [deleteAction, moveTopAction]
    }
}

extension HCFastReplyContainer: UIGestureRecognizerDelegate {
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return !contentView.frame.contains(gestureRecognizer.location(in: self))
    }
}
