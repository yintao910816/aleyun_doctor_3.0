//
//  HCFiliterView.swift
//  HuChuangApp
//
//  Created by yintao on 2020/11/18.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCFiliterView: UIView {
    
    private var contentView: UIView!
    private var collectionView: UICollectionView!
    
    public var cellDidSelected: ((HCFiliterModel)->())?
    public var deleteCallBack: ((HCFiliterModel)->())?

    public var datasource: [HCFiliterSectionModel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        backgroundColor = RGB(10, 10, 10, 0.3)
        
        contentView = UIView()
        contentView.backgroundColor = .white
        addSubview(contentView)
        
        let layout = HCFiliterLayout()
        layout.layoutDelegate = self
        
        collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        contentView.addSubview(collectionView)
                
        collectionView.register(HCFiliterViewCell.self, forCellWithReuseIdentifier: HCFiliterViewCell_identifier)
        collectionView.register(HCFiliterViewReusableViewHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HCFiliterViewReusableViewHeader_identifier)
                
        contentView.snp.makeConstraints {
            $0.right.left.bottom.top.equalTo(0)
        }

        collectionView.snp.makeConstraints {
            $0.right.top.left.bottom.equalTo(0)
        }
    }
    
}

extension HCFiliterView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource[section].datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return datasource[indexPath.section].datas[indexPath.row].contentSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let sectionModel = datasource[section]
        return sectionModel.sectionTitle.count > 0 ? .init(width: width, height: 44) : .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: HCFiliterViewCell_identifier, for: indexPath) as! HCFiliterViewCell)
        cell.model = datasource[indexPath.section].datas[indexPath.row]
        cell.deleteCallBack = { [unowned self] in self.deleteCallBack?($0) }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionModel = datasource[indexPath.section]

        if kind == UICollectionView.elementKindSectionHeader {
            let header = (collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                          withReuseIdentifier: HCFiliterViewReusableViewHeader_identifier,
                                                                          for: indexPath) as! HCFiliterViewReusableViewHeader)
            header.configContent(title: sectionModel.sectionTitle)
            return header
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellModel = datasource[indexPath.section].datas[indexPath.row]
//        cellModel.isSelected = !cellModel.isSelected
        cellDidSelected?(cellModel)
    }
}

extension HCFiliterView: HCFiliterLayoutDelegate {
    
    func itemSize(for indexPath: IndexPath, layout: HCFiliterLayout) -> CGSize {
        return datasource[indexPath.section].datas[indexPath.row].contentSize
    }
    
    func referenceSize(forHeader insSection: Int, layout: HCFiliterLayout) -> CGSize {
        let sectionModel = datasource[insSection]
        return sectionModel.sectionTitle.count > 0 ? .init(width: collectionView.width, height: 44) : .zero
    }
    
    func minimumLineSpacing(in section: Int, layout: HCFiliterLayout) -> CGFloat {
        return 6
    }
    
    func minimumInterSpacing(in section: Int, layout: HCFiliterLayout) -> CGFloat {
        return 8
    }
    
    func sectionInset(in section: Int, layout: HCFiliterLayout) -> UIEdgeInsets {
        return .init(top: 0, left: 15, bottom: 0, right: 15)
    }
    
}

//MARK: -- HCFiliterViewCell
public let HCFiliterViewCell_identifier = "HCFiliterViewCell"
class HCFiliterViewCell: UICollectionViewCell {
    
    private var contentLabel: UILabel!
    private var deleteIcon: UIButton!
    private var longPress: UILongPressGestureRecognizer!
    
    public var deleteCallBack: ((HCFiliterModel)->())?
    
    deinit {
        PrintLog("释放了：\(self)")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentLabel = UILabel()
        contentLabel.font = .font(fontSize: 12, fontName: .PingFRegular)
        contentLabel.textColor = RGB(61, 55, 68)
        contentLabel.textAlignment = .center
        contentLabel.backgroundColor = RGB(246, 246, 246)
        contentLabel.clipsToBounds = true
                
        contentView.addSubview(contentLabel)
        
        deleteIcon = UIButton(type: .custom)
        deleteIcon.isHidden = true
        deleteIcon.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
        deleteIcon.setImage(UIImage(named: "group_icon_cross"), for: .normal)
        contentView.addSubview(deleteIcon)
        
        longPress = UILongPressGestureRecognizer.init(target: self, action: #selector(longPressedAction(long:)))
        contentView.addGestureRecognizer(longPress)
    }
    
    @objc private func longPressedAction(long: UILongPressGestureRecognizer) {
        if longPress.state == .began, model.id != "1" {
            model.isHiddenDelete = !model.isHiddenDelete
            deleteIcon.isHidden = model.isHiddenDelete
        }
    }
    
    @objc private func deleteAction() {
        deleteCallBack?(model)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var model: HCFiliterModel! {
        didSet {
            contentLabel.text = model.title
            backgroundColor = model.bgColor
            contentLabel.textColor = model.titleColor
            deleteIcon.isHidden = model.isHiddenDelete
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
                
        contentLabel.frame = .init(x: 9, y: 9, width: width - 18, height: height - 18)
        deleteIcon.frame = .init(x: contentLabel.frame.maxX - 9, y: 0, width: 18, height: 18)
        
        contentLabel.layer.cornerRadius = contentLabel.height / 2.0
    }
    
}

//MARK: -- HCFiliterViewReusableViewHeader
public let HCFiliterViewReusableViewHeader_identifier = "HCFiliterViewReusableViewHeader"
class HCFiliterViewReusableViewHeader: UICollectionReusableView {
    private var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        
        titleLabel = UILabel()
        titleLabel.font = .font(fontSize: 14, fontName: .PingFMedium)
        titleLabel.textColor = RGB(51, 51, 51)
                
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(10)
            $0.centerY.equalTo(snp.centerY)
        }
    }
    
    public func configContent(title: String) {
        titleLabel.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

