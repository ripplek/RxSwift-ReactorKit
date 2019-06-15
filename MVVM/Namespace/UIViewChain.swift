//
//  UIViewChain.swift
//  MVVM
//
//  Created by 张坤 on 2019/5/6.
//  Copyright © 2019 ripple_k. All rights reserved.
//

import UIKit
import SnapKit

extension UIView: NamespaceWrappable { }
extension NamespaceWrapper where T: UIView {
    public func adhere(toSuperView: UIView) -> T {
        toSuperView.addSubview(wrappedValue)
        return wrappedValue
    }
    
    public func inserthere(belowSubview: UIView) -> T {
        belowSubview.superview?.insertSubview(wrappedValue, belowSubview: belowSubview)
        return wrappedValue
    }
    
    public func inserthere(aboveSubview: UIView) -> T {
        aboveSubview.superview?.insertSubview(wrappedValue, aboveSubview: aboveSubview)
        return wrappedValue
    }
    
    @discardableResult
    public func layout(snapKitMaker: (ConstraintMaker) -> Void) -> T {
        wrappedValue.snp.makeConstraints { (make) in
            snapKitMaker(make)
        }
        return wrappedValue
    }
    
    @discardableResult
    public func config(_ config: (T) -> Void) -> T {
        config(wrappedValue)
        return wrappedValue
    }
}
