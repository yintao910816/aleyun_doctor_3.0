//
//  HCEditPatientGroupViewModel.swift
//  HuChuangApp
//
//  Created by yintao on 2020/11/18.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class HCEditPatientGroupViewModel: BaseViewModel {
    
    private var memberId: String = ""
    
    public let tagListSource = Variable([HCFiliterSectionModel]())
    public let cellDidSelected = PublishSubject<(String, String)>()
    public let deleteTagSubject = PublishSubject<String>()

    init(input: Driver<String>, addTapDriver: Driver<Void>, memberId: String) {
        super.init()
        self.memberId = memberId
        
        addTapDriver.withLatestFrom(input)
            .filter{ return $0.count > 0 }
            ._doNext(forNotice: hud)
            .drive(onNext: { [unowned self] in self.requestAddUserTag(tagName: $0) })
            .disposed(by: disposeBag)
        
        cellDidSelected
            .subscribe(onNext: { [unowned self] in self.requestAddUserMemberTags(tagName: $0.0, id: $0.1) })
            .disposed(by: disposeBag)
        
        deleteTagSubject
            .subscribe(onNext: { [unowned self] in self.requestRemoveUserTag(id: $0) })
            .disposed(by: disposeBag)

        reloadSubject
            .subscribe(onNext: { [unowned self] in
                self.requestUserTagList()
            })
            .disposed(by: disposeBag)
    }
    
    private func requestUserTagList() {
        HCProvider.request(.getUserTagList(memberId: memberId))
            .map(models: HCTagNameModel.self)
            .subscribe(onSuccess: { [weak self] in
                self?.tagListSource.value = HCFiliterSectionModel.createData(datas: $0)
            }) { _ in }
            .disposed(by: disposeBag)
    }
    
    private func requestAddUserMemberTags(tagName: String, id: String) {
        hud.noticeLoading()
        HCProvider.request(.addUserMemberTags(memberId: memberId, tagName: tagName, id: id))
            .mapResponse()
            .subscribe(onSuccess: { [weak self] in
                if let type = RequestCode(rawValue: $0.code), type == .success {
                    NotificationCenter.default.post(name: NotificationName.Patient.changedTagName, object: (false, tagName))
                    self?.hud.noticeHidden()
                    self?.popSubject.onNext(Void())
                }else {
                    self?.hud.failureHidden($0.message)
                }
            }) { [weak self] in
                self?.hud.failureHidden(self?.errorMessage($0))
        }
        .disposed(by: disposeBag)
    }

    private func requestRemoveUserTag(id: String) {
        hud.noticeLoading()
        HCProvider.request(.removeUserTag(memberId: memberId, id: id))
            .mapResponse()
            .subscribe(onSuccess: { [weak self] in
                if let type = RequestCode(rawValue: $0.code), type == .success {
                    NotificationCenter.default.post(name: NotificationName.Patient.changedTagName,
                                                    object: (true, self?.findTagName(id: id) ?? ""))

                    self?.deleteSource(with: id)
                    self?.hud.noticeHidden()
                }else {
                    self?.hud.failureHidden($0.message)
                }
            }) { [weak self] in
                self?.hud.failureHidden(self?.errorMessage($0))
        }
        .disposed(by: disposeBag)
    }
    
    private func requestAddUserTag(tagName: String) {
        HCProvider.request(.addUserTag(tagName: tagName, clinicId: ""))
            .map(model: HCTagNameModel.self)
            .subscribe(onSuccess: { [weak self] in
                self?.addSource(with: $0)
                self?.hud.noticeHidden()
            }) { [weak self] in
                self?.hud.failureHidden(self?.errorMessage($0))
        }
        .disposed(by: disposeBag)
    }
}

extension HCEditPatientGroupViewModel {
    
    private func deleteSource(with id: String) {
        let tempSource = tagListSource.value
        var deleteIdx: Int?
        var sectionItem: HCFiliterSectionModel!
        for item in tempSource {
            sectionItem = item
            if let idx = item.datas.firstIndex(where: { $0.id == id }) {
                deleteIdx = idx
                break
            }
        }
        
        if let idx = deleteIdx {
            sectionItem.datas.remove(at: idx)
        }
        
        tagListSource.value = tempSource
    }

    private func findTagName(id: String) ->String {
        let tempSource = tagListSource.value
        var tagName: String = ""
        for item in tempSource {
            if let model = item.datas.first(where: { $0.id == id }) {
                tagName = model.title
                break
            }
        }
        return tagName
    }

    private func addSource(with tagModel: HCTagNameModel) {
        let tempSource = tagListSource.value
        tempSource.last?.datas.append(HCFiliterSectionModel.transform(of: tagModel))
        tagListSource.value = tempSource
    }

}
