//
//  HCBrowserImageScaleHelper.swift
//  HuChuangApp
//
//  Created by sw on 2021/1/17.
//  Copyright © 2021 sw. All rights reserved.
//

import Foundation

struct HCBrowserImageScaleHelper {
    
    static func calculateImage(imageSize: CGSize, maxSize: CGSize, offset: Bool) ->CGRect {
        if imageSize.width == 0 || imageSize.height == 0 {
            return UIScreen.main.bounds
        }
        
        var x: CGFloat = 0.0
        var y: CGFloat = 0.0
        var width: CGFloat = 0.0
        var height: CGFloat = 0.0
        
        let maxWidth: CGFloat = maxSize.width
        let maxHeight: CGFloat = maxSize.height
        
        let imageWidth: CGFloat = imageSize.width
        let imageHeight: CGFloat = imageSize.height
        
        if imageSize.height >= imageSize.width {
            if imageSize.height > maxSize.height && imageSize.height < maxSize.height * 2.5 {
                width = maxSize.width
                height = imageHeight * (width / imageSize.width)
                return .init(x: 0, y: (maxSize.height - height) / 2.0, width: width, height: height)
            }
        }else {
            if imageSize.width > maxSize.width && imageSize.width < maxSize.width * 5 {
                height = maxSize.height
                width = imageSize.width * (height / imageSize.height)
                return .init(x: (maxSize.width - width) / 2.0, y: 0, width: width, height: height)
            }
        }
        
        let widthSpace: CGFloat = CGFloat(fabsf((Float)(maxWidth - imageWidth)))
        let heightSpace: CGFloat = CGFloat(fabsf((Float)(maxHeight - imageHeight)))
        
        if (widthSpace >= heightSpace) {
            if (maxWidth > imageWidth) {
                width = imageWidth * (maxHeight / imageHeight)
                height = imageHeight * (maxHeight / imageHeight)
            }else {
                width = imageWidth / (imageWidth / maxWidth)
                height = imageHeight / (imageWidth / maxWidth)
            }
        }else {
            if (maxHeight > imageHeight) {
                width = imageWidth * (maxWidth / imageWidth)
                height = imageHeight * (maxWidth / imageWidth)
            }else {
                width = imageWidth / (imageHeight / maxHeight)
                height = imageHeight / (imageHeight / maxHeight)
            }
        }
        
        x = (maxWidth - width) * 0.5
        y = (maxHeight - height) * 0.5
        var frame: CGRect = .init(x: x, y: y, width: width, height: height)
        if (x < 0 || y < 0) {
            frame = HCBrowserImageScaleHelper.calculateImage(imageSize: .init(width: width, height: height),
                                                             maxSize: maxSize,
                                                             offset: offset)
        }
        
        if (frame.size.height > frame.size.width && frame.size.width < min(maxWidth, maxHeight) * 0.25) {
            let minWidth: CGFloat = max(min(maxWidth, imageWidth), maxWidth * 2 / 3.0)
            width = imageWidth * (minWidth / imageWidth)
            height = imageHeight * (minWidth / imageWidth)
            x = (maxWidth - width) * 0.5
            if (!offset) {
                y = (maxHeight - height) * 0.5
            }
            frame = .init(x: x, y: y, width: width, height: height)
        }
        
        if (frame.size.width > frame.size.height && frame.size.height < min(maxWidth, maxHeight) * 0.25) {
            
            let minHeight: CGFloat = max(min(maxHeight, imageHeight), maxHeight * 2 / 3.0)
            height = imageHeight * (minHeight / imageHeight)
            width = imageWidth * (minHeight / imageHeight)
            y = (maxHeight - height) * 0.5
            if (!offset) {
                x = (maxWidth - width) * 0.5
            }
            
            frame = .init(x: x, y: y, width: width, height: height)
        }
        
        return frame

    }
        
    public static func reSizeImage(sourceImage: UIImage, size: CGSize) ->UIImage {
        // 先不管小图显示区域
        return sourceImage
        
        let imageSize = sourceImage.size

        if imageSize.width == 0 || imageSize.height == 0 || size.width == 0 || size.height == 0 {
            return sourceImage
        }
        
        var newImage: UIImage?
        let width = imageSize.width
        let height = imageSize.height
        let targetWidth = size.width
        let targetHeight = size.height
        var scaleFactor: CGFloat = 0.0
        var scaledWidth = targetWidth
        var scaledHeight = targetHeight
        var thumbnailPoint: CGPoint = .zero

        if imageSize.equalTo(size) == false {
            let widthFactor = targetWidth / width
            let heightFactor = targetHeight / height
            
            if widthFactor > heightFactor {
                scaleFactor = widthFactor
            }else{
                scaleFactor = heightFactor
            }
            scaledWidth = width * scaleFactor
            scaledHeight = height * scaleFactor
            
//            if widthFactor > heightFactor {
//                thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5
//            }else if widthFactor < heightFactor {
//                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5
//            }
            thumbnailPoint.y = height >= width ? 0 : (targetHeight - scaledHeight) * 0.5
            thumbnailPoint.x = height >= width ? (targetWidth - scaledWidth) * 0.5 : 0
        }

        UIGraphicsBeginImageContext(size)

        var thumbnailRect = CGRect.zero
        thumbnailRect.origin = thumbnailPoint
        thumbnailRect.size.width = scaledWidth
        thumbnailRect.size.height = scaledHeight

        sourceImage.draw(in: thumbnailRect)

        newImage = UIGraphicsGetImageFromCurrentImageContext()
        if newImage == nil {
            print("绘制图片失败")
        }

        UIGraphicsEndImageContext()
        
        print("绘制图片尺寸：\(newImage?.size), 目标frame：\(thumbnailRect)")
        return newImage ?? sourceImage
    }

}
