//
//  HomePageViewController.swift
//  MVVM
//
//  Created by 张坤 on 2019/5/5.
//  Copyright © 2019 ripple_k. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import ReactorKit

class HomepageViewController: MVVMViewController, View {

    // MARK - View Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "MVVM"
        view.backgroundColor = UIColor.white
    }
    
    func bind(reactor: HomepageViewReactor) {
        
    }
}
