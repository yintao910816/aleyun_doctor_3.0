//
//  HCConsultDetail.swift
//  HuChuangApp
//
//  Created by yintao on 2020/5/23.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

enum HCConsultType: Int {
    /// 单次图文
    case picAndText = 0
    /// 聊天咨询
    case chatConsult
    /// 视屏咨询
    case videoConsult
    
    public var typeText: String {
        switch self {
        case .picAndText:
            return "单次图文"
        case .chatConsult:
            return "聊天咨询"
        case .videoConsult:
            return "视屏咨询"
        }
    }
    
    public var typeContentColor: UIColor {
        switch self {
        case .picAndText:
            return RGB(255, 153, 0)
        case .chatConsult:
            return HC_MAIN_COLOR
        case .videoConsult:
            return HC_MAIN_COLOR
        }
    }
    
    public var typeBGColor: UIColor {
        switch self {
        case .picAndText:
            return RGB(255, 248, 238)
        case .chatConsult:
            return RGB(238, 251, 249)
        case .videoConsult:
            return RGB(238, 251, 249)
        }
    }
}

enum HCReplyStatus: Int {
    /// 未回复
    case unReplay = 0
    /// 已回复
    case replay
    /// 已退回
    case back
    /// 已评论（完结）
    case finish
    
    public var statusText: String {
        switch self {
        case .unReplay:
            return "待回复"
        case .replay:
            return "已回复"
        case .back:
            return "已退回"
        case .finish:
            return "已评论（完结）"
        }
    }
    
    public var statusColor: UIColor {
        switch self {
        case .unReplay:
            return RGB(253, 164, 60)
        case .replay:
            return HC_MAIN_COLOR
        case .back ,.finish:
            return RGB(136, 136, 136)
        }
    }
}

class HCConsultDetailModel: HJModel {
    var records: [HCConsultDetailItemModel] = []
}

class HCConsultDetailItemModel: HJModel {
    var id: String = ""
    var memberId: String = ""
    var memberName: String = ""
    var userId: String = ""
    var userName: String = ""
    var content: String = ""
    var filePaths: String = ""
    var fileList: [HCConsultDetailFileModel] = []
    var newConsultUserId: String = ""
    var replyStatus: Int = 0
    var reviewNumber: String = ""
    var paymentStatus: String = ""
    var createDate: String = ""
    var headPath: String = ""
    var code: String = ""
    var price: String = ""
    var consultReplies: String = ""
    var consultList: [HCConsultDetailConsultListModel] = []
    var type: Int = 0
    var unit: String = ""
    var withDrawReason: String = ""
    var question: String = ""
    // 患者所在分组
    var tagName: String = ""
    // 患者备注
    var bak: String = ""
    var black: Bool = false
    var age: String = ""
    var consultAgain: String = ""
    var startDate: String = ""
    var endDate: String = ""
    var unitName: String = ""
    var read: String = ""
    
    private var timeFrame: CGRect?
    private var contentBgFrame: CGRect?
    private var desInfoTitleFrame: CGRect?
    private var contentTextFrame: CGRect?
    private var desPhotoTitleFrame: CGRect?
    private var boxPhotoFrame: CGRect?

    private var sectionHeaderSize: CGSize?
    
    //咨询记录
    private var titleFrame: CGRect = .zero
    private var subTitleFrame: CGRect = .zero
    private var statusFrame: CGRect = .zero
    
    public var getTimeFrame: CGRect {
        get {
            if timeFrame == nil {
                timeFrame = .init(x: 15, y: 10, width: PPScreenW - 30, height: 20)
            }
            return timeFrame!
        }
    }
    
    public var getDesInfoTitleFrame: CGRect {
        get {
            if desInfoTitleFrame == nil {
                desInfoTitleFrame = .init(x: 12, y: 14, width: 70, height: 20)
            }
            return desInfoTitleFrame!
        }
    }
    
