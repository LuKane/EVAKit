//
//  Device+EVA.swift
//  EVAKit
//
//  Created by LuKane on 2022/11/25.
//

import Foundation
import UIKit
import AVFoundation
import Photos
import AppTrackingTransparency
import AdSupport

extension UIDevice: EVACompatible {}

/// MARK BaseInfo
extension EVAWrapper where Base: UIDevice {
    
    /// current device name
    /// - Returns: device'name
    /// - Note: iPhone 6s
    public static func deviceName() -> String {
        Base.current.name
    }
    /// current device system version
    /// - Returns: system version
    /// - Note: 9.0
    public static func deviceSystemVersion() -> String {
        Base.current.systemVersion
    }
    
    /// current your application version
    /// - Returns: version
    /// - Note: 1.0.0
    public static func deviceAppVersion() -> String? {
        guard let info = Bundle.main.infoDictionary else {
            return nil
        }
        return info["CFBundleShortVersionString"] as? String
    }
    
    /// current your application build version
    /// - Returns: version
    /// - Note: 1
    public static func deviceAppBuildVersion() -> String? {
        guard let info = Bundle.main.infoDictionary else {
            return nil
        }
        return info["CFBundleVersion"] as? String
    }
    
    /// current App name
    /// - Returns: app name
    /// - Note: try get display name ,otherwise bundle name 
    public static func deviceAppName() -> String? {
        guard let info = Bundle.main.infoDictionary else {
            return nil
        }
        return (info["CFBundleDisplayName"] ?? info["CFBundleName"]) as? String
    }
    
    /// current device is jail broken
    /// - Returns: is nor not
    public static func deviceIsJailBroken() -> Bool {
        if isJailBreak1() {
            return true
        }
        return false
    }

    private static func isJailBreak1() -> Bool {
        let jailbreak_tool_paths = [
            "/Applications/Cydia.app",
            "/Library/MobileSubstrate/MobileSubstrate.dylib",
            "/bin/bash",
            "/usr/sbin/sshd",
            "/etc/apt"
        ]
        for item in jailbreak_tool_paths {
            if FileManager.default.fileExists(atPath: item) {
                return true
            }
        }
        if UIApplication.shared.canOpenURL(URL.init(string: "cydia://")!) {
            return true
        }
        if FileManager.default.fileExists(atPath: "User/Applications/") {
            return true
        }
        return false
    }
}

/// MARK Auth
extension EVAWrapper where Base: UIDevice {
    
    /// device camera auth check
    /// - Parameter block: callBack
    public static func deviceCameraAuth(block: @escaping (Bool) -> ()) {
        let auth = AVCaptureDevice.authorizationStatus(for: .video)
        switch auth {
            case .authorized: 
                DispatchQueue.main.async { block(true) }
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { k in
                    DispatchQueue.main.async { block(k) }
                }
            default:
                DispatchQueue.main.async { block(false) }
        }
    }
    
    /// device album auth check
    /// - Parameter block: callBack
    public static func deviceAlbumAuth(block: @escaping (Bool) -> ()) {
        let auth = PHPhotoLibrary.authorizationStatus()
        switch auth {
            case .authorized:
                DispatchQueue.main.async { block(true) }
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization { k in
                    DispatchQueue.main.async {
                        if k == .authorized {
                            block(true)
                        }else {
                            block(false)
                        }
                    }
                }
            default:
                DispatchQueue.main.async { block(false) }
        }
    }
    
    /// device track auth check
    /// - Parameter block: callBack
    public static func deviceTrackAuth(block: @escaping (Bool, String?) -> ()) {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { auth in
                if auth == .authorized {
                    let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                    DispatchQueue.main.async {
                        block(true, idfa)
                    }
                }else if auth == .notDetermined {
                    DispatchQueue.main.async {
                        block(true, nil)
                    }
                }
            }
        }else {
            if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
                let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                DispatchQueue.main.async {
                    block(true, idfa)
                }
            }else {
                DispatchQueue.main.async {
                    block(false, nil)
                }
            }
        }
    }
}
