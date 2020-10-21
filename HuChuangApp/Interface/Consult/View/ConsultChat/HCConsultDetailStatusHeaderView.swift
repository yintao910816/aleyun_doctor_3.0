//
//  HCConsultDetailStatusHeaderView.swift
//  HuChuangApp
//
//  Created by yintao on 2020/5/23.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit
import RxSwift

class HCConsultDetailStatusHeaderView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var timeOutlet: UILabel!
    @IBOutlet weak var questionOutlet: UILabel!
    
    private let disposeBag = DisposeBag()
    
    public let timeObser = Variable("30:00")
    public let questionObser = Variable("1/1")

    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView = (Bundle.main.loadNibNamed("HCConsultDetailStatusHeaderView", owner: self, options: nil)?.first as! UIView)
        contentView.backgroundColor = .clear
        addSubview(contentView)
        
        timeObser.asDriver()
            .drive(timeOutlet.rx.text)
            .disposed(by: disposeBag)
        
        questionObser.asDriver()
            .drive(questionOutlet.rx.text)
            .disposed(by: disposeBag)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = bounds
    }
}
