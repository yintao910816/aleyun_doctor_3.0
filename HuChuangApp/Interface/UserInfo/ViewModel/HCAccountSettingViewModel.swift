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
    
    public let listItemSubject = PublishSubject<[[HCListCellItem]]>()
    public let uploadIconSubject = PublishSubject<UIImage?>()
    public let saveSignal = PublishSubject<Void>()

    override init() {
        super.init()
        
        HCHelper.share.userInfoHasReload
            .subscribe(onNext: { [weak self] in self?.prepareData(user: $0) })
            .disposed(by: disposeBag)
        
        saveSignal.subscribe(onNext: {
            PrintLog("保存")
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
                return self.requestEditIcon(icon: image!).concatMap{ self.requestUpdateUserInfo(iconPath: $0.filePath) }
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
        nameItem.cellIdentifier = HCListDetailCell_identifier
        nameItem.shwoArrow = false
        items.append([nameItem])

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
        skilledInItem.inputEnable = false
        skilledInItem.detailTitle = user.skilledIn
        skilledInItem.cellIdentifier = HCListTextViewAndTitleCell_identifier
        skilledInItem.shwoArrow = false
        skilledInItem.cellHeight = 170

        let briefInItem = HCListCellItem()
        briefInItem.title = "简介"
        briefInItem.inputEnable = false
        briefInItem.detailTitle = user.brief
        briefInItem.cellIdentifier = HCListTextViewAndTitleCell_identifier
        briefInItem.shwoArrow = false
        briefInItem.cellHeight = 170

        items.append([hospitalItem, departmentNameItem, technicalPostItem, skilledInItem, briefInItem])
        
        listItemSubject.onNext(items)
    }
    
    private func requestEditIcon(icon: UIImage) ->Observable<HCUpLoadIconModel>{
        return HCProvider.request(.uploadIcon(image: icon))
            .map(model: HCUpLoadIconModel.self)
            .asObservable()
    }
    
    private func requestUpdateUserInfo(iconPath: String) ->Observable<HCUserModel> {
        guard let user = HCHelper.share.userInfoModel else {
            hud.failureHidden("用户信息获取失败，请重新登录") {
                HCHelper.presentLogin()
            }
            return Observable.empty()
        }
                
        return HCProvider.request(.accountSetting(nickName: user.name, headPath: iconPath))
            .map(model: HCUserModel.self)
            .asObservable()
    }

}
