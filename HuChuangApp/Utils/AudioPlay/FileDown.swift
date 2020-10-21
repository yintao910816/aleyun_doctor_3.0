//
//  FileDown.swift
//  HuChuangApp
//
//  Created by yintao on 2020/6/20.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation
import Alamofire

class TYDowloadManager {
    static let shared = TYDowloadManager()
    private var currentDownloadRequest: DownloadRequest?
    private var manager: SessionManager!
    private var resumeData: Data?
    private var downloadTasks: Array<URLSessionDownloadTask>?
    
    /// （文件下载完成缓存路径，文件下载地址）
    public var finishDown: (((String,URL))->())?
    
    private var filePath: URL{
        return URL(fileURLWithPath: TYFileManager.share.tempFilePath)
    }
    
    private var cachePath: URL{
        return URL(fileURLWithPath: TYFileManager.share.audioPath)
    }
    
    init() {
        prepareSessionManager()
    }

    private func prepareSessionManager() {
        let configuration = URLSessionConfiguration.background(withIdentifier: "com.lgcooci.AlamofireDowload")
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.sharedContainerIdentifier = "group.com.lgcooci.AlamofireDowload"
        manager = SessionManager(configuration: configuration)
        manager.startRequestsImmediately = true
        manager.backgroundCompletionHandler = {
            debugPrint("后台完成回来了")
        }
        // 用户kill 进来
        manager.delegate.taskDidComplete = { (seesion,task, error) in
            if let error = error {
                print("taskDidComplete的error情况: \(error)")
                if let resumeData = (error as NSError).userInfo[NSURLSessionDownloadTaskResumeData] as? Data {
                    // resumeData 存储
                    TYDowloadManager.shared.resumeData = resumeData
                    print("来了")
                }
            }else{
                print("taskDidComplete的task情况: \(task)")
            }
        }
        
        manager.session.getTasksWithCompletionHandler({ (dataTasks, uploadTask, downloadTasks) in
            print("回调监控: \(downloadTasks)")
        })
        
        manager.delegate.downloadTaskDidFinishDownloadingToURL = { (session, downloadTask, url) in

//            guard let response = downloadTask.response as? HTTPURLResponse else {return}
            var fileName: String = ""
            if let downURL = downloadTask.currentRequest?.url?.absoluteString {
                fileName = downURL.md5
            }else {
                let timeInterval: TimeInterval = Date().timeIntervalSince1970
                fileName = "\(Int(timeInterval))"
            }
            if TYFileManager.share.moveAudio(at: url, fileName: fileName), let down = downloadTask.currentRequest?.url {
                TYDowloadManager.shared.finishDown?((fileName, down))
            }
        }

    }
    
    //MARK: - 下载封装入口 - 断点续传
    @discardableResult
    public func tyDowload(_ url: URLConvertible) -> DownloadRequest {
        
        if self.resumeData != nil {
            currentDownloadRequest = TYDowloadManager.shared.manager.download(resumingWith: self.resumeData!)
        }else{
            if let resumeData = TYDowloadManager.shared.currentDownloadRequest?.resumeData {
                currentDownloadRequest = TYDowloadManager.shared.manager.download(resumingWith: resumeData)
            }else{
                currentDownloadRequest = TYDowloadManager.shared.manager.download(url) { [weak self](url, reponse) -> (destinationURL: URL, options: DownloadRequest.DownloadOptions) in
                    let fileUrl = self?.filePath.appendingPathComponent(reponse.suggestedFilename!)
                    return (fileUrl!,[.removePreviousFile, .createIntermediateDirectories] )
                }
            }
        }
        return currentDownloadRequest!
    }
    
    //MARK: - 暂停/继续/取消
    public func suspend() {
        self.currentDownloadRequest?.suspend()
    }
    
    public func resume() {
        self.currentDownloadRequest?.resume()
    }
    
    public func cancel() {
        self.currentDownloadRequest?.cancel()
    }
    
    public func clear() {
        let filePath = TYFileManager.share.tempFilePath
        if FileManager.default.fileExists(atPath: filePath) {
            try! FileManager.default.removeItem(at: self.filePath)
            print("清理完成")
        }
    }
}
