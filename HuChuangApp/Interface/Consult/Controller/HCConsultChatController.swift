//
//  HCConsultDetailController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/10/19.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCConsultChatController: HCSlideItemController {
    
    private var container: HCConsultChatContainer!
    
    private var memberId: String = ""
    private var consultId: String = ""

    private var viewModel: HCConsultChatViewModel!

    override func setupUI() {        
        container = HCConsultChatContainer.init(frame: view.bounds)
        view.addSubview(container)

        container.mediaClickedCallBack = { [weak self] _ in self?.systemPic() }
        container.clickedFuncCallBack = {
            HCAssetManager.checkPhotoLibrary { [weak self] in
                if $0 {
                    self?.presentMediaCtrol()
                }else {
                    NoticesCenter.alert(message: "未开启相册权限,请到设置中开启")
                }
            }
        }
    }
    
    override func rxBind() {
        viewModel = HCConsultChatViewModel(memberId: memberId, consultId: consultId)
        
        viewModel.datasource.asDriver()
            .drive(container.dataSignal)
            .disposed(by: disposeBag)
        
        container.sendTextSubject
            .bind(to: viewModel.sendTextSubject)
            .disposed(by: disposeBag)
        
        container.sendAudioSubject
            .bind(to: viewModel.sendAudioSubject)
            .disposed(by: disposeBag)

        viewModel.reloadSubject.onNext(Void())
//        container.tableView.prepare(viewModel, showFooter: false, showHeader: true)
    }
    
    @objc private func presentMediaCtrol() {
        let pickerContrl = HCMediaPickerController()
        pickerContrl.pickerMenuData = HCPickerMenuSectionModel.createChatPicker()
        self.model(for: pickerContrl, controllerHeight: self.view.height)
        
        pickerContrl.selectedMenu = { [unowned self] in
            switch $0.title {
            case "快捷回复":
                break
            case "相册":
                break
            case "拍摄":
                break
            case "视频通话":
                break
            default:
                break
            }
        }
        
        pickerContrl.selectedImage = { [unowned self] in self.viewModel.sendImageSubject.onNext($0) }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        container.frame = view.bounds
    }
    
    override func prepare(parameters: [String : Any]?) {
        memberId = parameters!["memberId"] as! String
        consultId = parameters!["consultId"] as! String
    }
}

//MARK: - 选择图片
extension HCConsultChatController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func systemPic(){
        let systemPicVC = UIImagePickerController()
        systemPicVC.sourceType = UIImagePickerController.SourceType.photoLibrary
        systemPicVC.delegate = self
        systemPicVC.allowsEditing = true
        UIApplication.shared.keyWindow?.rootViewController?.present(systemPicVC, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            viewModel.sendImageSubject.onNext(img)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
