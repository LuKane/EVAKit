//
//  Timer+EVA.swift
//  EVAKit
//
//  Created by LuKane on 2022/11/26.
//

import Foundation

fileprivate var EVATimeDic: Dictionary<String, DispatchSourceTimer> = [String: DispatchSourceTimer]()
fileprivate var EVATimeSemaphore: DispatchSemaphore = DispatchSemaphore.init(value: 1)

extension Timer: EVACompatible {}

extension EVAWrapper where Base: Timer {
    /// Timer maker
    /// - Parameters:
    ///   - seconds: delay seconds
    ///   - timeInterval: timeInterval
    ///   - mainThread: is main Thread? main : global
    ///   - repeats: repeat or not
    ///   - block: callBack
    /// - Returns: timer ID
    static func timer(delay seconds: Float = 0.0, time timeInterval: Float, mainThread: Bool = true, repeats: Bool = true, block: (()->())?) -> String? {
        if block == nil { return nil }
        if seconds < 0 || timeInterval <= 0 { return nil }
        
        let queue = mainThread ? DispatchQueue.main : DispatchQueue.global()
        let timer = DispatchSource.makeTimerSource(flags: [], queue: queue)
        
//        let delayTimeInterval = Date().timeIntervalSinceNow + Double(seconds)
//        let nowTimespec = timespec(tv_sec: __darwin_time_t(delayTimeInterval), tv_nsec: 0)
//        let wallTime = DispatchWallTime(timespec: nowTimespec)
//        timer.schedule(wallDeadline: wallTime, repeating: Double(timeInterval))
        
        timer.schedule(deadline: .now() + Double(seconds), repeating: Double(timeInterval), leeway: .nanoseconds(0))
        
        let _ = EVATimeSemaphore.wait(timeout: .distantFuture)
        
        let EVATimeID = "TIMER\(EVATimeDic.keys.count)"
        EVATimeDic[EVATimeID] = timer
        
        EVATimeSemaphore.signal()
        
        timer.setEventHandler { 
            DispatchQueue.main.async {
                block?()
                if repeats == false {
                    cancelEVATime(timerID: EVATimeID)
                }
            }
        }
        
        timer.resume()
        
        return EVATimeID
    }
    
    /// cancel timer run with timerID
    /// - Parameter timerID: timerID
    static func cancelEVATime(timerID: String?) {
        guard let timerID = timerID else {
            return
        }
        if timerID.count == 0 { return }
        let _ = EVATimeSemaphore.wait(timeout: .distantFuture)
        
        guard let timer: DispatchSourceTimer = EVATimeDic[timerID] else {
            EVATimeSemaphore.signal()
            return
        }
        timer.cancel()
        EVATimeDic.removeValue(forKey: timerID)
        EVATimeSemaphore.signal()
    }
}
