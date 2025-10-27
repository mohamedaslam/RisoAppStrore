//
//  ImageProcessor.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 30/05/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit

func executionTimeInterval(block: () -> ()) -> CFTimeInterval {
    let start = CACurrentMediaTime()
    block();
    let end = CACurrentMediaTime()
    return end - start
}

class ImageProcessor {
    func testDifferentCompressionMethods(_ source: UIImage) {
        print("\n\n\n\n\n")
        let sourceData = source.jpegData(compressionQuality: 1)
        print("Source image size: \((sourceData?.count ?? 0) / 1024) KB")
        
        print("=========================================================")
        let weChatCompression = executionTimeInterval {
            let newImage = source.wxCompress()
            let imageData = newImage
            print("Image size: \((imageData?.count ?? 0) / 1024) KB")
        }
        
        print("WeChatCompression: \(weChatCompression)")
        print("=========================================================")
        
        
        print("=========================================================")
        let classicCompression = executionTimeInterval {
            let imageData = source.jpegData(compressionQuality: 0.85)
            print("Image size: \((imageData?.count ?? 0) / 1024) KB")
        }
        
        print("Classic Compression: \(classicCompression)")
        print("=========================================================")
    }
}

public enum WechatCompressType {
    case session
    case timeline
    
    var boundary: CGFloat {
        switch self {
        case .session:
            return 800
        case .timeline:
            return 1600
        }
    }
}

public extension UIImage {
    /**
     wechat image compress
     
     - parameter type: session image boundary is 800, timeline is 1280
     
     - returns: thumb image
     */
//    func wxCompress(type: WechatCompressType = .timeline) -> UIImage {
//        let size = self.wxImageSize(type: type)
//        let reImage = resizedImage(size: size)
//        let data = UIImageJPEGRepresentation(reImage, 0.85)!
//        return UIImage.init(data: data)!
//    }
//
    func wxCompress(type: WechatCompressType = .timeline) -> Data? {
        let size = self.wxImageSize(type: type)
        let reImage = resizedImage(size: size)
        let data = reImage.jpegData(compressionQuality: 0.85)
        return data
    }
    
    /**
     get wechat compress image size
     
     - parameter type: session  / timeline
     
     - returns: size
     */
    private func wxImageSize(type: WechatCompressType) -> CGSize {
        var width = self.size.width
        var height = self.size.height
        
        var boundary: CGFloat = 1600
        
        // width, height <= 1700, Size remains the same
        guard width > boundary || height > boundary else {
            return CGSize(width: width, height: height)
        }
        
        // aspect ratio
        let s = max(width, height) / min(width, height)
        if s <= 2 {
            // Set the larger value to the boundary, the smaller the value of the compression
            let x = max(width, height) / boundary
            if width > height {
                width = boundary
                height = height / x
            } else {
                height = boundary
                width = width / x
            }
        } else {
            // width, height > 1280
            if min(width, height) >= boundary {
                boundary = type.boundary
                // Set the smaller value to the boundary, and the larger value is compressed
                let x = min(width, height) / boundary
                if width < height {
                    width = boundary
                    height = height / x
                } else {
                    height = boundary
                    width = width / x
                }
            }
        }
        return CGSize(width: width, height: height)
    }
    
    /**
     Zoom the picture to the specified size
     
     - parameter newSize: image size
     
     - returns: new image
     */
    private func resizedImage(size: CGSize) -> UIImage {
        let newRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        var newImage: UIImage!
        UIGraphicsBeginImageContext(newRect.size)
        newImage = UIImage(cgImage: self.cgImage!, scale: 1, orientation: self.imageOrientation)
        newImage.draw(in: newRect)
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
}
