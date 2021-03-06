//
//  NSString+Extends.swift
//  StoryReader
//
//  Created by 020-YinTao on 2016/12/7.
//  Copyright © 2016年 020-YinTao. All rights reserved.
//

import Foundation
import UIKit

public let hc_fontName          = "Helvetica Neue"
public let hc_fontSize: CGFloat = 15

// MARK:
// MARK: 字符串size计算
extension String {
    
    func ty_textSize(font: UIFont, width: CGFloat, height: CGFloat) ->CGSize {
        let size = CGSize.init(width: width, height: height)
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font]
        return self.boundingRect(with: size, options: [.usesLineFragmentOrigin, .truncatesLastVisibleLine, .usesFontLeading], attributes: attributes, context:nil).size
    }

    func getTextHeigh(fontSize: Float, width: CGFloat, fontName: String = hc_fontName) -> CGFloat {
        
        return self.textSize(fontSize: fontSize, width: width, height: CGFloat(MAXFLOAT), fontName: fontName).height
    }
    
    func getTexWidth(fontSize: Float, height: CGFloat, fontName: String = hc_fontName) -> CGFloat {
        
        return self.textSize(fontSize: fontSize, width: CGFloat(MAXFLOAT), height: height, fontName: fontName).width
    }

    private func textSize(fontSize: Float, width: CGFloat, height: CGFloat, fontName: String) ->CGSize {
    
        let font = UIFont.init(name: fontName, size: CGFloat(fontSize)) ?? UIFont.systemFont(ofSize: CGFloat(fontSize))
        return ty_textSize(font: font, width: width, height: height)
    }
    
}

// MARK:
// MARK: 字符串操作
extension String {
    
    /// 计算于当前时间的差值
    public func timeDvalue() ->String {
        
        var date: Date!
        if let d = stringFormatDate(mode: .yymmddhhmmss) {
            date = d
        }else {
            if let d = stringFormatDate(mode: .yymmddhhmm) {
                date = d
            }else {
                return ""
            }
        }
        
        let today = Date()
        // 计算时间差
        let timeInterval = today.timeIntervalSince(date)
        
        let cal = Calendar.current
        let todate = Date.init(timeIntervalSinceNow: timeInterval)
        let components: Set = [
            Calendar.Component.year,
            Calendar.Component.month,
            Calendar.Component.day,
            Calendar.Component.hour,
            Calendar.Component.minute,
            Calendar.Component.second
        ]
        
        let gap = cal.dateComponents(components, from: today, to: todate)
        var y = 0
        var m = 0
        var d = 0
        var h = 0
        var mi = 0
        var s = 0
        
        if abs(gap.year ?? 0) > 0 {
            y = abs(gap.year!)
        }
        if abs(gap.month ?? 0) > 0 {
            m = abs(gap.month!)
        }
        if abs(gap.day ?? 0) > 0 {
            d = abs(gap.day!)
        }
        if abs(gap.hour ?? 0) > 0 {
            h = abs(gap.hour!)
        }
        if abs(gap.minute ?? 0) > 0 {
            mi = abs(gap.minute!)
        }
        if abs(gap.second ?? 0) > 0 {
            s = abs(gap.second!)
        }
        
        if y > 0 {
            return "\(y)年"
        }else if m > 0 {
            return "\(m)个月"
        }else if d > 0 {
            return "\(d)天\(h)小时\(mi)分钟"
        }else if h > 0 {
            return "\(h)小时\(mi)分钟"
        }else {
            return "\(mi)分钟"
        }
    }


    public func sr_timeFormat() ->String {
        
        guard let date = stringFormatDate()  else {
            return ""
        }
        
        let today = Date()
        // 计算时间差
        let timeInterval = today.timeIntervalSince(date)
        
        let cal = Calendar.current
        let todate = Date.init(timeIntervalSinceNow: timeInterval)
        let components: Set = [
            Calendar.Component.year,
            Calendar.Component.month,
            Calendar.Component.day,
            Calendar.Component.hour,
            Calendar.Component.minute,
            Calendar.Component.second
        ]
        
        let gap = cal.dateComponents(components, from: today, to: todate)
        if abs(gap.year ?? 0) > 0 {
            return "\(abs(gap.year!))年前"
        }else if abs(gap.month ?? 0) > 0 {
            return "\(abs(gap.month!))个月前"
        }else if abs(gap.day ?? 0) > 0 {
            return "\(abs(gap.day!))天前"
        }else if abs(gap.hour ?? 0) > 0 {
            return "\(abs(gap.hour!))小时前"
        }else if abs(gap.minute ?? 0) > 0 {
            return "\(abs(gap.minute!))分钟前"
        }
        
        return "刚刚"
    }
    
