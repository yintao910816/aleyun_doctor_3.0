//
//  HCHomeViewModel.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/8.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

import RxSwift

class HCHomeViewModel: BaseViewModel {
    
    private var allArticleDatas: [String: [HCCmsArticleModel]] = [:]
    private var pageIdxs: [String: Int] = [:]
    
    public let functionsMenuSignal = PublishSubject<([HCFunctionsMenuModel], [HCCmsCmsChanelListModel], [HCBannerModel], Int, HCUserModel, HCUserServerStatisticsModel)>()
    public let articleDataSignal = PublishSubject<([HCCmsArticleModel], Int)>()
    public let articleTypeChangeSignal = PublishSubject<HCMenuItemModel>()
    
    override init() {
        super.init()
        
//        articleTypeChangeSignal
//            .subscribe(onNext: { [unowned self] in
//                if self.allArticleDatas.keys.contains($0.itemId) || $0.itemId == "0" {
//                    self.articleDataSignal.onNext((self.allArticleDatas[$0.itemId] ?? [], 0))
//                }else {
//                    self.requestCmsArticleList(channelId: $0.itemId, page: self.pageIdxs[$0.itemId] ?? 0)
//                }
//            })
//            .disposed(by: disposeBag)
        
        HCHelper.share.userInfoHasReload
            .subscribe(onNext: { [weak self] _ in self?.requestHeaderDatas() })
            .disposed(by: disposeBag)
        
        reloadSubject.subscribe(onNext: { [weak self] in self?.requestHeaderDatas() })
            .disposed(by: disposeBag)
        
    }
    
}

extension HCHomeViewModel {
    
    private func requestHeaderDatas() {
        Observable.combineLatest(requestMenuItems(),
                                 requestCmsChanelList(),
                                 requestBanner(),
                                 requestUserServerStatistics(),
                                 requestUnreplyNum()) { ($0, $1, $2, $3, $4) }
            .concatMap({ [unowned self] data -> Observable<[HCCmsArticleModel]> in
                var tempArr: [HCCmsCmsChanelListModel] = []
                let recommendItem = HCCmsCmsChanelListModel()
                recommendItem.id = "0"
                recommendItem.name = "推荐"
                tempArr.append(recommendItem)
                tempArr.append(contentsOf: data.1)
                
                for idx in 0..<tempArr.count {
                    self.pageIdxs[tempArr[idx].id] = idx
                }
                
                data.3.unreplyNum = data.4
                
                self.functionsMenuSignal.onNext((data.0, tempArr, data.2, 0, HCHelper.share.userInfoModel ?? HCUserModel(), data.3))
                return self.requestRecomCms()
            })
            .subscribe(onNext: { [unowned self] data in
                self.allArticleDatas["0"] = data
                self.articleDataSignal.onNext((data, 0))
            })
            .disposed(by: disposeBag)
    }
    
    // 待接诊数量
    private func requestUnreplyNum() ->Observable<Int> {
        return HCProvider.request(.getUnreplyNum)
            .mapJSON()
            .map { res -> Int in
                if let dic = res as? [String: Any], let num = dic["data"] as? Int {
                    return num
                }
                return 0
            }
            .asObservable()
            .catchErrorJustReturn(0)
    }
    
    // 用户咨询数量相关
    private func requestUserServerStatistics() ->Observable<HCUserServerStatisticsModel> {
        return HCProvider.request(.userServerStatistics)
            .map(model: HCUserServerStatisticsModel.self)
            .asObservable()
            .catchErrorJustReturn(HCUserServerStatisticsModel())
    }
    
    // banner
    private func requestBanner() ->Observable<[HCBannerModel]> {
        return HCProvider.request(.selectBanner(code: .bannerdoctor))
            .map(models: HCBannerModel.self)
            .asObservable()
            .catchErrorJustReturn([HCBannerModel]())
    }

    // 功能区
    private func requestMenuItems() ->Observable<[HCFunctionsMenuModel]> {
        return HCProvider.request(.functionsMenu)
            .map(models: HCFunctionsMenuModel.self)
            .asObservable()
            .catchErrorJustReturn([HCFunctionsMenuModel]())
    }
}

extension HCHomeViewModel {
    
     
    // 推荐栏目文章
    private func requestRecomCms() ->Observable<[HCCmsArticleModel]> {
        return HCProvider.request(.cmsRecommend(cmsCode: .SGBK))
            .map(models: HCCmsArticleModel.self)
            .asObservable()
            .catchErrorJustReturn([HCCmsArticleModel]())
    }
    
    /// 栏目
    private func requestCmsChanelList() ->Observable<[HCCmsCmsChanelListModel]> {
        return HCProvider.request(.cmsCmsChanelList(cmsCode: .RMZX))
            .map(models: HCCmsCmsChanelListModel.self)
            .asObservable()
            .catchErrorJustReturn([HCCmsCmsChanelListModel]())
    }
    
    /// 栏目文章
    private func requestCmsArticleList(channelId: String, page: Int) {
        HCProvider.request(.cmsArticleList(channelId: channelId))
            .map(models: HCCmsArticleModel.self)
            .subscribe(onSuccess: { [weak self] in
                self?.allArticleDatas[channelId] = $0
                self?.articleDataSignal.onNext(($0, page))
            })
            .disposed(by: disposeBag)
    }
}
