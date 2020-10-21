//
//  TYTextInputView.swift
//  HuChuangApp
//
//  Created by yintao on 2020/6/18.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class TYTextInputView: PlaceholderTextView {

    private var mediaView: TYTextInputMediaView!

    public var mediaClickedCallBack:((Int)->())?
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }

    private func setupView() {
        mediaView = TYTextInputMediaView.init(datasource: ["chat_add_image"])
        mediaView.delegate = self
    }
}

//MARK: -- 接口
extension TYTextInputView {
    
    public func mediaShow() {
        if inputView == mediaView {
            inputView = nil
            reloadInputViews()
            if isFirstResponder == true { resignFirstResponder() }
        }else {
            inputView = mediaView
            reloadInputViews()
            if isFirstResponder == false { becomeFirstResponder() }
        }
    }
    
    public func mediaHidden() {
        if inputView != nil {
            inputView = nil
            reloadInputViews()
        }
        
        if isFirstResponder == true { resignFirstResponder() }
    }
    
    public func resetSystemKeyBoard(reload: Bool = true) {
        inputView = nil
        if reload == true { reloadInputViews() }
    }
}

extension TYTextInputView: MediaProtocol {
    
    func mediaItem(selected idx: Int) {
        mediaClickedCallBack?(idx)
        resignFirstResponder()
    }
}
