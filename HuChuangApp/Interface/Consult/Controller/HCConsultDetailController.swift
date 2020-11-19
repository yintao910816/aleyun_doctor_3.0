//
//  HCPatientDetailController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/5/15.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCConsultDetailController: BaseViewController {

    private var viewModel: HCPatientDetailViewModel!
    
    private var slideCtrl: TYSlideMenuController!
    private let consultChatCtrl = HCConsultChatController()
    private let healthArchivesCtrl = HCPatientHealthArchivesController()
    private let manageCtrl = HCPatientManageController()

    private var consultItemModel: HCConsultListItemModel!
    private var navTitle: String?

    override func setupUI() {
        navigationItem.title = "\(consultItemModel.memberName)(\(HCGender(rawValue: consultItemModel.sex)?.genderText ?? "男"))"
        
        slideCtrl = TYSlideMenuController()
        addChild(slideCtrl)
        view.addSubview(slideCtrl.view)
        
        slideCtrl.pageScroll = { [weak self] page in
            
        }

        healthArchivesCtrl.expandChangeCallBack = { [weak self] in
            self?.viewModel.healthArchivesExpand.onNext($0)
        }
        
        slideCtrl.menuItems = TYSlideItemModel.creatModel(for: ["咨询记录", "健康档案", "患者管理"])
        consultChatCtrl.prepare(parameters: ["memberId":consultItemModel.memberId, "consultId":consultItemModel.id])
        manageCtrl.prepare(parameters: ["model": consultItemModel.transformToPatientItem()])
        slideCtrl.menuCtrls = [consultChatCtrl,
                               healthArchivesCtrl,
                               manageCtrl]
    }
    
    override func rxBind() {
        viewModel = HCPatientDetailViewModel(memberId: consultItemModel.memberId)
        
        viewModel.consultRecordData.asDriver()
            .drive(onNext: { [weak self] in
                self?.consultChatCtrl.reloadData(data: $0)
            })
            .disposed(by: disposeBag)
        
        viewModel.manageData.asDriver()
            .drive(onNext: { [weak self] in
                self?.manageCtrl.reloadData(data: $0)
            })
            .disposed(by: disposeBag)
        
        viewModel.healthArchivesData.asDriver()
            .drive(onNext: { [weak self] in
                self?.healthArchivesCtrl.reloadData(data: $0)
            })
            .disposed(by: disposeBag)
        
//        consultRecordCtrl.operationCallBack = { [unowned self] in
//            switch $0.0 {
//            case .back:
//                break
//            case .supplementAsk:
//                break
//            case .reply:
//                break
//            case .supplementReply:
//                break
//            case .view:
//                break
//            }
//        }
        
//        consultRecordCtrl.gotoChatConsultRoomCallBack = { [weak self] in
//            self?.performSegue(withIdentifier: "consultDetailSegue", sender: $0)
//        }
//        
//        consultRecordCtrl.sendImageCallBack = { [unowned self] in self.viewModel.sendImageSubject.onNext($0) }
//        consultRecordCtrl.sendAudioCallBack = { [unowned self] in self.viewModel.sendAudioSubject.onNext($0) }
//        consultRecordCtrl.sendTextCallBack = { [unowned self] in self.viewModel.sendTextSubject.onNext($0) }
//        consultRecordCtrl.sendBackCallBack = { [unowned self] in self.viewModel.sendBackSubject.onNext($0) }
        
        viewModel.reloadSubject.onNext(Void())
    }
    
    override func prepare(parameters: [String : Any]?) {
        consultItemModel = parameters!["model"] as! HCConsultListItemModel
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "consultDetailSegue", let model = sender as? HCConsultDetailItemModel {
//            segue.destination.title = model.memberName
//            segue.destination.prepare(parameters: ["memberId":model.memberId, "id": model.id])
//        }else if segue.identifier == "patientGroupSegue" {
//            segue.destination.prepare(parameters: ["id": memberId])
//        }
    }
}
