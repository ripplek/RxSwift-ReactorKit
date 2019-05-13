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

class HomepageViewController: BaseViewController, View {
    typealias Section = SectionModel<Void, OrgTableViewCellReactor>
    
    // MARK: - Property Private
    private lazy var dataSource = self.dataSourceCreator()
    private let owners = ["apple"]
    
    // MARK: - UI
    private let tableView = UITableView().then {
        $0.registerCellClass(OrgTableViewCell.self)
        $0.rowHeight = 60
        $0.tableFooterView = UIView()
    }

    // MARK: - View Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "MVVM"
        view.backgroundColor = UIColor.white
        view.addSubview(tableView)
        tableView
            .snp.makeConstraints({ (make) in
                make.edges.equalToSuperview()
            })
    }
    
    func bind(reactor: HomepageViewReactor) {
        // Action
        self.rx.viewDidLoad
            .map { [unowned self] in Reactor.Action.loadOrgs(self.owners) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // State
        reactor.state.map { $0.section }
            .filterEmpty()
            .do(onNext: { (s) in
                print(s.count)
            })
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    override func setupConstraints() {
        
    }
    
    private func dataSourceCreator() -> RxTableViewSectionedReloadDataSource<Section> {
        return .init(configureCell: { (ds, tv, ip, e) -> UITableViewCell in
            let cell = tv.dequeueCell(OrgTableViewCell.self)
            cell.reactor = e
            return cell
        })
    }
}
