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

    private let pickerManager = HCImagePickerManager()
    
    public var viewModel: HCConsultChatViewModel!

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
        
        viewModel.waitTimeSignal
            .subscribe(onNext: { [weak self] in self?.container.chatStatusView.isExpire = $0 })
            .disposed(by: disposeBag)

        viewModel.getUerInfoSubject
            .subscribe(onNext: { [weak self] in self?.presentVideoCallCtrl(callUser: $0) })
            .disposed(by: disposeBag)
        
        container.sendTextSubject
            .bind(to: viewModel.sendTextSubject)
            .disposed(by: disposeBag)
        
        container.sendAudioSubject
            .bind(to: viewModel.sendAudioSubject)
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
        
        pickerManager.selectedImageCallBack = { [weak self] in
            if $0 != nil {
                self?.viewModel.sendImageSubject.onNext($0!)
            }
        }
//        container.tableView.prepare(viewModel, showFooter: false, showHeader: true)
    }
    
    @objc private func presentMediaCtrol() {
        let pickerContrl = HCMediaPickerController()
        pickerContrl.pickerMenuData = HCPickerMenuSectionModel.createChatPicker()
        self.model(for: pickerContrl, controllerHeight: self.view.height)
        
        pickerContrl.selectedMenu = { [unowned self] in
            switch $0.title {
            case "快捷回复":
                presentFastReplyCtrl()
            case "相册":
                pickerManager.presentPhotoLibrary(presentVC: self)
            case "拍摄":
                pickerManager.presentCamera(presentVC: self)
            case "视频通话":
                viewModel.requestUserInfoSubject.onNext(Void())
            default:
                break
            }
        }
        
        pickerContrl.selectedImage = { [unowned self] in self.viewModel.sendImageSubject.onNext($0) }
    }
    
    private func presentFastReplyCtrl() {
        let presentCtrl = MainNavigationController.init(rootViewController: HCFastReplyController())
        presentCtrl.view.backgroundColor = .clear
        model(for: presentCtrl, controllerHeight: view.size.height)
    }
    
    private func presentVideoCallCtrl(callUser: CallingUserModel) {
        let callVC = HCConsultVideoCallController(sponsor: nil)
        
        callVC.dismissBlock = { }
        
        callVC.modalPresentationStyle = .fullScreen
        callVC.resetWithUserList(users: [callUser], isInit: true)
        present(callVC, animated: true, completion: nil)
        
        TRTCCalling.shareInstance().call(memberId, roomId: UInt32(consultId) ?? 0, type: .video)
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
