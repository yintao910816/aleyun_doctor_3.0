//
//  SRUserAPI.swift
//  StoryReader
//
//  Created by 020-YinTao on 2016/11/25.
//  Copyright © 2016年 020-YinTao. All rights reserved.
//

import Foundation
import Moya

/// 文件类型
enum HCFileUploadType: String {
    case image = "image/jpeg"
    case audio = "audio/mp3"
    
    public var getSuffix: String {
        switch self {
        case .image:
            return ".jpg"
        case .audio:
            return ".mp3"
        }
    }
}

/// 列表排序
enum HCRequestListSort: Int {
    /// 顺序
    case increase = 0
    /// 倒序
    case decrease = 1
}

/// 文章栏目编码
enum HCCmsType: String {
    /// 首页-推荐课程列表
    case SGBK = "SGBK"
    /// 热门资讯 类目code
    case RMZX = "RMZX"
}

/// 列表类型
enum HCMenuListModuleType: String {
    /// 我的医生
    case doctor = "doctor"
    /// 我的课程
    case course = "course"
    /// 我的资讯
    case information = "information"
}

enum HCMergeProOpType: String {
    /// 标记月经
    case menstruationDate = "menstruationDate"
    /// 添加同房记录
    case knewRecord = "knewRecord"
    /// 添加排卵日
    case ovulation = "ovulation"
    /// 添加体温记录
    case temperature = "temperature"
}

enum H5Type: String {
    /// 好孕消息
    case goodNews = "goodnews"
    /// 消息中心
    case notification = "notification"
    /// 公告
    case announce = "announce"
    /// 认证
    case bindHos = "bindHos"
    /// 绑定成功
    case succBind = "succBind"
    /// 问诊记录
    case consultRecord = "consultRecord"
    /// 我的预约
    case memberSubscribe = "memberSubscribe"
    /// 我的收藏
    case memberCollect = "memberCollect"
    /// 用户反馈
    case memberFeedback = "memberFeedback"
    /// cms功能：readNumber=阅读量,modifyDate=发布时间，hrefUrl=调整地址
    case hrefUrl = "hrefUrl"
    /// 医生咨询
    case doctorConsult = "doctorConsult"
    /// 患者咨询
    case patientConsult = "patientConsult"
    /// 开发中
    case underDev = "underDev"
    /// 咨询医生信息
    case doctorHome = "doctorHome"
    /// 快速问诊
    case doctorCs = "DoctorCs"
    /// 问诊记录
    case doctorComments = "doctorComments"
    /// 我的关注
    case myFocused = "myFocused"
    /// 我的搜藏
    case myCollection = "myCollection"
    /// 我的卡卷
    case voucherCenter = "myCoupon"
    /// 经期设置
    case menstrualSetting = "MenstrualSetting"
    /// 个人中心健康档案
    case healthRecordsUser = "healthRecords"
    /// 用户反馈
    case feedback = "feedback"
    /// 帮助中心
    case helpCenter = "NounParsing"
    /// 通知中心
    case noticeAndMessage = "noticeAndMessage"
    /// 订单
    case csRecord = "CsRecord"
    /// 我的医生
    case myDoctor = "myDoctor"
    /// 分享app给好友
    case share = "share"
        
    func getLocalUrl(needToken: Bool = true) ->String {
        var host = APIAssistance.baseH5Host

        if needToken {
            host = "\(host)#/\(rawValue)?token=\(userDefault.token)&titleLock=true"
        }else {
            host = "\(APIAssistance.baseH5Host)#/\(rawValue)?titleLock=true"
        }
        return host
    }
}

/// 搜索的内容类型
/**
 1，searchModule = doctor 为 医生模块，
 2，searchModule = course 为课程，
 3，searchModule = article 为文章）
 4，searchModule 等于 空 为 全部
 */
enum HCsearchModule: String {
    case doctor = "doctor"
    case course = "course"
    case article = "article"
    case all = ""
}

enum HCBannerCode: String {
    case bannerdoctor = "doctorBanner"
}


