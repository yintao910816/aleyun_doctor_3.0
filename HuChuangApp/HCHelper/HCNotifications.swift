//
//  HCNotifications.swift
//  HuChuangApp
//
//  Created by sw on 13/02/2019.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation

typealias NotificationName = Notification.Name

extension Notification.Name {
    
    public struct User {
        /**
         * 登录成功，需要重新拉取数据和重新向app后台上传umtoken的界面可接受此通知
         */
        static let LoginSuccess = Notification.Name(rawValue: "org.user.notification.name.loginSuccess")
        /// 编辑别名
        static let EditAlias = Notification.Name(rawValue: "org.user.notification.name.editAlias")
    }
    
    public struct UserInterface {
        /// 连续2次点击同一个tabBar
        static let tabBarSelectedTwice = Notification.Name(rawValue: "org.UserInterface.notification.name.tabBarSelectedTwice")
        /// 跳转首页
        static let selectedHomeTabBar = Notification.Name(rawValue: "org.UserInterface.notification.name.selectedHomeTabBar")

        static let webHistoryItemChanged = Notification.Name(rawValue: "WebHistoryItemChangedNotification")
        /// js通知刷新首页数据
        static let jsReloadHome = Notification.Name(rawValue: "org.UserInterface.notification.name.jsReloadHome")
        /// 记录对比时同步滚动
        static let recordScroll = Notification.Name(rawValue: "org.UserInterface.notification.name.recordScroll")
        
        /// 跳转咨询列表
        static let consultList = Notification.Name(rawValue: "org.UserInterface.notification.name.consultList")
    }
    
    public struct UILogic {
        /// 首页文章更多点击跳转课程tab
        static let gotoClassRoom = Notification.Name(rawValue: "org.UILogic.notification.name.gotoClassRoom")
        /// 首页顶部红色背景点击跳转记录界面
        static let gotoRecord = Notification.Name(rawValue: "org.UILogic.notification.name.gotoRecord")
    }
    
    public struct Pay {
        /// 微信支付完成
        static let wChatPayFinish = Notification.Name(rawValue: "org.Pay.notification.name.wChatPayFinish")
    }
    
    public struct Patient {
        /// 患者管理 - 修改分组
        static let changedTagName = Notification.Name(rawValue: "org.UILogic.notification.name.changedTagName")
    }
    
    public struct ChatCall {
        /// 发起视频通话对方接受
        static let videoCallAccept = Notification.Name(rawValue: "org.UILogic.notification.name.videoCallAccept")
        /// 对方离开通话
        static let otherLeaveVideoCall = Notification.Name(rawValue: "org.UILogic.notification.name.otherLeaveVideoCall")
        /// 对方拒绝通话
        static let otherRejectVideoCall = Notification.Name(rawValue: "org.UILogic.notification.name.otherRejectVideoCall")
        /// 占线中 onLineBusy
        static let onLineBusyVideoCall = Notification.Name(rawValue: "org.UILogic.notification.name.onLineBusyVideoCall")
        /// 获取到了总共通话时长
        static let totleCallTime = Notification.Name(rawValue: "org.UILogic.notification.name.totleCallTime")
        /// 铃声播放完成还未接通  / 通话时长已到
        static let finishAudio = Notification.Name(rawValue: "org.UILogic.notification.name.finishAudio")
    }

    public struct ConsultSetting {
        /// 图文咨询设置修改
        static let picSettingChanged = Notification.Name(rawValue: "org.UILogic.notification.name.picSettingChanged")
        /// 视频咨询设置修改
        static let videoSettingChanged = Notification.Name(rawValue: "org.UILogic.notification.name.videoSettingChanged")
        /// 精准预约设置修改
        static let querySettingChanged = Notification.Name(rawValue: "org.UILogic.notification.name.querySettingChanged")
    }

    public struct FastReply {
        /// 添加快捷回复
        static let add = Notification.Name(rawValue: "org.UILogic.notification.name.FastReply.add")
        /// 修改快捷回复
        static let edit = Notification.Name(rawValue: "org.UILogic.notification.name.FastReply.edit")
        /// 删除快捷回复
        static let del = Notification.Name(rawValue: "org.UILogic.notification.name.FastReply.del")
    }

    public struct Consult {
        /// 咨询状态发生改变
        static let statusChange = Notification.Name(rawValue: "org.UILogic.notification.name.Consult.statusChange")
    }

    public struct Message {
        /// 刷新未读数
        static let unreadMessageCount = Notification.Name(rawValue: "org.UILogic.notification.name.message.unreadMessageCount")
    }
}
