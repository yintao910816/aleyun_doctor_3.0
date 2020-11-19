//
//  HCEditInfoViewController.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/13.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

enum HCEditMode {
    /// 昵称
    case nickName
    /// 患者别名
    case alias
}

class HCEditInfoViewController: BaseViewController {

    private var containerView: HCEditInfoContainer!

    private var viewModel: HCEditInfoViewModel!
    private var mode: HCEditMode = .nickName
    private var content: String?
    
    override func setupUI() {
        switch mode {
        case .nickName:
            title = "修改昵称"
        case .alias:
            title = "修改别名"
        }
        
        containerView = HCEditInfoContainer.init(frame: .init(x: 0, y: 0, width: view.width, height: view.height))
        view.addSubview(containerView)
    }
    
    override func rxBind() {
        let commitSignal = addBarItem(title: "完成", titleColor: HC_MAIN_COLOR, right: true)
            .do(onNext: { [unowned self] in
                self.containerView.endEditing(true)
            })

        viewModel = HCEditInfoViewModel(inputSignal: containerView.textField.rx.text.orEmpty.asDriver(),
                                        commitSignal: commitSignal,
                                        mode: mode)
                
        viewModel.enableSignal
            .subscribe(onNext: { [unowned self] in
                let button = self.navigationItem.rightBarButtonItem?.customView as? UIButton
                if $0 == true {
                    button?.setTitleColor(HC_MAIN_COLOR, for: .normal)
                }else {
                    button?.setTitleColor(RGB(182, 182, 182), for: .normal)
                }
                button?.isUserInteractionEnabled = $0
            })
            .disposed(by: disposeBag)
                    
        viewModel.contentSignal
            .bind(to: containerView.textField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.popSubject
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
        
        containerView.textField.text = content
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        containerView.frame = view.bounds
    }
    
    override func prepare(parameters: [String : Any]?) {
        mode = parameters!["mode"] as! HCEditMode
        content = parameters?["content"] as? String
    }
}
