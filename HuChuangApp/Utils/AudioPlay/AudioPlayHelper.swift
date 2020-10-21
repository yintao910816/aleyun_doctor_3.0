//
//  AudioPlayHelper.swift
//  HuChuangApp
//
//  Created by yintao on 2020/6/20.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation
import AVFoundation

class AudioPlayHelper: NSObject {
    
    public static let share = AudioPlayHelper()
    
    private var currentURL: URL?

    override init() {
        super.init()
        
        TYDowloadManager.shared.finishDown = { [unowned self] in
            if self.currentURL == $0.1 {
                self.playMusic(filePath: TYFileManager.share.url(forAudio: $0.0))
            }
        }
        
        DPAudioPlayer.sharedInstance()?.playComplete = { [unowned self] in
            self.currentURL = nil
        }
    }
    
    public func prepare(with urlStr: String) {
        if TYFileManager.share.exist(audio: urlStr.md5) {
            self.playMusic(filePath: TYFileManager.share.url(forAudio: urlStr.md5))
        }else {
            if let downURL = URL(string: urlStr) {
                currentURL = downURL
                TYDowloadManager.shared.tyDowload(downURL)
            }
        }
    }
    
    public func playMusic(filePath: URL) {
        do {
            let audioData = try Data.init(contentsOf: filePath)
            DPAudioPlayer.sharedInstance()?.startPlay(with: audioData)
        } catch {
            PrintLog("播放失败")
        }
    }

    public func stop() {
        DPAudioPlayer.sharedInstance()?.stopPlaying()
    }
}
