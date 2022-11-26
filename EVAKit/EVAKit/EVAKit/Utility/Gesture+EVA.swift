//
//  Gesture+EVA.swift
//  EVAKit
//
//  Created by LuKane on 2022/11/25.
//

import Foundation
import UIKit

public enum EVAGestureRecognizerState {
    case began, moved, ended, cancelled
}

public class EVAGestureRecognizer: UIGestureRecognizer {
    
    public typealias EVAGestureAction = (_ gesture: EVAGestureRecognizer, _ state: EVAGestureRecognizerState) -> ()
    
    internal var startPoint: CGPoint = .zero
    internal var lastPoint: CGPoint = .zero
    internal var currentPoint: CGPoint = .zero
    private var actionBlock: EVAGestureAction?
    
    open func gestureActionBlock(action: @escaping EVAGestureAction) {
        actionBlock = action
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        guard let firstTouch = touches.first else {
            return
        }
        state = .began
        startPoint = firstTouch.location(in: view)
        lastPoint = startPoint
        currentPoint = startPoint
        actionBlock?(self, .began)
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        guard let firstTouch = touches.first else {
            return
        }
        state = .changed
        currentPoint = firstTouch.location(in: view)
        actionBlock?(self, .moved)
        lastPoint = currentPoint
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        state = .ended
        actionBlock?(self, .ended)
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        state = .cancelled
        actionBlock?(self, .cancelled)
    }
    
    open func cancelAll() {
        if state == .began || state == .changed || state == .ended || state == .cancelled {
            actionBlock?(self, .cancelled)
        }
    }
}