    public var getContentTextFrame: CGRect {
        get {
            if contentTextFrame == nil {
                let contentTextSize = content.ty_textSize(font: .font(fontSize: 14),
                                                          width: PPScreenW - 112 - 25,
                                                          height: CGFloat(MAXFLOAT))
                contentTextFrame = .init(x: getDesInfoTitleFrame.maxX + 15,
                                         y: getDesInfoTitleFrame.minY,
                                         width: contentTextSize.width,
                                         height: contentTextSize.height)
            }
            return contentTextFrame!
        }
    }

    public var getDesPhotoTitleFrame: CGRect {
        get {
            if desPhotoTitleFrame == nil {
                if fileList.count > 0 {
                    desPhotoTitleFrame = .init(x: getDesInfoTitleFrame.maxX,
                                               y: getContentTextFrame.maxY + 15,
                                               width: 70,
                                               height: 20)
                }else {
                    desPhotoTitleFrame = .zero
                }
            }
            return desPhotoTitleFrame!
        }
    }

    public var getBoxPhotoFrame: CGRect {
        get {
            if boxPhotoFrame == nil {
                let boxSize = HCBoxPhotoView.contentSize(with: fileList.count)
                boxPhotoFrame = .init(x: getDesPhotoTitleFrame.maxX + 15,
                                      y: getDesPhotoTitleFrame.minY,
                                      width: boxSize.width,
                                      height: boxSize.height)
            }
            return boxPhotoFrame!
        }
    }

    public var getContentBgFrame: CGRect {
        get {
            if contentBgFrame == nil {
                var height: CGFloat = 0
                height += max(20, getContentTextFrame.height)
                if fileList.count > 0 {
                    height += (15 + getBoxPhotoFrame.height)
                }
                height += 14

                contentBgFrame = .init(x: 15,
                                       y: getTimeFrame.maxY + 10,
                                       width: PPScreenW - 30,
                                       height: height)
            }
            return contentBgFrame!
        }
    }
    
    public var getSectionHeaderSize: CGSize {
        get {
            if sectionHeaderSize == nil {
                sectionHeaderSize = .init(width: PPScreenW, height: getContentBgFrame.maxY)
            }
            return sectionHeaderSize!
        }
    }
    
    //MARK:
    //MARK: 咨询记录 - header
    
    public var isChatConsult: Bool {
        if let t = HCConsultType.init(rawValue: type) {
            return t == .chatConsult
        }
        return false
    }
    
    public var titleText: String {
        return "【\(userName)】"
    }
    
    public var subTitleText: String {
        if let t = HCConsultType.init(rawValue: type) {
            return t.typeText
        }
        return "单次图文"
    }
    public var subTitleColor: UIColor {
        if let t = HCConsultType.init(rawValue: type) {
            return t.typeContentColor
        }
        return RGB(255, 153, 0)
    }
    
    public var statusText: String {
        if let t = HCReplyStatus.init(rawValue: replyStatus) {
            return t.statusText
        }
        return "未回复"
    }
    public var statusColor: UIColor {
        if let t = HCReplyStatus.init(rawValue: replyStatus) {
            return t.statusColor
        }
        return RGB(253, 164, 60)
    }

    public var headerHeight: CGFloat {
        return 33
    }
    
    public var getTitleFrame: CGRect {
        get {
            if titleFrame == .zero {
                let w = titleText.ty_textSize(font: .font(fontSize: 13, fontName: .PingFMedium), width: CGFloat(MAXFLOAT), height: 15).width
                titleFrame = .init(x: 15, y: (headerHeight - 15) / 2.0, width: w, height: 15)
            }
            return titleFrame
        }
    }
    
    public var getSubTitleFrame: CGRect {
        get {
            if subTitleFrame == .zero {
                let w = subTitleText.ty_textSize(font: .font(fontSize: 11, fontName: .PingFRegular), width: CGFloat(MAXFLOAT), height: 18).width + 20
                subTitleFrame = .init(x: getTitleFrame.maxX + 10, y: (headerHeight - 18) / 2.0, width: w, height: 18)
            }
            return subTitleFrame
        }
    }
    
