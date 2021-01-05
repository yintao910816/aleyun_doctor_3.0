//
//  HCPatientHealthArchivesHeaderView.swift
//  HuChuangApp
//
//  Created by yintao on 2020/5/15.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCPatientHealthArchivesHeaderView_identifier = "HCPatientHealthArchivesHeaderView_identifier"

class HCPatientHealthArchivesHeaderView: UITableViewHeaderFooterView {

    @IBOutlet var mainContentView: UIView!
    @IBOutlet weak var titleOutlet: UILabel!
    
    public var expandChangeCallBack: ((Bool)->())?

    @IBAction func action(_ sender: UIButton) {
//        sender.isSelected = !sender.isSelected
        sender.isSelected = !model.isExpand
        expandChangeCallBack?(sender.isSelected)
    }
        
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        mainContentView = (Bundle.main.loadNibNamed("HCPatientHealthArchivesHeaderView", owner: self, options: nil)?.first as! UIView)
        contentView.addSubview(mainContentView)
        
        mainContentView.snp.makeConstraints{ $0.edges.equalTo(UIEdgeInsets.zero) }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model: HCPatientDetailSectionModel! {
        didSet {
            (viewWithTag(200) as? UIButton)?.isSelected = model.isExpand
            titleOutlet.text = model.title
        }
    }
}
