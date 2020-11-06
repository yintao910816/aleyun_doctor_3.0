//
//  HCAppDelegate+TRTC.swift
//  HuChuangApp
//
//  Created by yintao on 2020/11/6.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

extension HCAppDelegate: TRTCCallingDelegate {

    // 被邀请通话
    func onInvited(sponsor: String, userIds: [String], isFromGroup: Bool, callType: CallType) {
        var curUser = CallingUserModel()
        curUser.name = "对方用户名"
        curUser.avatarUrl = ""
        curUser.userId = sponsor
        curUser.isVideoAvaliable = true
        curUser.isEnter = true
        
        let callVC = HCConsultVideoCallController(sponsor: curUser)
        
        callVC.dismissBlock = { }
        
        callVC.modalPresentationStyle = .fullScreen
        callVC.resetWithUserList(users: [curUser], isInit: true)
        NSObject().visibleViewController?.present(callVC, animated: true, completion: nil)        
    }
    
    // 进入通话回调
    func onUserEnter(uid: String) {
        var curUser = CallingUserModel()
        curUser.name = "对方用户名"
        curUser.avatarUrl = ""
        curUser.userId = uid
        curUser.isVideoAvaliable = true
        curUser.isEnter = true
        NotificationCenter.default.post(name: NotificationName.ChatCall.videoCallAccept, object: curUser)
    }
    
    // 离开通话回调
    func onUserLeave(uid: String) {
        NotificationCenter.default.post(name: NotificationName.ChatCall.otherLeaveVideoCall, object: nil)
    }
    
    // 拒绝通话回调-仅邀请者受到通知,其他用户应使用
    func onReject(uid: String) {
        NotificationCenter.default.post(name: NotificationName.ChatCall.otherRejectVideoCall, object: nil)
    }
    
    // 无回应回调-仅邀请者受到通知，其他用户应使用
    func onNoResp(uid: String) {
        
    }
            
    // 通话占线回调-仅邀请者受到通知，其他用户应使用
    func onLineBusy(uid: String) {
        NotificationCenter.default.post(name: NotificationName.ChatCall.onLineBusyVideoCall, object: nil)
    }
    
    // 当前通话被取消回调
    func onCallingCancel(uid: String) {
        
    }
    
    // 通话超时的回调
    func onCallingTimeOut() {
        
    }

    // 通话结束
    func onCallEnd() {
        
    }
}