    public func getDayDiff(more: Bool, mode: HCDateMode = .yymmddhhmm) -> String {
     
        guard let date = stringFormatDate(mode: mode)  else {
            return ""
        }
        
        let today = Date()
        // 计算时间差
        let timeInterval = today.timeIntervalSince(date)
        
        let cal = Calendar.current
        let todate = Date.init(timeIntervalSinceNow: timeInterval)
        let components: Set = [
                                Calendar.Component.year,
                                Calendar.Component.month,
                                Calendar.Component.day,
                                Calendar.Component.hour,
                                Calendar.Component.minute,
                                Calendar.Component.second
                              ]

        let gap = cal.dateComponents(components, from: today, to: todate)
        if abs(gap.day!) > 0 {
            if abs(gap.day!) > 3 {
                let timeArr = self.components(separatedBy: " ")
                let days = timeArr.first?.components(separatedBy: "-")
                let times = timeArr.last?.components(separatedBy: ":")
                
                let year = days?[0]
                let month = days?[1]
                let day = days?[2]
                let hh = times?[0]
                let mm = times?[1]
                let ss = times?[2]

                if abs(gap.year!) > 0 {
                    if more {
                        return self
                    }
                    return ("\(year!)-\(month!)-\(day!)")
                }else {
                
                    if more {
                        return ("\(month!)-\(day!) \(hh!):\(mm!):\(ss!)")
                    }
                    return "\(month!)-\(day!)"
                }

            }else { return "\(abs(gap.day!))天前" }
        }else if abs(gap.hour!) > 0 {
            return "\(abs(gap.hour!))小时前"
        }else {
        
            if abs(gap.minute!) == 0 {
                return "刚刚"
            }
            return "\(abs(gap.minute!))小时前"
        }
    }
    
    public func timeSeprate() -> String {    
        let timeArr = self.components(separatedBy: " ")
        let detailTime = timeArr.first?.components(separatedBy: "-")
        
        let year = detailTime?[0]
        let month = detailTime?[1]
        let day = detailTime?[2]
        
        let now = Date()
        let calendar = NSCalendar.current
        let dateCompont = calendar.dateComponents([Calendar.Component.year], from: now)
        
        let curYear = dateCompont.year
        if Int(year!)! != curYear! {
            return "\(year!)年\(month!)月\(day!)日 \(timeArr.last!)"
        }
        return  "\(month!)月\(day!)日"
    }
    
    // eg:7.9 18:30
    public func timeSeprate1() -> String {
        
        guard let date = stringFormatDate()  else {
            return ""
        }
        
        let timeArr = self.components(separatedBy: " ")
        let days = timeArr.first?.components(separatedBy: "-")
        let times = timeArr.last?.components(separatedBy: ":")
        
//        let year = days?[0]
        let month = days?[1]
        let day = days?[2]
        let hh = times?[0]
        let mm = times?[1]
//        let ss = times?[2]
        
        return "\(month!).\(day!) \(hh!):\(mm!)"
    }
    
    public func getDayDiff2(more: Bool, mode: HCDateMode = .yymmddhhmm) -> String {
     
        guard let date = stringFormatDate(mode: mode)  else {
            return self
        }
        
        let today = Date()
        // 计算时间差
        let timeInterval = today.timeIntervalSince(date)
        
        let cal = Calendar.current
        let todate = Date.init(timeIntervalSinceNow: timeInterval)
        let components: Set = [
                                Calendar.Component.year,
                                Calendar.Component.month,
                                Calendar.Component.day,
                                Calendar.Component.hour,
                                Calendar.Component.minute
                              ]

        let gap = cal.dateComponents(components, from: today, to: todate)
        
        let timeArr = self.components(separatedBy: " ")
        let days = timeArr.first?.components(separatedBy: "-")
        let times = timeArr.last?.components(separatedBy: ":")
        
        let year = days?[0]
        let month = days?[1]
        let day = days?[2]
        let hh = times?[0]
        let mm = times?[1]


        PrintLog("间隔天数；\(gap.day!)")
        
        let calender = NSCalendar.current
        if calender.isDateInYesterday(date) {
            return "昨天"
        }else if calender.isDateInToday(date) {
            return ("\(hh!):\(mm!)")
        }else {
            if more {
                return ("\(year!)-\(month!)-\(day!) \(hh!):\(mm!)")
            }
            return "\(year!)-\(month!)-\(day!)"
        }
        
//        if abs(gap.hour!) > 24 {
//            if abs(gap.day!) == 1 {
//                return "昨天"
//            }else {
//                if more {
//                    return ("\(year!)-\(month!)-\(day!) \(hh!):\(mm!)")
//                }
//                return "\(year!)-\(month!)-\(day!)"
//            }
//        }else {
//            return ("\(hh!):\(mm!)")
//        }
//
//        
//        if abs(gap.day!) > 0 {
//            if abs(gap.day!) == 1 {
//                return "昨天"
//            }else {
//                if more {
//                    return ("\(year!)-\(month!)-\(day!) \(hh!):\(mm!)")
//                }
//                return "\(year!)-\(month!)-\(day!)"
//            }
//        }else {
//            return ("\(hh!):\(mm!)")
//        }
    }

    
    //时间戳转成字符串 eg: yyyy-MM-dd HH:mm:ss
    public func timeSeprate3(dateFormat: String? = nil) -> String {
        let interval = TimeInterval.init((Double(self) ?? 0.00) / 1000)
        
        let date = Date(timeIntervalSince1970: interval)
        let dateformatter = DateFormatter()
        if let format = dateFormat {
            dateformatter.dateFormat = format
        }else {
            dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        }
        return dateformatter.string(from: date)
    }
}

