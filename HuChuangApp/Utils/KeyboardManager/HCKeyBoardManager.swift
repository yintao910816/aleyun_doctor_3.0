//
//  HCKeyBoardManager.swift
//  HuChuangApp
//
//  Created by yintao on 2020/12/30.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

class HCKeyBoardManager {
    
    private var keyboardFlag: Int = 0 // 键盘弹起情况，收起=0
    private var deltaHeight: CGFloat = 0 // 键盘与输入框间距
    private var inputBottomHeight: CGFloat = 0 // 输入框底部到页面底部距离
    private var transformDistance: CGFloat = 0 // 页面移动距离
    
    // 相当于控制器的self.view
    private var containerView: UIView!
    // 输入框
    private var inputView: UIView!
    //
    private var moveView: UIView!
    
    public func prepare(containerView: UIView, inputView: UIView, moveView: UIView) {
        self.containerView = containerView
        self.inputView = inputView
        self.moveView = moveView
    }
    
    public final func registerNotification() {
        // 键盘弹出监听，解决键盘挡住输入框的问题
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(keyboardWillAppear),
                                                   name: UIResponder.keyboardWillShowNotification,
                                                   object: nil)
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(keyboardHasAppear),
                                                   name: UIResponder.keyboardDidShowNotification,
                                                   object: nil)
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(keyboardWillDisappear),
                                                   name: UIResponder.keyboardWillHideNotification,
                                                   object: nil)
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(keyboardFrameDidChange),
                                                   name: UIResponder.keyboardDidChangeFrameNotification,
                                                   object: nil)
    }
    
    public final func removeNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
    }
}

extension HCKeyBoardManager {
    
    @objc
    func keyboardWillAppear(noti: Notification) {
        // 获得软键盘的高
        let keyboardSize = (noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let keyboardHeight = keyboardSize?.height

        // 计算输入框和软键盘的高度差
        let rect = inputView.convert(inputView.bounds,
                     to: containerView) // 将rect由rect所在视图转换到目标视图view中，返回在目标视图view中的rect

        inputBottomHeight = containerView.height - (rect.origin.y + rect.size.height)
        deltaHeight = (keyboardHeight ?? 0) - inputBottomHeight

        if keyboardFlag == 0, deltaHeight > 0 { // 键盘原来是收起的，且遮挡输入框
//            moveView.transform = CGAffineTransform(a: 1, b: 0, c: 0, d: 1,
//                                                                 tx: 0, ty: -deltaHeight - 4)
            moveView.transform = CGAffineTransform(translationX: 0, y: -deltaHeight - 4)
            transformDistance = -deltaHeight - 4
            /* -4：为了使键盘距离输入框底部距离为4pt，该值可改 */
        }
    }
    
    @objc
    func keyboardHasAppear() {
        keyboardFlag = 1 // 键盘已弹出
    }

    @objc
    func keyboardWillDisappear() {
        if keyboardFlag == 0 {
            // 软键盘收起的时候恢复原始偏移
            moveView.transform = CGAffineTransform.identity
            transformDistance = 0
        }
    }
    
    @objc
    func keyboardFrameDidChange(noti: Notification) {
        // 获得软键盘的高
        let keyboardSize = (noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let keyboardHeight = keyboardSize?.height

        // 计算输入框和软键盘的高度差
        deltaHeight = (keyboardHeight ?? 0) - (inputBottomHeight + transformDistance)

        // 键盘在弹出的情况下如果frame有变化就改变输入框位置
        if self.keyboardFlag == 1 {
            // 如果页面之前没有上移，键盘遮挡输入框，页面上移; 页面之前有上移，输入框下降到键盘上方4pt处
            if (transformDistance == 0 && deltaHeight > 0) || (transformDistance != 0) {
//                moveView.transform = CGAffineTransform(a: 1, b: 0, c: 0, d: 1,
//                                                                     tx: 0, ty: -deltaHeight - 4)
                moveView.transform = CGAffineTransform(translationX: 0, y: -deltaHeight - 4)
                transformDistance = -deltaHeight - 4
            }
        }
    }
}
