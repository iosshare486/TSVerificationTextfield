//
//  TSImageView.swift
//  TSUIKit
//
//  Created by 小铭 on 2018/7/23.
//  Copyright © 2018年 caiqr. All rights reserved.
//

import UIKit
import TSCustomUIKit
import Kingfisher


extension TSUIKit where TU: UIImageView {
    //
    public func setImage(url : String?) {
        
        guard let urlStr = url, urlStr.count > 1 else {
            return
        }
        
        guard let url = URL(string: urlStr) else {
            return
        }
        
        let res : ImageResource = ImageResource(downloadURL: url)
        
        self.base.kf.setImage(with: res)
    }   
    
    public func setImage(url : String?, placeHolder: UIImage) {
        
        guard let urlStr = url, urlStr.count > 1 else {
            self.base.image = placeHolder
            return
        }
        
        guard let url = URL(string: urlStr) else {
            return
        }
        
        let res : ImageResource = ImageResource(downloadURL: url)
        
        self.base.kf.setImage(with: res, placeholder: placeHolder, options: nil, progressBlock: nil, completionHandler: nil)
    }
    
    public func setImage(url : String?, placeHolder: UIImage?, progressBlock : ((_ receivedSize: Int64, _ totalSize: Int64) -> Void)?, completionBlock : ((_ image: Image?, _ error: NSError?) -> Void)? ) {
        
        guard let urlStr = url, urlStr.count > 1 else {
            return
        }
        
        guard let url = URL(string: urlStr) else {
            return
        }
        
        let res : ImageResource = ImageResource(downloadURL: url)
        
        self.base.kf.setImage(with: res, placeholder: placeHolder, options: nil, progressBlock: progressBlock) { (image, error, _, _) in
            self.base.image = image
            if (completionBlock != nil) {
                completionBlock!(image,error)
            }
        }
    }
    
    public func setGifImage(name : String) -> Void {
        DispatchQueue.global().async {
            let image = UIImage.gif(name: name)
            DispatchQueue.main.async {
                self.base.image = image
            }
        }
    }
}

extension UIImage {
    
    internal class func gif(data: Data) -> UIImage? {
        // Create source from data
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("SwiftGif: Source for the image does not exist")
            return nil
        }
        
        return UIImage.animatedImageWithSource(source)
    }
    
    internal class func gif(name: String) -> UIImage? {
        // Check for existance of gif
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif") else {
                print("SwiftGif: This image named \"\(name)\" does not exist")
                return nil
        }
        
        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }
        
        return gif(data: imageData)
    }
    
    internal class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        
        // Get dictionaries
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifPropertiesPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 0)
        if CFDictionaryGetValueIfPresent(cfProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque(), gifPropertiesPointer) == false {
            return delay
        }
        
        let gifProperties:CFDictionary = unsafeBitCast(gifPropertiesPointer.pointee, to: CFDictionary.self)
        
        // Get delay time
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                                 Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                                                             Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        
        delay = delayObject as? Double ?? 0
        
        if delay < 0.1 {
            delay = 0.1 // Make sure they're not too fast
        }
        
        return delay
    }
    
    internal class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        // Check if one of them is nil
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }
        
        // Swap for modulo
        if a! < b! {
            let c = a
            a = b
            b = c
        }
        
        // Get greatest common divisor
        var rest: Int
        while true {
            rest = a! % b!
            
            if rest == 0 {
                return b! // Found it
            } else {
                a = b
                b = rest
            }
        }
    }
    
    internal class func gcdForArray(_ array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        
        return gcd
    }
    
    internal class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        // Fill arrays
        for i in 0..<count {
            // Add image
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            
            // At it's delay in cs
            let delaySeconds = UIImage.delayForImageAtIndex(Int(i),
                                                            source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }
        
        // Calculate full duration
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            
            return sum
        }()
        
        // Get frames
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        // Heyhey
        let animation = UIImage.animatedImage(with: frames,
                                              duration: Double(duration) / 1000.0)
        
        return animation
    }
    
}
