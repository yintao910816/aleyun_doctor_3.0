//
//  APIServer.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/7/24.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import Foundation
import Moya
import enum Result.Result
import Alamofire

struct MoyaPlugins {
    
    static let MyNetworkActivityPlugin = NetworkActivityPlugin { (change, _) -> () in
        DispatchQueue.main.async {
            switch(change){
            case .ended:
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            case .began:
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
        }
    }
    
//    static let requestTimeoutClosure = {(endpoint: Endpoint<API>, done: @escaping MoyaProvider<API>.RequestResultClosure) in
//        guard var request = endpoint.urlRequest else { return }
//
//        request.timeoutInterval = 30    //设置请求超时时间
//        done(.success(request))
//    }
    
}

public final class RequestLoadingPlugin: PluginType {

    public func willSend(_ request: RequestType, target: TargetType) {
        let api = target as! API    
        #if DEBUG
            switch api.task {
            case .requestParameters(let parameters, _):
                let apath = api.baseURL.absoluteString + api.path + ((parameters as NSDictionary?)?.keyValues() ?? "")
                print("发送请求地址：\(apath)")
            default:
                print("发送请求地址：\(api.baseURL.absoluteString + api.path)")
            }
        #endif

    }
    
    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        
        switch result {
        case .success(let response):
            do {
                let json = try JSONSerialization.jsonObject(with: response.data, options: .allowFragments)
                
                
                guard let rdic = json as? [String : Any] else { return }
                
                guard let code = rdic["code"] as? Int else { return }
                
                PrintLog("返回json -- \(target) --\n \(rdic)")

                PrintLog("是否重新显示登录界面：\(code) - \(HCHelper.share.isPresentLogin) - \(!HCHelper.share.isShowLanuch)")
                if code == RequestCode.invalid.rawValue && HCHelper.share.isPresentLogin == false && !HCHelper.share.isShowLanuch {
                    HCHelper.presentLogin()
                }

                switch (target as! API) {
                case .loginTel(_, _), .accountSetting(_, _), .updateExtInfo(_):
                    let infoDic = (rdic["data"] as? [String : Any] ?? [:])
                    userDefault.loginInfoString = infoDic.getJSONString()
                    break
                default:
                    break
                }
                
            } catch  {
                PrintLogDetail(error)
            }
        case .failure(let error):
            PrintLogDetail(error)
        }
    }
}

extension NSDictionary {
    
    /// 将字典转中的键值对转化到url中
    ///
    /// - Parameter params: 键值对
    /// - Returns: url 字符串
    public func keyValues() ->String {
        if allValues.count <= 0 {
            return ""
        }
        
        let string = NSMutableString.init(string: "?")
        enumerateKeysAndObjects({ (key, value, stop) in
            string.append("\(key)=\(value)&")
        })
        
        let range = string.range(of: "&", options: .backwards)
        string.deleteCharacters(in: range)
        return string as String
    }
    
    
    open override var debugDescription: String {
        get {
            do {
                let dicData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
                guard let r = String.init(data: dicData, encoding: .utf8) else {
                    return "打印失败"
                }
                return r
            } catch {
                return "打印失败"
            }
        }
    }
    
}

// 参考文章： https://www.jianshu.com/p/19f3d02739ff
struct JSONArrayEncoding: ParameterEncoding {
    static let `default` = JSONArrayEncoding()

    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()

        guard let json = parameters?["jsonArray"] else {
            return request
        }

        let data = try JSONSerialization.data(withJSONObject: json, options: [])

//        if request.value(forHTTPHeaderField: "Content-Type") == nil {
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        }

        request.httpBody = data

        return request
    }
}
