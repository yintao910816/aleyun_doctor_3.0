//
//  HCAccountSettingViewModel.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/13.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation
import RxSwift

class HCAccountSettingViewModel: BaseViewModel {
    
    private var updateInfo: [String: Any] = [:]
    
    public let listItemSubject = PublishSubject<[[HCListCellItem]]>()
    public let uploadIconSubject = PublishSubject<UIImage?>()
    public let saveSignal = PublishSubject<Void>()

    override init() {
        super.init()
        
//        HCHelper.share.userInfoHasReload
//            .subscribe(onNext: { [weak self] in self?.prepareData(user: $0) })
//            .disposed(by: disposeBag)
        
        saveSignal
            ._doNext(forNotice: hud)
            .flatMap{ [unowned self] in requestUpdateUserInfo() }
            .subscribe(onNext: { [weak self] user in
                HCHelper.saveLogin(user: user)
                self?.hud.noticeHidden()
            }, onError: { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
            })
            .disposed(by: disposeBag)
        
        uploadIconSubject
            .filter({ [unowned self] image -> Bool in
                if image == nil {
                    self.hud.failureHidden("请选择头像")
                    return false
                }
                return true
            })
            ._doNext(forNotice: hud)
            .flatMap({ [unowned self] image -> Observable<HCUserModel> in
                return self.requestEditIcon(icon: image!)
                    .do(onNext: { [weak self] in self?.updateInfo["headPath"] = $0.filePath })
                    .concatMap{ [weak self] _ in (self?.requestUpdateUserInfo() ?? Observable.just(HCUserModel())) }
            })
            .subscribe(onNext: { [weak self] user in
                HCHelper.saveLogin(user: user)
                self?.hud.noticeHidden()
            }, onError: { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
            })
            .disposed(by: disposeBag)
        
        reloadSubject
            .subscribe(onNext: { [weak self] in
                if let user = HCHelper.share.userInfoModel {
                    self?.prepareData(user: user)
                }
            })
            .disposed(by: disposeBag)        
    }
    
}

extension HCAccountSettingViewModel {
    
    private func prepareData(user: HCUserModel) {
        inputTextDisposeBag = DisposeBag()
        
        updateInfo["headPath"] = user.headPath
        updateInfo["name"] = user.name
        updateInfo["headPath"] = user.headPath
        updateInfo["unitId"] = user.unitId
        updateInfo["brief"] = user.brief
        //科室id
        updateInfo["departmentId"] = user.departmentId
//        updateInfo["sex"] = user.sex
        // 擅长说明
        updateInfo["skilledIn"] = user.skilledIn
        // 擅长id集合
        updateInfo["skilledInIds"] = user.skilledInIds
        // 职称id
//        updateInfo["technicalPostId"] = user.technicalPostId
//        updateInfo["consult"] = user.consult
//        updateInfo["smsNotice"] = user.smsNotice
//        updateInfo["consultPrice"] = user.consultPrice

        var items: [[HCListCellItem]] = []
        
        //
        let avatarItem = HCListCellItem()
        avatarItem.title = "头像"
        avatarItem.iconType = .userIcon
        avatarItem.cellIdentifier = HCListDetailIconCell_identifier
        avatarItem.cellHeight = 80
        avatarItem.detailIcon = user.headPath
        items.append([avatarItem])
        
        //
        let nameItem = HCListCellItem()
        nameItem.title = "用户名"
        nameItem.detailTitle = user.name
        nameItem.detailInputTextAlignment = .right
        nameItem.placeholder = "请输入用户名"
        nameItem.cellIdentifier = HCListDetailInputCell_identifier
        nameItem.shwoArrow = false
        items.append([nameItem])

        nameItem.textSignal.asDriver()
            .drive(onNext: { [weak self] in
                if $0.count > 0 {
                    self?.updateInfo["name"] = $0
                }
            })
            .disposed(by: inputTextDisposeBag)
        
        //
        let hospitalItem = HCListCellItem()
        hospitalItem.title = "医院"
        hospitalItem.detailTitle = user.unitName
        hospitalItem.cellIdentifier = HCListDetailCell_identifier
        hospitalItem.shwoArrow = false

        let departmentNameItem = HCListCellItem()
        departmentNameItem.title = "科室"
        departmentNameItem.detailTitle = user.departmentName
        departmentNameItem.cellIdentifier = HCListDetailCell_identifier
        departmentNameItem.shwoArrow = false

        let technicalPostItem = HCListCellItem()
        technicalPostItem.title = "职称"
        technicalPostItem.detailTitle = user.technicalPost
        technicalPostItem.cellIdentifier = HCListDetailCell_identifier
        technicalPostItem.shwoArrow = false
        
        let skilledInItem = HCListCellItem()
        skilledInItem.title = "擅长领域"
//        skilledInItem.inputEnable = false
        skilledInItem.detailTitle = user.skilledIn
        skilledInItem.cellIdentifier = HCListTextViewAndTitleCell_identifier
        skilledInItem.shwoArrow = false
        skilledInItem.cellHeight = 170
        
        skilledInItem.textSignal.asDriver()
            .drive(onNext: { [weak self] in self?.updateInfo["skilledIn"] = $0 })
            .disposed(by: inputTextDisposeBag)

        let briefInItem = HCListCellItem()
        briefInItem.title = "简介"
//        briefInItem.inputEnable = false
        briefInItem.detailTitle = user.brief
        briefInItem.cellIdentifier = HCListTextViewAndTitleCell_identifier
        briefInItem.shwoArrow = false
        briefInItem.cellHeight = 170
        
        briefInItem.textSignal.asDriver()
            .drive(onNext: { [weak self] in self?.updateInfo["brief"] = $0 })
            .disposed(by: inputTextDisposeBag)


        items.append([hospitalItem, departmentNameItem, technicalPostItem, skilledInItem, briefInItem])
        
        listItemSubject.onNext(items)
    }
    
    private func requestEditIcon(icon: UIImage) ->Observable<HCUpLoadIconModel>{
        return HCProvider.request(.uploadIcon(image: icon))
            .map(model: HCUpLoadIconModel.self)
            .asObservable()
    }
    
    private func requestUpdateUserInfo() ->Observable<HCUserModel> {
        guard let _ = HCHelper.share.userInfoModel else {
            hud.failureHidden("用户信息获取失败，请重新登录") {
                HCHelper.presentLogin()
            }
            return Observable.empty()
        }
                
        return HCProvider.request(.updateExtInfo(params: updateInfo))
            .map(model: HCUserModel.self)
            .asObservable()
    }

}