//MARK:
//MARK: 接口定义
enum API{
    // --------------- 医生3.0接口
    /// banner
    case selectBanner(code: HCBannerCode)
    ///
    case userServerStatistics
    ///
    case getUnreplyNum
    /// 首页菜单
    case functionsMenu
    /// 获取验证码
    case validateCode(mobile: String)
    /// 密码登陆
    case pwdLogin(account: String, psd: String)
    /// 登录
    case loginTel(mobile: String, smsCode: String)
    /// 获取用户信息
    case selectInfo
    /// 获取患者列表
    case getConsultsPatientList(pageNum: Int, pageSize: Int, searchName: String)
   
    /// 患者分组数据
    case groupTagMemberList
    /// 修改标签内容
    case editUserMemberTags(id: String, tagName: String)
    /// 获取已有标签
    case getUserTagList(memberId: String)
    /// 设置患者标签
    case addUserMemberTags(memberId: String, tagName: String, id: String)
    /// 删除患者标签
    case removeUserTag(memberId: String, id: String)
    /// 添加标签
    case addUserTag(tagName: String, clinicId: String)

    /// 获取资讯消息列表 replyStatus: 0未回复1已回复2已退回3已评论（完结）
    case getPatientConsultList(pageNum: Int, pageSize: Int, sort: HCRequestListSort, replyStatus: String)
    /// 第一次获取咨询列表
    case chatDetail(consultId: String, memberId: String)
    /// 加载咨询历史 下拉加载一条新的记录。。loadSize 是1,2,3,4,5，。。。分别代表之前的第一条，第二条记录。。。
    case chatHistoryDetail(memberId: String, userId: String, loadSize: Int)
    /// 文件上传
    case uploadFile(data: Data, fileType: HCFileUploadType)
    /// 咨询回复 - filePath：图片或录音文件地址  bak：录音时长
    case replyConsult(content: String, filePath: String, bak: String, consultId: String)
    /// 编辑患者备注
    case updateConsultBlack(memberId: String, userId: String, bak: String, black: Bool)
    /// 患者健康档案
    case getHealthArchives(memberId: String)
    /// 周期档案
    case getPatientCoupleInfo(memberId: String)
    /// 咨询退回
    case withdrawConsult(orderSn: String)
    
    /// 获取视频签名 医生用userId 患者用memberId
    case videoChatSignature(userId: String)
    /**
     * 接听电话获取头像姓名信息
     */
    case consultVideoUserInfo(memberId: String, userId: String, consultId: String)
    /// 接听电话
    case consultReceivePhone(memberId: String, userId: String, consultId: String)
    /// 拨打电话
    case consultStartPhone(memberId: String, userId: String)
    /// 结束通话
    case consultEndPhone(memberId: String, userId: String, watchTime: String)
    
    
    // --------------- 3.0接口
    /// 实名认证
    case realNameAuth(realName: String, sex: String, birthDay: String, certificateType: String, certificateNo: String)
    /// 账号设置 - 头像/昵称
    case accountSetting(nickName: String, headPath: String)
    /// 上传头像
    case uploadIcon(image: UIImage)
    /// 个人中心
    case personalCenterInfo
    /// 首页推荐文章
    case cmsRecommend(cmsCode: HCCmsType)
    /// 热门资讯 类目
    case cmsCmsChanelList(cmsCode: HCCmsType)
    /// 热门资讯—文章列表
    case cmsArticleList(channelId: String)
    /// 关注与收藏
    case attentionStore(moduleType: HCMenuListModuleType, pageNum: Int, pageSize: Int)
    
    // --------------- 2.0接口
    /// 向app服务器注册友盟token
    case UMAdd(deviceToken: String)

    /// 绑定微信
    case bindAuthMember(userInfo: UMSocialUserInfoResponse, mobile: String, smsCode: String)
    /// 修改用户信息
    case updateInfo(param: [String: String])
    /// 首页功能列表
    case functionList
    /// 好消息
    case goodNews
    /// 首页通知消息
    case noticeList(type: String, pageNum: Int, pageSize: Int)
    /// 获取未读消息
    case messageUnreadCount
    case article(id: String)
    /// 今日知识点击更新阅读量
    case increReading(id: String)
    
    /// 医生列表
    case consultList(pageNum: Int, pageSize: Int)
    
    /// 获取h5地址
    case unitSetting(type: H5Type)
    
    /// 检查版本更新
    case version
    
