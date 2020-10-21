//
//  FileManager.swift
//  HuChuangApp
//
//  Created by yintao on 2020/6/20.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

class TYFileManager {
    
    static let share = TYFileManager()

    private let docuPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    private var audioFolderPath = ""
    private var tempFileFolderPath = ""

    init() {
        audioFolderPath = docuPath + "/AudioCache/"
        tempFileFolderPath = docuPath + "/tempCache/"

        do {
            if !FileManager.default.fileExists(atPath: audioFolderPath) {
                try FileManager.default.createDirectory(atPath: audioFolderPath, withIntermediateDirectories: true, attributes: nil)
            }
            if !FileManager.default.fileExists(atPath: tempFileFolderPath) {
                try FileManager.default.createDirectory(atPath: tempFileFolderPath, withIntermediateDirectories: true, attributes: nil)
            }
            PrintLog("audioFolderPath -- \(audioFolderPath) \n tempFileFolderPath -- \(tempFileFolderPath)")
        } catch {
            PrintLog("create folder fail")
        }
    }
    
    public var tempFilePath: String {
        get {
            return tempFileFolderPath
        }
    }
    
    public var audioPath: String {
        get {
            return audioFolderPath
        }
    }
}

extension TYFileManager {
    
    @discardableResult
    public func saveAudio(fileName: String, data :Data) -> String {
        let path  = audioFolderPath + "\(fileName)"
        try? data.write(to: URL.init(fileURLWithPath: path))
        PrintLog("audio save success")
        return path
    }
    
    public func url(forAudio fileName: String) ->URL {
        let path  = audioFolderPath + "\(fileName)"
        return URL(fileURLWithPath: path)
    }

    @discardableResult
    public func moveAudio(at url: URL, fileName: String) ->Bool {
        let path  = audioFolderPath + "\(fileName)"
        let destination = URL(fileURLWithPath: path)
        do {
            if exist(of: path) {
                try FileManager.default.removeItem(at: destination)
            }
            try FileManager.default.moveItem(at: url, to: destination)
            PrintLog("文件成功移动成功：\n 移动到：\(destination) \n 源文件路径：\(url)")
            return true
        } catch {
            PrintLog("文件成功移动失败：\(error) \n 移动到：\(destination) \n 源文件路径：\(url)")
        }
        return false
    }

    public func exist(of path: String) ->Bool {
        return FileManager.default.fileExists(atPath: path)
    }
    
    public func exist(audio fileName: String) ->Bool {
        let path  = audioFolderPath + "\(fileName)"
        return exist(of: path)
    }
}
