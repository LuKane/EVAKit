//
//  EVA.swift
//  EVAKit
//
//  Created by LuKane on 2022/11/25.
//

import Foundation

public struct EVAWrapper<Base> {
    public let base: Base
    public init(_ base: Base) { self.base = base }
}

public protocol EVACompatible: AnyObject {}

extension EVACompatible {
    public var vk: EVAWrapper<Self> { 
        set {}
        get { EVAWrapper(self) }
    }
    public static var vk: EVAWrapper<Self>.Type {
        set {}
        get { EVAWrapper<Self>.self }
    }
}


