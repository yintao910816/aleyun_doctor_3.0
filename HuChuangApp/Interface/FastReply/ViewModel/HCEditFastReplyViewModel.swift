//
//  HCEditFastReplyViewModel.swift
//  HuChuangApp
//
//  Created by yintao on 2020/12/27.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

import RxSwift

private let photoCount: Int = 4

class HCEditFastReplyViewModel: BaseViewModel {
    
    private var replyModel: HCFastReplyModel?

    public let datasource = Variable([HCPhotoViewModel]())
    public let addImageSignal = PublishSubject<UIImage?>()
    public let delImageSignal = PublishSubject<IndexPath>()
    public let saveSignal = PublishSubject<(String?, String?)>()

    init(replyModel: HCFastReplyModel?) {
        super.init()
        
        self.replyModel = replyModel
        
        addImageSignal
            .subscribe(onNext: { [unowned self] in
                if let image = $0 {
                    var datas = datasource.value
                    if datas.count < photoCount {
                        datas.insert(HCPhotoViewModel(image: image), at: datas.count - 1)
                    }else {
                        datas.remove(at: datas.count - 1)
                        datas.append(HCPhotoViewModel(image: image))
                    }
                    datasource.value = datas
                }
            })
            .disposed(by: disposeBag)
        
        delImageSignal
            .subscribe(onNext: { [unowned self] in
                if $0.row < datasource.value.count {
                    var datas = datasource.value
                    datas.remove(at: $0.row)
                    
                    if datas.count < photoCount,
                       datas.first(where: { $0.isAdd }) == nil {
                        datas.append(HCPhotoViewModel(image: UIImage(named: "chat_add_image"), isAdd: true))
                    }
                    
                    datasource.value = datas
                }
            })
            .disposed(by: disposeBag)
        
        saveSignal
            .subscribe(onNext: { [unowned self] in preparePostRequest(data: $0) })
            .disposed(by: disposeBag)
        
        reloadSubject
            .subscribe(onNext: { [unowned self] in
                var datas: [HCPhotoViewModel] = []
                if let model = replyModel,
                   model.photoModels.count > 0 {
                    datas.append(contentsOf: model.photoModels)
                }
                
                if datas.count < photoCount {
                    datas.append(HCPhotoViewModel(image: UIImage(named: "chat_add_image"), isAdd: true))
                }
                
                datasource.value = datas
            })
            .disposed(by: disposeBag)
    }
}

extension HCEditFastReplyViewModel {
    
    private func preparePostRequest(data: (String?, String?)) {
        guard let markText = data.0, markText.count > 0 else {
            NoticesCenter.alert(message: "请输入备注")
            return
        }
        
        guard let replyText = data.1, replyText.count > 0 else {
            NoticesCenter.alert(message: "请输入快捷回复话语")
            return
        }

        hud.noticeLoading()

        var images: [UIImage] = []
        var urls: [String] = []
        for item in datasource.value {
            if item.isAdd == false,
               let img = item.image {
                images.append(img)
            }
            
            if item.url.count > 0 {
                urls.append(item.url)
            }
        }
        
        var signals: [Observable<String>] = []
        for item in images {
            signals.append(uploadImage(image: item))
        }
        
        let signal = Observable.combineLatest(signals)
            .map({ d -> String in
                var strings: String = ""
                for item in d {
                    if strings.count == 0 {
                        strings = item
                    }else {
                        strings = "\(strings),\(item)"
                    }
                }
                return strings
            })

        
        if let repM = replyModel {
            var path: String = urls.joined(separator: ",")
            if signals.count > 0 {
                signal.subscribe(onNext: { [weak self] in
                    if path.count > 0 {
                        path = "\(path),\($0)"
                    }else {
                        path = $0
                    }
                    self?.requestEditTemplates(id: repM.id,
                                               markText: markText,
                                               replyText: replyText,
                                               path: path)
                }, onError: { [weak self] in
                    self?.hud.failureHidden(self?.errorMessage($0))
                })
                .disposed(by: disposeBag)
            }else {
                requestEditTemplates(id: repM.id,
                                     markText: markText,
                                     replyText: replyText,
                                     path: path)
            }
        }else {
            if signals.count > 0 {
                signal.subscribe(onNext: { [weak self] in
                    self?.requestAddConsultTemplates(markText: markText,
                                                     replyText: replyText,
                                                     path: $0)
                }, onError: { [weak self] in
                    self?.hud.failureHidden(self?.errorMessage($0))
                })
                .disposed(by: disposeBag)
            }else {
                requestAddConsultTemplates(markText: markText,
                                           replyText: replyText,
                                           path: "")
            }
        }
    }
    
    private func uploadImage(image: UIImage) ->Observable<String> {
        if let imgData = image.jpegData(compressionQuality: 0.6) {
            return HCProvider.request(.uploadFile(data: imgData, fileType: .image))
                .map(model: HCFileUploadModel.self)
                .asObservable()
                .map{ $0.filePath }
        }
        return Observable.just("")
    }
    
    private func requestAddConsultTemplates(markText: String, replyText: String, path: String) {
        HCProvider.request(.addConsultTemplates(path: path,
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
    
    private func requestEditTemplates(id: String, markText: String, replyText: String, path: String) {
        HCProvider.request(.editTemplates(id: id, path: path, title: markText, content: replyText))
            .map(model: HCFastReplyModel.self)
            .subscribe { [weak self] _ in
                NotificationCenter.default.post(name: NotificationName.FastReply.edit, object: nil)
                self?.hud.successHidden("修改成功", {
                    self?.popSubject.onNext(Void())
                })
            } onError: { [weak self] in
                self?.hud.failureHidden(self?.errorMessage($0))
            }
            .disposed(by: disposeBag)
    }
}
