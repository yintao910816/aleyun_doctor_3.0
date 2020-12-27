//
//  HCEditFastReplyViewModel.swift
//  HuChuangApp
//
//  Created by yintao on 2020/12/27.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

import RxSwift

class HCEditFastReplyViewModel: BaseViewModel {
    
    public let datasource = Variable([HCPhotoViewModel]())
    public let addImageSignal = PublishSubject<UIImage?>()
    public let delImageSignal = PublishSubject<IndexPath>()
    public let saveSignal = PublishSubject<(String?, String?)>()

    override init() {
        super.init()
        
        addImageSignal
            .subscribe(onNext: { [unowned self] in
                if let image = $0 {
                    var datas = datasource.value
//                    datas.insert(HCPhotoViewModel(image: image), at: datas.count - 1)
                    datas.removeAll()
                    datas.append(HCPhotoViewModel(image: image))
                    datasource.value = datas
                }
            })
            .disposed(by: disposeBag)
        
        delImageSignal
            .subscribe(onNext: { [unowned self] _ in
//                if $0.row < datasource.value.count {
//                    var datas = datasource.value
//                    datas.remove(at: $0.row)
//                    datasource.value = datas
//                }
                datasource.value = [HCPhotoViewModel(image: UIImage(named: "chat_add_image"), isAdd: true)]
            })
            .disposed(by: disposeBag)
        
        saveSignal
            .subscribe(onNext: { [unowned self] in preparePostEdit(data: $0) })
            .disposed(by: disposeBag)
        
        reloadSubject
            .subscribe(onNext: { [unowned self] in
                datasource.value = [HCPhotoViewModel(image: UIImage(named: "chat_add_image"), isAdd: true)]
            })
            .disposed(by: disposeBag)
    }
}

extension HCEditFastReplyViewModel {
    
    private func preparePostEdit(data: (String?, String?)) {
        guard let markText = data.0, markText.count > 0 else {
            NoticesCenter.alert(message: "请输入备注")
            return
        }
        
        guard let replyText = data.1, replyText.count > 0 else {
            NoticesCenter.alert(message: "请输入快捷回复话语")
            return
        }

        hud.noticeLoading()

        var data: Data?
        if let imgM = datasource.value.first(where: { !$0.isAdd }),
           let image = imgM.image,
           let imgData = image.jpegData(compressionQuality: 0.6) {
            data = imgData
        }

        if data != nil, data!.count > 0 {
            HCProvider.request(.uploadFile(data: data!, fileType: .image))
                .map(model: HCFileUploadModel.self)
                .flatMap{ HCProvider.request(.addConsultTemplates(path: $0.filePath, title: markText, content: replyText)).map(model: HCFastReplyModel.self) }
                .subscribe(onSuccess: { [weak self] _ in
                    NotificationCenter.default.post(name: NotificationName.FastReply.add, object: nil)
                    self?.hud.successHidden("添加成功", {
                        self?.popSubject.onNext(Void())
                    })
                }, onError: { [weak self] in
                    self?.hud.failureHidden(self?.errorMessage($0))
                })
                .disposed(by: disposeBag)
        }else {
            HCProvider.request(.addConsultTemplates(path: "",
                                                    title: markText,
                                                    content: replyText))
                .map(model: HCFastReplyModel.self)
                .subscribe { [weak self] _ in
                    NotificationCenter.default.post(name: NotificationName.FastReply.add, object: nil)
                    self?.hud.successHidden("添加成功", {
                        self?.popSubject.onNext(Void())
                    })
                } onError: { [weak self] in
                    self?.hud.failureHidden(self?.errorMessage($0))
                }
                .disposed(by: disposeBag)
        }
    }
}
