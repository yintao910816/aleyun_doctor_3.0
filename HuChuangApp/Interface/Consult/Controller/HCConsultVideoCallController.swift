//
//  HCConsultVideoCallController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/11/6.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCConsultVideoCallController: BaseViewController{

    private var trtcManager: HCTRTCCloudManager!
        
    override func setupUI() {
        if let userId = HCHelper.share.userInfoModel?.uid {
            self.trtcManager = HCTRTCCloudManager.init(roomId: 777777, userId: userId)
            self.trtcManager.enterRoom()
        }
    }

}
