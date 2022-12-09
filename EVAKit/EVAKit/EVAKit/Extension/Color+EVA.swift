//
//  Color+EVA.swift
//  EVAKit
//
//  Created by LuKane on 2022/11/25.
//

import Foundation
import UIKit

extension UIColor: EVACompatible {}

extension EVAWrapper where Base: UIColor {
    
    /// color with rgb , a = 1.0
    /// - Parameters:
    ///   - red: red
    ///   - green: green
    ///   - blue: blue
    /// - Returns: color
    public static func color(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat) -> Base {
        color(red, green, blue, 1.0)
    }
    /// color with rgba
    /// - Parameters:
    ///   - red: red
    ///   - green: green
    ///   - blue: blue
    ///   - alpha: alpha
    /// - Returns: color
    public static func color(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat) -> Base {
        Base(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha)
    }
    /// color with hex
    /// - Parameter hex: hex
    /// - Returns: color
    public static func color(_ hex: String) -> Base {
        color(hex, 1.0)
    }
    /// Color with hex
    /// - Parameters:
    ///   - hex: hex
    ///   - alpha: alpha
    /// - Returns: color
    public static func color(_ hex: String, _ alpha: CGFloat) -> Base {
        
        var result = hex
        
        if result.hasPrefix("0x") {
            result = result.replacingOccurrences(of: "0x", with: "")
        }
        if result.hasPrefix("#") {
            result = result.replacingOccurrences(of: "#", with: "")
        }

        if result.count < 6 || result.count % 2 != 0{
            return Base.gray as! Base
        }
        
        let index0 = result.index(result.startIndex, offsetBy: 2)
        let rs = result[result.startIndex..<index0]
        
        let index1 = result.index(index0, offsetBy: 2)
        let gs = result[index0..<index1]
        
        let index2 = result.index(index1, offsetBy: 2)
        let bs = result[index1..<index2]
        
        var r: UInt32 = 0x0
        var g: UInt32 = 0x0
        var b: UInt32 = 0x0
        Scanner.init(string: String(rs)).scanHexInt32(&r)
        Scanner.init(string: String(gs)).scanHexInt32(&g)
        Scanner.init(string: String(bs)).scanHexInt32(&b)
        
        return Base(displayP3Red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(alpha))
    }
    /// random color
    /// - Returns: color
    public static func colorRandom() -> Base {
        Base(red: CGFloat(arc4random() % 256) / 255.0, green: CGFloat(arc4random() % 256) / 255.0, blue: CGFloat(arc4random() % 256) / 255.0, alpha: 1.0)
    }
    
    /// get red value of Current color
    var redValue: CGFloat {
        get {
            var r: CGFloat = 0.0
            var g: CGFloat = 0.0
            var b: CGFloat = 0.0
            var a: CGFloat = 0.0
            base.getRed(&r, green: &g, blue: &b, alpha: &a)
            return r
        }
    }
    /// get blue value of Current color
    var blueValue: CGFloat {
        get {
            var r: CGFloat = 0.0
            var g: CGFloat = 0.0
            var b: CGFloat = 0.0
            var a: CGFloat = 0.0
            base.getRed(&r, green: &g, blue: &b, alpha: &a)
            return b
        }
    }
    /// get green value of Current color
    var greenValue: CGFloat {
        get {
            var r: CGFloat = 0.0
            var g: CGFloat = 0.0
            var b: CGFloat = 0.0
            var a: CGFloat = 0.0
            base.getRed(&r, green: &g, blue: &b, alpha: &a)
            return g
        }
    }
    /// get alpha value of Current color
    var alphaValue: CGFloat {
        get {
            return base.cgColor.alpha
        }
    }
}