    public var getStatusFrame: CGRect {
        get {
            if statusFrame == .zero {
                let w = statusText.ty_textSize(font: .font(fontSize: 13, fontName: .PingFRegular), width: CGFloat(MAXFLOAT), height: 15).width
                statusFrame = .init(x: PPScreenW - 15 - w, y: (headerHeight - 15) / 2.0, width: w, height: 15)
            }
            return statusFrame
        }
    }
    
    //MARK:
    //MARK: 咨询记录 - footer
    private var hasCalculateFooterFrame: Bool = false
    /// 退回
    public var backButtonFrame: CGRect = .zero
    /// 补充问题
    public var supplementAskButtonFrame: CGRect = .zero
    /// 回复
    public var replyButtonFrame: CGRect = .zero
    /// 补充回复
    public var supplementReplyButtonFrame: CGRect = .zero
    /// 查看
    public var viewButtonFrame: CGRect = .zero
    
    public var footerHeight: CGFloat = 65
    
    /// 是否显示footer
    public var showFooter: Bool = false

    /**
     replystatus 是0 - type = 0 退回，补充提问，回复 type = 1 回复，退回
     replystatus 是1 - type = 0 补充回复 补充提问 type = 1 查看
     replystatus 是2. 查看
     replystatus 是3 type = 0 补充回复 type = 1 查看
     */
    public func calculateFooterUI() {
        if !hasCalculateFooterFrame {
            guard let rt = HCReplyStatus(rawValue: replyStatus), let ct = HCConsultType(rawValue: type) else {
                return
            }
            if rt == .unReplay {
                if ct == .picAndText {
                    backButtonFrame = .init(x: 15, y: 10, width: 70, height: 25)
                    replyButtonFrame = .init(x: PPScreenW - 15 - 70, y: 10, width: 70, height: 25)
                    supplementAskButtonFrame = .init(x: replyButtonFrame.minX - 20 - 70, y: 10, width: 70, height: 25)
                    supplementReplyButtonFrame = .zero
                    viewButtonFrame = .zero
                    
                    showFooter = true
                }else if ct == .chatConsult {
                    backButtonFrame = .init(x: 15, y: 10, width: 70, height: 25)
                    replyButtonFrame = .init(x: PPScreenW - 15 - 70, y: 10, width: 70, height: 25)
                    supplementReplyButtonFrame = .zero
                    viewButtonFrame = .zero
                    supplementAskButtonFrame = .zero
                    
                    showFooter = true
                }
            }else if rt == .replay {
                if ct == .picAndText {
                    supplementReplyButtonFrame = .init(x: PPScreenW - 15 - 70, y: 10, width: 70, height: 25)
                    supplementAskButtonFrame = .init(x: 15, y: 10, width: 70, height: 25)
                    backButtonFrame = .zero
                    replyButtonFrame = .zero
                    viewButtonFrame = .zero
                    
                    showFooter = true
                }else if ct == .chatConsult {
                    viewButtonFrame = .init(x: PPScreenW - 15 - 70, y: 10, width: 70, height: 25)
                    supplementReplyButtonFrame = .zero
                    supplementAskButtonFrame = .zero
                    backButtonFrame = .zero
                    replyButtonFrame = .zero
                    
                    showFooter = true
                }
            }else if rt == .back {
                viewButtonFrame = .init(x: PPScreenW - 15 - 70, y: 10, width: 70, height: 25)
                supplementReplyButtonFrame = .zero
                supplementAskButtonFrame = .zero
                backButtonFrame = .zero
                replyButtonFrame = .zero
                
                showFooter = true
            }else if rt == .finish {
                if ct == .picAndText {
                    supplementReplyButtonFrame = .init(x: PPScreenW - 15 - 70, y: 10, width: 70, height: 25)
                    viewButtonFrame = .zero
                    supplementAskButtonFrame = .zero
                    backButtonFrame = .zero
                    replyButtonFrame = .zero
                    
                    showFooter = true
                }else if ct == .videoConsult {
                    viewButtonFrame = .init(x: PPScreenW - 15 - 70, y: 10, width: 70, height: 25)
                    supplementReplyButtonFrame = .zero
                    supplementAskButtonFrame = .zero
                    backButtonFrame = .zero
                    replyButtonFrame = .zero
                    
                    showFooter = true
                }
            }
            
            footerHeight = showFooter ? 65 : 10
            
            hasCalculateFooterFrame = true
        }
    }
}

