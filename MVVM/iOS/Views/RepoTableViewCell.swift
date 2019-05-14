//
//  RepoTableViewCell.swift
//  MVVM
//
//  Created by 张坤 on 2019/5/14.
//  Copyright © 2019 ripple_k. All rights reserved.
//

import UIKit

class RepoTableViewCell: BaseTableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        detailTextLabel?.numberOfLines = 0
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
