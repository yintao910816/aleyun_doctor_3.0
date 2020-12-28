//
//  HCEditFastReplyContainer.swift
//  HuChuangApp
//
//  Created by yintao on 2020/12/27.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCEditFastReplyContainer: UIView {

    private var colorBg: UIView!
    private var contentView: UIView!
    private var titleContentView: UIView!
    private var titleLabel: UILabel!
    private var rightButton: UIButton!
    
    private var markLabel: UILabel!
    private var markTf: UITextField!
    
    private var remindLabel: UILabel!
    private var remindTextView: PlaceholderTextView!
    
    private var photoRemindLabel: UILabel!
    private var photoView: HCPhotoSelectedView!
    
    private var saveButton: UIButton!

    public var dismissActionCallBack:(()->())?
    public var delCallBack: ((IndexPath)->())?
    public var addCallBack: (()->())?
    public var saveCallBack: (((String?, String?))->())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var photoModels: [HCPhotoViewModel] = [] {
        didSet {
            photoView.datasource = photoModels
        }
    }
    
    public var replyModel: HCFastReplyModel? {
        didSet {
            markTf.text = replyModel?.title
            remindTextView.text = replyModel?.content
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let conentH: CGFloat = 400
        colorBg.frame = .init(x: 0, y: height - conentH, width: width, height: conentH)

        //
        titleContentView.frame = .init(x: 0, y: 0, width: contentView.width, height: 40)
        contentView.frame = .init(x: 0, y: titleContentView.frame.maxY,
                                  width: width,
                                  height: colorBg.height - titleContentView.frame.maxY)
        titleLabel.frame = .init(x: (width - 100) / 2, y: (titleContentView.height - 20) / 2, width: 100, height: 20)
        rightButton.frame = .init(x: titleContentView.width - 35 - 10,
                                  y: (titleContentView.height - 30) / 2,
                                  width: 35, height: 30)
        titleContentView.viewWithTag(100)?.frame = .init(x: 0, y: titleContentView.height - 0.5, width: titleContentView.width, height: 0.5)
        
        //
        markLabel.frame = .init(x: 12, y: 10, width: 30, height: 16)
        markTf.frame = .init(x: contentView.width - 12 - 100, y: 7, width: 100, height: 25)
        contentView.viewWithTag(101)?.frame = .init(x: 0, y: markLabel.frame.maxY + 10, width: contentView.width, height: 0.5)
        
        //
        remindLabel.frame = .init(x: markLabel.x, y: markLabel.frame.maxY + 20, width: 170, height: 16)
        remindTextView.frame = .init(x: remindLabel.x, y: remindLabel.frame.maxY + 10, width: contentView.width - remindLabel.x * 2, height: 100)
        
        //
        photoRemindLabel.frame = .init(x: markLabel.x, y: remindTextView.frame.maxY + 10, width: 60, height: 16)
        photoView.frame = .init(x: photoRemindLabel.x, y: photoRemindLabel.frame.maxY + 10, width: contentView.width - photoRemindLabel.x * 2, height: 70)
        
        //
        saveButton.frame = .init(x: markLabel.x, y: photoView.frame.maxY + 10, width: contentView.width - markLabel.x * 2, height: 40)
        
        if titleContentView.layer.cornerRadius > 0 {
            
        }else {
            titleContentView.set(cornerRadius: 10, borderCorners: [.topLeft, .topRight])
        }
    }
}

extension HCEditFastReplyContainer {
    
    private func setupUI() {
        colorBg = UIView()
        colorBg.backgroundColor = .clear

        contentView = UIView()
        contentView.backgroundColor = .white
        
        titleContentView = UIView()
        titleContentView.backgroundColor = .white
        
        titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.text = "内容编辑"
        titleLabel.font = .font(fontSize: 16, fontName: .PingFSemibold)
        titleLabel.textColor = RGB(12, 12, 12)
        
        rightButton = UIButton()
        rightButton.setImage(UIImage(named: "close"), for: .normal)
        rightButton.addTarget(self, action: #selector(actions(button:)), for: .touchUpInside)
        
        let line1 = UIView()
        line1.backgroundColor = RGB(241, 241, 241)
        line1.tag = 100
        
        //
        markLabel = UILabel()
        markLabel.textColor = RGB(12, 12, 12)
        markLabel.font = .font(fontSize: 14)
        markLabel.text = "备注"
        
        markTf = UITextField()
        markTf.placeholder = "请输入备注"
        markTf.textColor = RGB(12, 12, 12)
        markTf.font = .font(fontSize: 14)
        markTf.textAlignment = .right
        markTf.borderStyle = .none
        
        let line2 = UIView()
        line2.backgroundColor = RGB(241, 241, 241)
        line2.tag = 101
        
        //
        remindLabel = UILabel()
        remindLabel.textColor = RGB(12, 12, 12)
        remindLabel.font = .font(fontSize: 14)
        remindLabel.text = "请输入快捷回复话语/链接"
        
        remindTextView = PlaceholderTextView()
        remindTextView.backgroundColor = RGB(247, 247, 247)
        remindTextView.contentInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        remindTextView.placeholder = "例如：您好！我是XX医生，本次回复是想了解您最近的身体情况，是否恢复了？还有什么不适的感觉，您可以给我进行留言 https://www.baidu.com/tn=78000241_5_hao_pg"
        remindTextView.font = .font(fontSize: 14, fontName: .PingFMedium)
        remindTextView.textColor = RGB(12, 12, 12)
        remindTextView.layer.cornerRadius = 10
        remindTextView.clipsToBounds = true

        //
        photoRemindLabel = UILabel()
        photoRemindLabel.textColor = RGB(12, 12, 12)
        photoRemindLabel.font = .font(fontSize: 14)
        photoRemindLabel.text = "添加照片"
        
        photoView = HCPhotoSelectedView()
        photoView.delCallBack = { [unowned self] in delCallBack?($0) }
        photoView.addCallBack = { [unowned self] in addCallBack?() }
        
        saveButton = UIButton()
        saveButton.backgroundColor = RGB(75, 138, 239)
        saveButton.setTitle("保存", for: .normal)
        saveButton.titleLabel?.font = .font(fontSize: 14)
        saveButton.layer.cornerRadius =  5
        saveButton.clipsToBounds = true
        saveButton.addTarget(self, action: #selector(actions(button:)), for: .touchUpInside)

        addSubview(colorBg)
        colorBg.addSubview(titleContentView)
        colorBg.addSubview(contentView)
        
        titleContentView.addSubview(titleLabel)
        titleContentView.addSubview(rightButton)
        titleContentView.addSubview(line1)

        contentView.addSubview(markLabel)
        contentView.addSubview(markTf)
        contentView.addSubview(line2)

        contentView.addSubview(remindLabel)
        contentView.addSubview(remindTextView)
        
        contentView.addSubview(photoRemindLabel)
        contentView.addSubview(photoView)
        
        contentView.addSubview(saveButton)

        let tapGes = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(ges:)))
        tapGes.delegate = self
        addGestureRecognizer(tapGes)
    }
    
    @objc private func actions(button: UIButton) {
        if button == rightButton {
            dismissActionCallBack?()
        }else if button == saveButton {
            saveCallBack?((markTf.text, remindTextView.text))
        }
    }
    
    @objc private func tapAction(ges: UITapGestureRecognizer) {
        dismissActionCallBack?()
    }
}

extension HCEditFastReplyContainer: UIGestureRecognizerDelegate {
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return !colorBg.frame.contains(gestureRecognizer.location(in: self))
    }
}
