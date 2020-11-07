//
//  TYChatKeyBoardView.swift
//  HuChuangApp
//
//  Created by yintao on 2020/6/18.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class TYChatKeyBoardView: UIView {

    private var bottomLineView: UIView!
    private var progressView: UIProgressView!
    // 切换语音发送
    private var exchangeVoiceButton : UIButton!
    // 还原系统键盘
//    private var showSystemKeyboardButton: UIButton!
    // 切换媒体发送键盘
    private var showMediaKeyboardButton: UIButton!
    // 录音按钮
    private var audioButton: ChatToolBarAudioButton!
    fileprivate var inputTf: TYTextInputView!

    public var mediaClickedCallBack:((Int)->())?
    public var sendAudioCallBack:(((Data, UInt))->())?
    public var sendTextCallBack:((String)->())?
    /// 点击右边多功能按钮
    public var clickedFuncCallBack:(()->())?

    deinit {
        PrintLog("释放了：\(self)")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .white
        
        bottomLineView = UIView()
        bottomLineView.backgroundColor = RGB(220, 220, 220)
        
        progressView = UIProgressView.init()
        progressView.trackTintColor = UIColor.groupTableViewBackground
        progressView.progressTintColor = UIColor.red
        
        // 显示语音播放
        exchangeVoiceButton = UIButton.init(type: .custom)
        exchangeVoiceButton.setImage(UIImage(named: "chat_input_voice"), for: .normal)
        exchangeVoiceButton.setImage(UIImage(named: "chat_input_keyboard"), for: .selected)
        exchangeVoiceButton.addTarget(self, action: #selector(exchangeRecordAudio), for: .touchUpInside)
        
        audioButton = ChatToolBarAudioButton.init()
        audioButton.delegate = self
        audioButton.isHidden = true
        
        inputTf = TYTextInputView()
        inputTf.placeholder = "请输入..."
        inputTf.returnKeyType = .send
        inputTf.tvdelegate = self
        inputTf.font = .font(fontSize: 14)
        inputTf.mediaClickedCallBack = { [unowned self] in self.mediaClickedCallBack?($0) }
                
//        showSystemKeyboardButton = UIButton.init(type: .system)
//        showSystemKeyboardButton.tintColor = UIColor.clear
//        showSystemKeyboardButton.setBackgroundImage(UIImage.init(named: "reply_button_shortcut"), for: .normal)
//        showSystemKeyboardButton.addTarget(self, action: #selector(showSystemKeyboardAction), for: .touchUpInside)
        
        showMediaKeyboardButton = UIButton.init(type: .custom)
        showMediaKeyboardButton.setImage(UIImage.init(named: "chat_input_add"), for: .normal)
        showMediaKeyboardButton.clipsToBounds = true
        showMediaKeyboardButton.addTarget(self, action: #selector(showMediaKeyboardAction), for: .touchUpInside)
        
        addSubview(bottomLineView)
        addSubview(progressView)
        addSubview(exchangeVoiceButton)
        addSubview(inputTf)
        insertSubview(audioButton, aboveSubview: inputTf)
//        addSubview(showSystemKeyboardButton)
        addSubview(showMediaKeyboardButton)
    }
    
        // 语音录制切换
    @objc private func exchangeRecordAudio() {
        exchangeVoiceButton.isSelected = !exchangeVoiceButton.isSelected
        audioButton.isHidden = !exchangeVoiceButton.isSelected
        audioButton.isHidden ? tf_becomeFirstResponder() : tf_resignFirstResponder()
    }

    @objc private func showSystemKeyboardAction() {
        inputTf.resetSystemKeyBoard()
    }
    
    @objc private func showMediaKeyboardAction() {
//        inputTf.mediaShow()
        inputTf.resignFirstResponder()
        clickedFuncCallBack?()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
                
        bottomLineView.frame = .init(x: 0, y: height - 1, width: width, height: 1)
        progressView.frame = .init(x: 0, y: 0, width: width, height: 2)
        exchangeVoiceButton.frame = .init(x: 10, y: (height - 25.0)/2.0, width: 25, height: 25)
        showMediaKeyboardButton.frame = .init(x: width - 10 - 25, y: (height - 25.0)/2.0, width: 25, height: 25)
//        showSystemKeyboardButton.frame = .init(x: showMediaKeyboardButton.frame.minX - 7 - 25,
//                                               y: showMediaKeyboardButton.frame.minY,
//                                               width: 25, height: 25)
//        inputTf.frame = .init(x: exchangeVoiceButton.frame.maxX + 7, y: (height - 30.0)/2.0,
//                              width: showSystemKeyboardButton.frame.minX - exchangeVoiceButton.frame.maxX - 7 - 7,
//                              height: 30)
        
        inputTf.frame = .init(x: exchangeVoiceButton.frame.maxX + 7, y: (height - 30.0)/2.0,
                              width: showMediaKeyboardButton.frame.minX - exchangeVoiceButton.frame.maxX - 7 - 7,
                              height: 30)
        audioButton.frame = inputTf.frame
    }
}

//MARK: -- 接口
extension TYChatKeyBoardView {
    
    public func tf_becomeFirstResponder() {
        if inputTf.isFirstResponder == false {
            inputTf.becomeFirstResponder()
        }
    }
    
    public func tf_resignFirstResponder() {
        if inputTf.isFirstResponder == true {
            inputTf.resignFirstResponder()
        }
    }
}

//MARK:
//MARK: UITextViewDelegate
extension TYChatKeyBoardView: PlaceholderTextViewDelegate {
    
    func tv_textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func tv_textViewDidEndEditing(_ textView: UITextView) {
        inputTf.mediaHidden()
    }
    
    func tv_textView(_ textView: PlaceholderTextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            inputTf.mediaHidden()
            tf_resignFirstResponder()
            if inputTf.text.count > 0 {
                sendTextCallBack?(inputTf.text)
                inputTf.text = ""
            }
        }
        return true
    }

}

extension TYChatKeyBoardView: DPChatToolBarAudioDelegate {
    
    func dpAudioRecordingFinish(with audioData: Data!, withDuration duration: UInt) {
        progressView.setProgress(0, animated: true)
        sendAudioCallBack?((audioData, duration))
    }
    
    func dpAudioSpeakPower(_ power: Float) {
        progressView.setProgress(power, animated: true)
    }
    
    func dpAudioRecordingFail(_ reason: String!) {
        NoticesCenter.alert(title: "录制失败", message: reason)
        progressView.setProgress(0, animated: true)
    }
    
    func dpAudioStartRecording(_ isRecording: Bool) {
        
    }
}

