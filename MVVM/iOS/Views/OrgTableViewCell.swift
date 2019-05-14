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
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let imgV = UIImageView()
    let title = UILabel()
    
    func bind(reactor: OrgTableViewCellReactor) {
        reactor.action.onNext(.org)
        reactor.state
            .map { $0.org }
            .filterNil()
            .subscribe(onNext: { [weak self] (org) in
                self?.imgV.kf.setImage(with: org.avatarUrl)
                self?.title.text = org.name
            })
            .disposed(by: reuseDisposeBag)
    }
    
    override func setupSubviews() {
        imgV
            .mvvm.adhere(toSuperView: contentView)
            .mvvm.config({
                $0.layer.cornerRadius = 5
                $0.layer.masksToBounds = true
                $0.contentMode = .scaleAspectFill
            })
            .mvvm.layout { (make) in
                make.centerY.equalToSuperview()
                make.left.equalTo(10)
                make.width.height.equalTo(30)
        }
        
        title
            .mvvm.adhere(toSuperView: contentView)
            .mvvm.config({
                $0.font = UIFont.boldSystemFont(ofSize: 20)
                $0.textColor = UIColor.black
            })
            .mvvm.layout { (make) in
                make.left.equalTo(imgV.snp.right).offset(10)
                make.centerY.equalToSuperview()
        }
    }
}