    //MARK:--爱乐孕治疗四期接口
    /// 怀孕几率查询
    case probability
    /// 首页好孕课堂
//    case allChannelArticle(cmsType: HCWebCmsType, pageNum: Int, pageSize: Int)
    /// 名医推荐
    case recommendDoctor(areaCode: String, lat: String, lng: String)
    /// 课堂
//    case column(cmsType: HCWebCmsType)
    /// 栏目文章列表
    case articlePage(id: Int, pageNum: Int, pageSize: Int)
    /// 专家问诊医生列表
    case consultSelectListPage(pageNum: Int, pageSize: Int, searchName: String, areaCode: String, opType: [String: Any], sceen: [String: Any])
    /// 咨询医生信息
    case getUserInfo(userId: String)
    /// 最近三个周期信息
    case getLast2This2NextWeekInfo
    /// 获取月经周期基础数据
    case getMenstruationBaseInfo
    /// 微信授权登录---获取绑定信息
    case getAuthMember(openId: String)
    /// 搜索
    case search(pageNum: Int, pageSize: Int, searchModule: HCsearchModule, searchName: String)
    /// 文章当前收藏数量
    case storeAndStatus(articleId: String)
    /// 文章收藏取消
    case articelStore(articleId: String, status: Bool)
    /// 区域城市
    case allCity
    /// 添加标记排卵日,添加同房记录
    case mergePro(opType: HCMergeProOpType, date: String, data: [String: Any])
    /// 添加/修改/删除,月经周期
    case mergeWeekInfo(id: Int, startDate: String, keepDays: Int, next: Int)
}

//MARK:
//MARK: TargetType 协议
extension API: TargetType{
    
    var path: String{
        switch self {
        case .userServerStatistics:
            return "api/patientConsult/userServerStatistics"
        case .getUnreplyNum:
            return "api/patientConsult/getUnreplyNum"
        case .selectBanner(_):
            return "api/index/selectBanner"
        case .functionsMenu:
            return "api/index/select"
        case .validateCode(_):
            return "api/login/validateCode"
        case .loginTel(_, _):
            return "api/login/login"
        case .pwdLogin(_, _):
            return "api/login/loginTwo"
        case .selectInfo:
            return "api/user/selectInfo"
        case .getConsultsPatientList(_, _, _):
            return "api/patientConsult/getConsultMemberList"
        
        case .groupTagMemberList:
            return "api/patientInfo/groupTagMemberList"
        case .editUserMemberTags(_, _):
            return "api/patientConsult/editUserMemberTags"
        case .getUserTagList(_):
            return "api/patientConsult/getUserTagList"
        case .addUserMemberTags(_):
            return "api/patientConsult/addUserMemberTags"
        case .removeUserTag(_, _):
            return "api/patientConsult/removeUserTag"
        case .addUserTag(_, _):
            return "api/patientConsult/addUserTag"

        case .getPatientConsultList(_, _, _, _):
            return "api/patientConsult/getConsultListWx"
        case .chatDetail(_, _):
            return "api/patientConsult/getConsultDetailWx"
        case .chatHistoryDetail(_, _, _):
            return "api/patientConsult/chatHistoryDetail"
        case .uploadFile(_):
            return "api/upload/fileSingle"
        case .replyConsult(_, _, _, _):
            return "api/patientConsult/replyConsult"
        case .updateConsultBlack(_, _, _, _):
            return "api/patientConsult/updateConsultBlackWx"
        case .getHealthArchives:
            return "api/patientConsult/getHealthArchives"
        case .getPatientCoupleInfo(_):
            return "api/patientConsult/getPatientCoupleInfo"
        case .withdrawConsult(let orderSn):
            return "api/patientConsult/withdrawConsult/\(orderSn)"
        
        case .videoChatSignature(_):
            return "api/patientConsult/signature"
        case .consultVideoUserInfo(_, _, _):
            return "api/patientConsult/videoUserInfo"
        case .consultReceivePhone(_, _, _):
            return "api/patientConsult/receivePhone"
        case .consultStartPhone(_, _):
            return "api/patientConsult/startPhone"
        case .consultEndPhone(_, _, _):
            return "api/patientConsult/endPhone"
            
            
        case .realNameAuth(_, _, _, _, _):
            return "api/consumer/realNameAuth"
        case .accountSetting(_, _):
            return "api/personalCenter/accountSetting"
        case .uploadIcon(_):
            return "api/upload/imgSingle"
        case .personalCenterInfo:
            return "api/personalCenter/info"
        case .cmsRecommend(let cmsCode):
            return "api/cms/recommend/\(cmsCode.rawValue)"
        case .cmsCmsChanelList(let cmsCode):
            return "api/cms/cmsChanelList/\(cmsCode.rawValue)"
        case .cmsArticleList(let channelId):
            return "api/cms/articleList/\(channelId)"
        case .attentionStore(_, _, _):
            return "api/attentionStore/attentionStore"
            
        case .UMAdd(_):
            return "api/umeng/add"
        case .bindAuthMember(_):
            return "api/login/bindAuthMember"
        case .updateInfo(_):
            return "api/member/updateInfo"
        case .functionList:
            return "api/index/select"
        case .noticeList(_):
            return "api/index/noticeList"
        case .messageUnreadCount:
            return "api/messageCenter/unread"
        case .goodNews:
            return "api/index/goodNews"
        case .article(_):
            return "api/index/article"
        case .increReading(_):
            return "api/index/increReading"
        case .unitSetting(_):
            return "api/index/unitSetting"
        case .version:
            return "api/apk/version"
        case .consultList(_):
            return "api/consult/selectPageList"
            
//        case .column(_):
//            return "api/index/column"
//        case .allChannelArticle(_):
//            return "api/index/allChannelArticle"
        case .recommendDoctor(_):
            return "api/doctor/recommendDoctor"
        case .articlePage(_):
            return "api/index/articlePage"
        case .consultSelectListPage(_):
            return "api/consult/selectListPage"
        case .getUserInfo(_):
            return "api/consult/getUserInfo"
        case .probability:
            return "api/physiology/probability"
        case .getLast2This2NextWeekInfo:
            return "api/physiology/getLast2This2NextWeekInfo"
        case .getMenstruationBaseInfo:
            return "api/physiology/getMenstruationBaseInfo"
        case .getAuthMember(_):
            return "api/login/getAuthMember"
        case .search(_):
            return "api/search/search"
        case .storeAndStatus(_):
            return "api/cms/storeAndStatus"
        case .articelStore(_):
            return "api/cms/store"
        case .allCity:
            return "api/area/allCity"
        case .mergePro(_):
            return "api/physiology/mergePro"
        case .mergeWeekInfo(_):
            return "api/physiology/mergeWeekInfo"
        }
    }
    
