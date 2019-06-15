//
//  BaseCollectionViewCell.swift
//  MVVM
//
//  Created by 张坤 on 2019/5/13.
//  Copyright © 2019 ripple_k. All rights reserved.
//

import UIKit
import RxSwift

open class BaseCollectionViewCell: UICollectionViewCell {
    public private(set) var reuseDisposeBag = DisposeBag()
    
    // MARK: Initializing
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        self.reuseDisposeBag = DisposeBag()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }
    
    open func setupSubviews() {
        // Override point
    }
}
