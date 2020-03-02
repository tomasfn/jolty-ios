//
//  EVExtensions.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 5/28/18.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import UIKit


enum AppInfo {
    
    static var version: String? {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    static var build: String? {
        return Bundle.main.infoDictionary?["CFBundleVersionString"] as? String
    }
    
    static var bundleName: String? {
        return Bundle.main.infoDictionary?["CFBundleName"] as? String
    }
    
}

extension String {
    //: ### Base64 encoding a string
    func base64Encoded() -> String? {
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return nil
    }
    
    //: ### Base64 decoding a string
    func base64Decoded() -> String? {
        if let data = Data(base64Encoded: self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
}

extension UIButton {
    
    public func titleLines(lines: Int) {
        guard lines >= 0 else { return }
        titleLabel?.numberOfLines = lines
        titleLabel?.baselineAdjustment = .alignCenters
    }
    
    public func titleUniformMargin(margin: CGFloat) {
        titleEdgeInsets = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
    }
    
}


extension UIView {
    public var x: CGFloat {
        get { return origin.x }
        set { origin = CGPoint(x: newValue, y: y) }
    }
    
    public var y: CGFloat {
        get { return origin.y }
        set { origin = CGPoint(x: x, y: newValue) }
    }
    
    public var width: CGFloat {
        get { return size.width }
        set { size = CGSize(width: newValue, height: height) }
    }
    
    public var height: CGFloat {
        get { return size.height }
        set { size = CGSize(width: width, height: newValue) }
    }
    
    public var size: CGSize {
        get { return bounds.size }
        set { frame = CGRect(origin: origin, size: newValue) }
    }
    
    public var origin: CGPoint {
        get { return frame.origin }
        set { frame = CGRect(origin: newValue, size: size) }
    }
    
    public func roundView(updateLayout layoutIfNeeded: Bool = true) {
        if layoutIfNeeded { self.layoutIfNeeded() }
        roundCorners(radius: min(width, height)/2)
    }
    
    public func roundCorners(radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = radius > 0
    }
    
    public func takeSnapshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        //    layer.renderInContext(UIGraphicsGetCurrentContext())
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
}

extension UIScreen {
    public var width: CGFloat {
        return size.width
    }
    
    public var height: CGFloat {
        return size.height
    }
    
    public var size: CGSize {
        return bounds.size
    }
}

extension NSData {
    func stringFromDeviceToken() -> String! {
        
        var bytes = [UInt8](repeating: 0, count: self.length)
        self.getBytes(&bytes, length: bytes.count)
        var token = String()
        
        for i in 0 ..< bytes.count {
            token += String(format: "%02.2hhX", bytes[i])
        }
        
        return token
    }
}

extension Array {
    var randomElement: Element? {
        get {
            guard isEmpty == false else { return nil }
            
            let randomIndex = arc4random_uniform(UInt32(count))
            return self[Int(randomIndex)]
        }
    }
}


extension Bool {
    static func randomValue() -> Bool {
        return arc4random_uniform(2) == 0 ? false : true
    }
}

extension Dictionary {
    func removeNulls() -> Dictionary {
        var dict = self
        
        for key in dict.keys {
            if dict[key] is NSNull {
                dict.removeValue(forKey: key)
            }
        }
        
        return dict
    }
}

extension CGSize {
    public var aspectRatio: CGFloat {
        return width / height
    }
}