class HCConsultDetailFileModel: HJModel {
    var filePath: String = ""
    
    var tempImage: UIImage?
    //    var photoItemSize: CGSize = .init(width: 0, height: 0)
}
extension HCConsultDetailFileModel: HCPhotoBoxProtocol {
    var imageURL: String? { return filePath }
    var image: UIImage? { return tempImage }
}

enum HCConsultContentType {
    case text
    case image
    case audio
    case textAndImage
}
class HCConsultDetailConsultListModel: HJModel {
    var id: String = ""
    var userType: String = ""
    var memberId: String = ""
    var memberName: String = ""
    var memberHeadPath: String = ""
    var userId: String = ""
    var userName: String = ""
    var userHeadPath: String = ""
    var content: String = ""
    var replyStatus: String = ""
    var read: String = ""
    var createDate: String = ""
    var fileList: [String] = []
    var bak: String = ""
    
    /// 新加参数
    var timeString: String = ""
    
    /// 发送图片时，临时存储
    var images: [UIImage] = []
    
    private var avatarFrame: CGRect = .zero
    private var nameFrame: CGRect = .zero
    private var contentBgFrame: CGRect = .zero
    private var contentTextFrame: CGRect = .zero
    private var imageBoxFrame: CGRect = .zero
    private var audioIconFrame: CGRect = .zero
    private var audioDurationFrame: CGRect = .zero

    private var timeFrame: CGRect = .zero
    
    private var cellHeight: CGFloat = 0
    
    public lazy var isMine: Bool = {
        return self.userType == "user"
    }()
    
    public lazy var cellIdentifier: String = {
        if self.contentType == .audio {
            return HCConsultDetailAudioCell_identifier
        }else if self.contentType == .image {
            return HCConsultDetailPhotoCell_identifier
        }else if self.contentType == .textAndImage {
            return HCConsultDetailTextPhotoCell_identifier
        }else {
            return HCConsultDetalCell_identifier
        }
    }()

    
    public lazy var imageModels: [HCConsultDetailFileModel] = {
        var datas: [HCConsultDetailFileModel] = []
        if self.fileList.count > 0 {
            for path in self.fileList {
                let m = HCConsultDetailFileModel()
                m.filePath = path
                datas.append(m)
            }
        }else if self.images.count > 0 {
            for image in self.images {
                let m = HCConsultDetailFileModel()
                m.tempImage = image
                datas.append(m)
            }
        }
        return datas
    }()
    
    public lazy var contentType: HCConsultContentType = {
        if self.fileList.count > 0, let type = self.fileList.last?.components(separatedBy: ".").last {
            if type == "mp3" || type == "amr" {
                return .audio
            }
            
            if type == "jpg" || type == "png" {
                if self.content.count > 0 {
                    return .textAndImage
                }
                
                return .image
            }
        }
        return .text
    }()
    
    public lazy var audioDurationText: String = {
        return "\(self.bak)″"
    }()
    
    public lazy var displayName: String = {
        return self.isMine ? self.userName : self.memberName
    }()
    
    public lazy var avatarURL: String = {
        return self.isMine ? self.userHeadPath : self.memberHeadPath
    }()
    
    public var getAvatarFrame: CGRect {
        get {
            if avatarFrame == .zero {
                if isMine {
                    avatarFrame = .init(x: PPScreenW - 15 - 41, y: 10, width: 41, height: 41)
                }else {
                    avatarFrame = .init(x: 15, y: 10, width: 41, height: 41)
                }
            }
            return avatarFrame
        }
    }
        