    var baseURL: URL{ return APIAssistance.baseURL(API: self) }
    
    var task: Task {
        switch self {
        case .uploadFile(let data, let fileType):
            //根据当前时间设置图片上传时候的名字
            let timeInterval: TimeInterval = Date().timeIntervalSince1970
            let dateStr = "\(Int(timeInterval))\(fileType.getSuffix)"
            let formData = MultipartFormData(provider: .data(data), name: "file", fileName: dateStr, mimeType: fileType.rawValue)
            return .uploadMultipart([formData])
        case .uploadIcon(let image):
            let data = image.jpegData(compressionQuality: 0.6)!
            //根据当前时间设置图片上传时候的名字
            let date:Date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd-HH:mm:ss"
            let dateStr:String = formatter.string(from: date)
            
            let formData = MultipartFormData(provider: .data(data), name: "file", fileName: dateStr, mimeType: "image/jpeg")
            return .uploadMultipart([formData])
        case .version:
            return .requestParameters(parameters: ["type": "ios", "packageName": "com.huchuang.guangsanuser"],
                                      encoding: URLEncoding.default)
        default:
            if let _parameters = parameters {
                guard let jsonData = try? JSONSerialization.data(withJSONObject: _parameters, options: []) else {
                    return .requestPlain
                }
                return .requestCompositeData(bodyData: jsonData, urlParameters: [:])
            }
        }
        
        return .requestPlain
    }
    
    var method: Moya.Method { return APIAssistance.mothed(API: self) }
    
    var sampleData: Data{ return Data() }
    
    var validate: Bool { return false }
    