// MARK:
// MARK: NSAttributedString
extension String {
    
    /// 同一lable种现实两种不同颜色字体
    ///
    public func attributed(_ range: NSRange, _ color: UIColor, _ font: UIFont?, lineSpace: CGFloat? = nil, alignment: NSTextAlignment = .center) ->NSAttributedString {
        
        let muString = NSMutableAttributedString.init(string: self)
        var dic: [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor : color]
        if font != nil {
            dic[NSAttributedString.Key.font] = font
        }
        muString.addAttributes(dic, range: range)
        
        if let line = lineSpace {
            let paraph = NSMutableParagraphStyle()
            paraph.lineSpacing = line
            paraph.alignment = alignment
            muString.addAttributes([NSAttributedString.Key.paragraphStyle : paraph],
                                   range: .init(location: 0, length: count))
        }
        
        return muString
    }
    
    /// 同一lable种现实不同颜色字体
    ///
    public func attributed(_ rangs: [NSRange], color colors: [UIColor] = [], font fonts: [UIFont] = []) ->NSAttributedString {
        let muString = NSMutableAttributedString.init(string: self)
        for idx in 0 ..< colors.count {
            muString.addAttribute(NSAttributedString.Key.foregroundColor, value: colors[idx], range: rangs[idx])
        }
        for idx in 0 ..< fonts.count {
            muString.addAttribute(NSAttributedString.Key.font, value: fonts[idx], range: rangs[idx])
        }

        return muString
    }
}

extension String { /**时间与日期*/

    public func stringFormatDate(mode: HCDateMode = .yymmddhhmm) ->Date?{
        let format = DateFormatter()
        format.dateFormat = mode.rawValue
        return format.date(from: transform(mode: mode))
    }
    
    public func stringTransform(mode: HCDateMode) -> String {
        let format = DateFormatter()
        format.dateFormat = mode.rawValue
        if let date = format.date(from: transform(mode: mode)) {
            return date.formatDate(mode: mode)
        }
        return self
    }
    
    public func transform(mode: HCDateMode) -> String {
        var result: String = ""
        switch mode {
        case .yymm:
            let comps = components(separatedBy: "-")
            if comps.count > 2 {
                result = "\(comps[0])-\(comps[1])"
            }else {
                result = self
            }
        case .yymmdd:
            let comps = components(separatedBy: " ")
            if comps.count > 1 {
                result = comps[0]
            }else {
                result = self
            }
        case .yymmddhhmm, .yymmddhhmm1:
            if components(separatedBy: " ").count == 1{
                result = appending(" 00:00")
            }else {
                result = self
            }
        case .yymmddhhmmss, .yymmddhhmmss1:
            if components(separatedBy: " ").count == 1{
                result = appending(" 00:00:00")
            }else {
                result = self
            }
        case .newyymmdd:
            let comps = components(separatedBy: "-")
            if comps.count == 3 {
                result = "\(comps[0])\(comps[1])\(comps[2])"
            }else {
                result = self
            }
        }
        return result
    }
}

extension String {
    
    var md5: String {
        let str = cString(using: String.Encoding.utf8)
        let strLen = CC_LONG(lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deallocate()
        
        return String(format: hash as String)
    }
    
}

extension String {
    
    func replacePhone() -> String {
        let start = self.index(self.startIndex, offsetBy: 3)
        let end = self.index(self.startIndex, offsetBy: 7)
        let range = Range(uncheckedBounds: (start, end))
        return self.replacingCharacters(in: range, with: "****")
    }
    
}