    public var getContentBgFrame: CGRect {
        get {
            if contentBgFrame == .zero {
                var bgSize = CGSize.zero
                if contentType == .text || contentType == .textAndImage {
                    bgSize = CGSize.init(width: getContentTextFrame.size.width + 20, height: getContentTextFrame.size.height + 26)
                }else if contentType == .audio {
                    bgSize = CGSize.init(width: 100, height: 40)
                }
                if isMine {
                    contentBgFrame = .init(x: PPScreenW - bgSize.width - 66, y: getAvatarFrame.minY, width: bgSize.width, height: bgSize.height)
                }else {
                    contentBgFrame = .init(x: 66, y: getAvatarFrame.minY, width: bgSize.width, height: bgSize.height)
                }
            }
            return contentBgFrame
        }
    }
    
    public var getImageBoxFrame: CGRect {
        get {
            if imageBoxFrame == .zero {
                let size = HCBoxPhotoView.itemSize(with: fileList.count)
                let y = contentType == .textAndImage ? getContentBgFrame.maxY + 10 : getAvatarFrame.minY;
                if isMine {
                    imageBoxFrame = .init(x: PPScreenW - size.width - 66, y: y, width: size.width, height: size.height)
                }else {
                    imageBoxFrame = .init(x: 66, y: y, width: size.width, height: size.height)
                }
            }
            return imageBoxFrame
        }
    }
    
    public var getAudioIconFrame: CGRect {
        get {
            if audioIconFrame == .zero {
                if isMine {
                    audioIconFrame = .init(x: getContentBgFrame.width - 12 - 13, y: (getContentBgFrame.height - 15) / 2.0, width: 13, height: 15)
                }else {
                    audioIconFrame = .init(x: 12, y: (getContentBgFrame.height - 15) / 2.0, width: 13, height: 15)
                }
            }
            return audioIconFrame
        }
    }
    
    public var getAudioDurationFrame: CGRect {
        get {
            if audioDurationFrame == .zero {
                let audioSize = audioDurationText.ty_textSize(font: .font(fontSize: 13, fontName: .PingFRegular),
                                                              width: CGFloat(MAXFLOAT),
                                                              height: 13)
                if isMine {
                    audioDurationFrame = .init(x: getAudioIconFrame.minX - audioSize.width - 5,
                                               y: (getContentBgFrame.height - 13) / 2.0,
                                               width: audioSize.width, height: 13)
                }else {
                    audioDurationFrame = .init(x: getAudioIconFrame.maxX + 5,
                                               y: (getContentBgFrame.height - 13) / 2.0,
                                               width: audioSize.width, height: 13)
                }
            }
            return audioDurationFrame
        }
    }


    public var getContentTextFrame: CGRect {
        get {
            if contentTextFrame == .zero {
                let contentTextSize = content.ty_textSize(font: .font(fontSize: 14),
                                                          width: PPScreenW - 75 - 76,
                                                          height: CGFloat(MAXFLOAT))
                contentTextFrame = .init(x: 10, y: 13, width: contentTextSize.width, height: contentTextSize.height)
            }
            return contentTextFrame
        }
    }
    
    public var getTimeFrame: CGRect {
        get {
            if timeFrame == .zero {
                let w = timeString.ty_textSize(font: .font(fontSize: 14), width: CGFloat(MAXFLOAT), height: 20).width
                timeFrame = .init(x: (PPScreenW - w) / 2.0, y: 15, width: w, height: 20)
            }
            return timeFrame
        }
    }
    
    public var getCellHeight: CGFloat {
        get {
            if cellHeight == 0 {
                if cellIdentifier == HCConsultDetailTimeCell_identifier {
                    cellHeight = getTimeFrame.maxY + 15
                }else {
                    if contentType == .image || contentType == .textAndImage {
                        cellHeight = getImageBoxFrame.maxY + 10
                    }else {
                        cellHeight = getContentBgFrame.maxY + 10
                    }
                }
            }
            return cellHeight
        }
    }
}