    var headers: [String : String]? {
        var contentType: String = "application/json; charset=utf-8"
        switch self {
        case .uploadFile(_, let fileType):
            contentType = fileType.rawValue
        case .uploadIcon(_):
            contentType = "image/jpeg"
        default:
            break
        }
        
        let userAgent: String = "\(Bundle.main.bundleIdentifier),\(Bundle.main.version),\(UIDevice.iosVersion),\(UIDevice.modelName)"
        
        
        let customHeaders: [String: String] = ["token": userDefault.token,
                                               "User-Agent": userAgent,
                                               "unitId": userDefault.unitId,
                                               "Content-Type": contentType,
                                               "Accept": "application/json"]
        PrintLog("request headers -- \(customHeaders)")
        return customHeaders
    }
    
}

//MARK:
//MARK: 请求参数配置
extension API {
    
    private var parameters: [String: Any]? {
        var params = [String: Any]()
        switch self {
        case .functionsMenu:
            params["facilityType"] = "APP"
        case .getUnreplyNum:
            break
        case .selectBanner(let code):
            params["code"] = code.rawValue
        case .validateCode(let mobile):
            params["mobile"] = mobile
        case .loginTel(let mobile, let smsCode):
            params["mobile"] = mobile
            params["smsCode"] = smsCode
        case .pwdLogin(let account, let psd):
            params["account"] = account
            params["psd"] = psd

        case .getConsultsPatientList(let pageNum, let pageSize, let searchName):
            params["pageNum"] = pageNum
            params["pageSize"] = pageSize
            params["searchName"] = searchName
        case .editUserMemberTags(let id, let tagName):
            params["id"] = id
            params["tagName"] = tagName
        case .getUserTagList(let memberId):
            params["memberId"] = memberId
        case .addUserMemberTags(let memberId, let tagName, let id):
            params["memberId"] = memberId
            params["tagName"] = tagName
            params["id"] = id
        case .removeUserTag(let memberId, let id):
            params["memberId"] = memberId
            params["id"] = id
        case .addUserTag(let tagName, let clinicId):
            params["tagName"] = tagName
            params["clinicId"] = clinicId

        case .getPatientConsultList(let pageNum, let pageSize, let sort, let replyStatus):
            params["pageNum"] = pageNum
            params["pageSize"] = pageSize
            params["sort"] = sort.rawValue
            params["replyStatus"] = replyStatus
        case .chatDetail(let consultId, let memberId):
            params["consultId"] = consultId
            params["memberId"] = memberId
        case .chatHistoryDetail(let memberId, let userId, let loadSize):
            params["memberId"] = memberId
            params["userId"] = userId
            params["loadSize"] = loadSize

        case .replyConsult(let content, let filePath, let bak, let consultId):
            params["content"] = content
            params["filePath"] = filePath
            params["bak"] = bak
            params["consultId"] = consultId
        case .updateConsultBlack(let memberId, let userId, let bak, let black):
            params["memberId"] = memberId
            params["userId"] = userId
            params["bak"] = bak
            params["black"] = black
        case .getHealthArchives(let memberId):
            params["memberId"] = memberId
        case .getPatientCoupleInfo(let memberId):
            params["memberId"] = memberId
        
        case .videoChatSignature(let userId):
            params["userId"] = userId
        case .consultVideoUserInfo(let memberId, let userId, let consultId):
            params["memberId"] = memberId
            params["userId"] = userId
            params["consultId"] = consultId
        case .consultReceivePhone(let memberId, let userId, let consultId):
            params["memberId"] = memberId
            params["userId"] = userId
            params["consultId"] = consultId
        case .consultStartPhone(let memberId, let userId):
            params["memberId"] = memberId
            params["userId"] = userId
        case .consultEndPhone(let memberId, let userId, let watchTime):
            params["memberId"] = memberId
            params["userId"] = userId
            params["watchTime"] = watchTime

        case .realNameAuth(let realName, let sex, let birthDay, let certificateType, let certificateNo):
            params["realName"] = realName
            params["sex"] = sex
            params["birthDay"] = birthDay
            params["certificateType"] = certificateType
            params["certificateNo"] = certificateNo
        case .accountSetting(let nickName, let headPath):
            params["nickName"] = nickName
            params["headPath"] = headPath
        case .attentionStore(let moduleType, let pageNum, let pageSize):
            params["moduleType"] = moduleType.rawValue
            params["pageNum"] = pageNum
            params["pageSize"] = pageSize
            
        case .UMAdd(let deviceToken):
            params["deviceToken"] = deviceToken
            params["appPackage"] = Bundle.main.bundleIdentifier
            params["appType"] = "ios"
        case .bindAuthMember(let userInfo, let mobile, let smsCode):
            params["openId"] = userInfo.openid
            params["accessToken"] = userInfo.accessToken
            params["appType"] = "IOS"
            params["oauthType"] = "weixin"
            params["mobile"] = mobile
            params["smsCode"] = smsCode
        case .updateInfo(let param):
            params = param

        case .noticeList(let type, let pageNum, let pageSize):
            params["type"] = type
            params["pageNum"] = pageNum
            params["pageSize"] = pageSize
        case .article(let id):
            params["id"] = id
        case .unitSetting(let type):
            params["settingCode"] = type.rawValue
        
        case .increReading(let id):
            params["id"] = id

        case .consultList(let pageNum, let pageSize):
            params["pageNum"] = pageNum
            params["pageSize"] = pageSize

//        case .allChannelArticle(let articleType, let pageNum, let pageSize):
//            params["unitId"] = userDefault.unitId
//            params["cmsCode"] = articleType.rawValue
//            params["pageNum"] = pageNum
//            params["pageSize"] = pageSize
        case .recommendDoctor(let areaCode, let lat, let lng):
            params["areaCode"] = areaCode
            params["lat"] = lat
            params["lng"] = lng
//        case .column(let cmsType):
//            params["cmsCode"] = cmsType.rawValue
        case .articlePage(let id, let pageNum, let pageSize):
            params["id"] = id
            params["unitId"] = userDefault.unitId
            params["pageNum"] = pageNum
            params["pageSize"] = pageSize
        case .consultSelectListPage(let pageNum, let pageSize, let searchName, let areaCode, let opType, let sceen):
            params["unitId"] = userDefault.unitId
            params["pageNum"] = pageNum
            params["pageSize"] = pageSize
            params["searchName"] = searchName
            params["areaCode"] = areaCode
            params["opType"] = opType
            params["sceen"] = sceen
        case .getUserInfo(let userId):
            params["userId"] = userId
        case .getAuthMember(let openId):
            params["openId"] = openId
            params["appType"] = "IOS"
            params["oauthType"] = "weixin"
        case .search(let pageNum, let pageSize, let searchModule, let searchName):
            if searchName.count > 0 {
                switch searchModule {
                case .all:
                    params["searchName"] = searchName
                default:
                    params["searchName"] = searchName
                    params["searchModule"] = searchModule.rawValue
                }
            }else {
                params["searchModule"] = searchModule.rawValue
//                params["searchName"] = ""
            }
            
            params["pageNum"] = pageNum
            params["pageSize"] = pageSize
        case .storeAndStatus(let articleId):
            params["articleId"] = articleId
        case .articelStore(let articleId, let status):
            params["articleId"] = articleId
            params["status"] = status
        case .mergePro(let opType, let date, let data):
            params["opType"] = opType.rawValue
            params["date"] = date
            params["data"] = data
        case .mergeWeekInfo(let id, let startDate, let keepDays, let next):
            params["id"] = id
            params["startDate"] = startDate
            params["keepDays"] = keepDays
            params["next"] = next
        default:
            return nil
        }
        return params
    }
}


//func stubbedResponse(_ filename: String) -> Data! {
//    @objc class TestClass: NSObject { }
//
//    let bundle = Bundle(for: TestClass.self)
//    let path = bundle.path(forResource: filename, ofType: "json")
//    return (try? Data(contentsOf: URL(fileURLWithPath: path!)))
//}

//MARK:
//MARK: API server
let HCProvider = MoyaProvider<API>(plugins: [MoyaPlugins.MyNetworkActivityPlugin,
                                             RequestLoadingPlugin()]).rx

/**
 yyyy, [22.12.19 09:48]
 https://ileyun.ivfcn.com/hc-patient/api/physiology/mergePro

 yyyy, [22.12.19 09:49]
 opType = knewRecord

 yyyy, [22.12.19 09:49]
 opType = ovulation

 yyyy, [22.12.19 09:49]
 opType = temperature
 */
