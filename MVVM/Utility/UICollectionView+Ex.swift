//
//  UICollectionView+Ex.swift
//  MVVM
//
//  Created by 张坤 on 2019/5/13.
//  Copyright © 2019 ripple_k. All rights reserved.
//

import UIKit

public extension UICollectionView {
    
    func registerItemClass<T: UICollectionViewCell>(_ itemClass: T.Type) {
        let identifier = className(itemClass)
        register(itemClass, forCellWithReuseIdentifier: identifier)
    }
    
    func registerItemNib<T: UICollectionViewCell>(_ nibName: String? = nil, itemNib: T.Type) {
        let identifier = className(itemNib)
        let nameOfnib = nibName ?? identifier
        let bundle = Bundle(for: itemNib)
        let nib = UINib(nibName: nameOfnib, bundle: bundle)
        register(nib, forCellWithReuseIdentifier: identifier)
    }
    
    func registerforSupplementary<T: UIView>(_ viewClass: T.Type, kind: String) {
        let identifier = className(viewClass)
        register(viewClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
    }
    
    func registerForSupplementary<T: UIView>(_ nibName: String? = nil,
                                             nibClass: T.Type,
                                             kind: String) {
        let identifier = className(nibClass)
        let nameOfnib = nibName ?? identifier
        let bundle = Bundle(for: nibClass)
        let nib = UINib(nibName: nameOfnib, bundle: bundle)
        register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
    }
    
    func dequeueItem<T: UICollectionViewCell>
        (_ itemClass: T.Type,
         for indexPath: IndexPath) -> T {
        let identifier = className(itemClass)
        
        // swiftlint:disable force_cast
        return dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! T
    }
    
    func dequeueReusableView<T: UICollectionReusableView>
        (_ viewClass: T.Type, kind: String, for indexPath: IndexPath) -> T {
        let identifer = className(viewClass)
        return dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifer, for: indexPath) as! T
    }
}
