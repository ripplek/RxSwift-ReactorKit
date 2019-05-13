//
//  OrgTableViewCell.swift
//  MVVM
//
//  Created by 张坤 on 2019/5/13.
//  Copyright © 2019 ripple_k. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import RxOptional
import Kingfisher

class OrgTableViewCell: BaseTableViewCell, ReactorKit.View {
    var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(reactor: OrgTableViewCellReactor) {
        reactor.action.onNext(.org)
        reactor.state
            .map { $0.org }
            .filterNil()
            .subscribe(onNext: { [weak self] (org) in
                self?.imageView?.kf.setImage(with: org.avatarUrl)
                self?.textLabel?.text = org.name
                self?.detailTextLabel?.text = org.description
            })
            .disposed(by: disposeBag)
    }
}
