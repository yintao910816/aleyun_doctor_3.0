//
//  TResponse+ModelMapper.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/10/9.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import Foundation
import Moya
import HandyJSON

public extension Response {
    
    internal func mapResponse() throws -> ResponseModel {
        guard let jsonDictionary = try mapJSON() as? NSDictionary else {
            throw MapperError.json(message: "json解析失败", code: 0)
        }
        
        guard let serverModel = JSONDeserializer<ResponseModel>.deserializeFrom(dict: jsonDictionary) else {
            throw MapperError.json(message: "json解析失败", code: 0)
        }
        
        if serverModel.code == RequestCode.success.rawValue {
            return serverModel
        }else {
            throw MapperError.server(message: serverModel.message, code: serverModel.code)
        }
    }
    
    internal func map<T: HandyJSON>(model type: T.Type) throws -> T {
        guard let jsonDictionary = try mapJSON() as? NSDictionary else {
            throw MapperError.json(message: "json解析失败", code: 0)
        }
        guard let serverModel = JSONDeserializer<DataModel<T>>.deserializeFrom(dict: jsonDictionary) else {
            throw MapperError.json(message: "json解析失败", code: 0)
        }
        
        if serverModel.code == RequestCode.success.rawValue  {
            return serverModel.data ?? T()
        }else {
            throw MapperError.server(message: serverModel.message, code: serverModel.code)
        }
    }
    
    internal func map<T: HandyJSON>(model type: T.Type) throws -> [T] {
        guard let jsonDictionary = try mapJSON() as? NSDictionary else {
            throw MapperError.json(message: "json解析失败", code: 0)
        }
        guard let serverModel = JSONDeserializer<DataModel<[T]>>.deserializeFrom(dict: jsonDictionary) else {
            throw MapperError.json(message: "json解析失败", code: 0)
        }
    
        if serverModel.code == RequestCode.success.rawValue {
            return serverModel.data ?? [T]()
        }else {
            throw MapperError.server(message: serverModel.message, code: serverModel.code)
        }
    }
    
    internal func map<T: HandyJSON>(result type: T.Type) throws -> DataModel<T> {
        guard let jsonDictionary = try mapJSON() as? NSDictionary else {
            throw MapperError.json(message: "json解析失败", code: 0)
        }
        
        guard let serverModel = JSONDeserializer<DataModel<T>>.deserializeFrom(dict: jsonDictionary) else {
            throw MapperError.json(message: "json解析失败", code: 0)
        }
        
        return serverModel
//        if serverModel.code == RequestCode.success.rawValue {
//            return serverModel
//        }else {
//            throw MapperError.server(message: serverModel.message)
//        }
    }
    
    internal func map<T: HandyJSON>(result type: T.Type) throws -> DataModel<[T]> {
        guard let jsonDictionary = try mapJSON() as? [String: Any] else {
            throw MapperError.json(message: "json解析失败", code: 0)
        }
        
        guard let serverModel = JSONDeserializer<DataModel<[T]>>.deserializeFrom(dict: jsonDictionary) else {
            throw MapperError.json(message: "json解析失败", code: 0)
        }

        if serverModel.code == RequestCode.success.rawValue {
            return serverModel
        }else {
            throw MapperError.server(message: serverModel.message, code: serverModel.code)
        }
    }
    
}

enum MapperError: Swift.Error {
    case ok(message: String?, code: Int)
    case json(message: String?, code: Int)
    case server(message: String?, code: Int)
}

extension MapperError {
    
    public var message: String {
        switch self {
        case .ok(let text, _):
            return (text ?? "操作成功!")
        case .json(let text, _):
            return (text ?? "解析失败！")
        case .server(let text, _):
            return text ?? "错误：52000"
        }
    }
    
    public var code: Int {
        switch self {
        case .server(_, let code):
            return code
        default:
            return 0
        }
    }
}
