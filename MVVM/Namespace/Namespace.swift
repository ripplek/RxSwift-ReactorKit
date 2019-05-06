//
//  Namespace.swift
//  MVVM
//
//  Created by 张坤 on 2019/5/5.
//  Copyright © 2019 ripple_k. All rights reserved.
//

public protocol NamespaceWrappable {
    associatedtype MVVMWrappable
    var mvvm: MVVMWrappable { get }
    static var mvvm: MVVMWrappable.Type { get }
}

public extension NamespaceWrappable {
    var mvvm: NamespaceWrapper<Self> {
        return NamespaceWrapper(value: self)
    }
    
    static var mvvm: NamespaceWrapper<Self>.Type {
        return NamespaceWrapper.self
    }
}

public struct NamespaceWrapper<T> {
    public let wrappedValue: T
    public init(value: T) {
        self.wrappedValue = value
    }
}
