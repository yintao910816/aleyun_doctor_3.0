//
//  HCEditFastReplyController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/12/27.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCEditFastReplyController: BaseViewController {

    private var container: HCEditFastReplyContainer!
    private var viewModel: HCEditFastReplyViewModel!
    
    private let pickerManager = HCImagePickerManager()

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func setupUI() {
        hiddenNavBg = true
        view.backgroundColor = .clear
        
        container = HCEditFastReplyContainer.init(frame: view.bounds)
        view.addSubview(container)
        
        container.dismissActionCallBack = { [weak self] in self?.dismiss(animated: true, completion: nil) }
        container.addCallBack = { [unowned self] in pickerManager.presentPhotoLibrary(presentVC: self) }
        container.delCallBack = { [unowned self] in viewModel.delImageSignal.onNext($0) }
        container.saveCallBack = { [unowned self] in viewModel.saveSignal.onNext($0) }

        pickerManager.selectedImageCallBack = { [unowned self] in viewModel.addImageSignal.onNext($0) }
    }
    
    override func rxBind() {
        viewModel = HCEditFastReplyViewModel()
        
        viewModel.datasource.asDriver()
            .drive(onNext: { [unowned self] in container.photoModels = $0 })
            .disposed(by: disposeBag)
        
        viewModel.popSubject
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        container.frame = view.bounds
    }
}
