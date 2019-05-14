//
//  RepoListViewController.swift
//  MVVM
//
//  Created by 张坤 on 2019/5/14.
//  Copyright © 2019 ripple_k. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import RxDataSources
import MJRefresh

class RepoListViewController: BaseViewController, View {
    typealias Section = SectionModel<Void, Repo>
    
    // MARK: - UI
    
    private let tableView = UITableView().then { (tv) in
        tv.registerCellClass(RepoTableViewCell.self)
        tv.mj_header = MJRefreshNormalHeader()
        tv.mj_footer = MJRefreshAutoNormalFooter()
        tv.tableFooterView = UIView()
    }
    
    // MARK: - Property Private
    
    private lazy var dataSource = self.dataSourceCreator()
    
    // MARK: - Life Circle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView
            .mvvm.adhere(toSuperView: view)
            .mvvm.layout { (make) in
                make.edges.equalToSuperview()
        }
    }
    
    func bind(reactor: RepoListViewReactor) {
        // Action
        self.rx.viewDidLoad
            .map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tableView.mj_header.rx.event
            .map { _ in Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tableView.mj_footer.rx.event
            .map { _ in Reactor.Action.loadMore }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // State
        reactor.state.map { $0.repos }
            .filterEmpty()
            .distinctUntilChanged()
            .map { [Section(model: (), items: $0)] }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.status }
            .bind(to: tableView.mj_footer.rx.status)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.status == .reset }
            .filter { $0 }
            .bind(to: tableView.mj_header.rx.endRefresh)
            .disposed(by: disposeBag)
    }
    
    private func dataSourceCreator() -> RxTableViewSectionedReloadDataSource<Section> {
        return .init(configureCell: { (ds, tv, ip, e) -> UITableViewCell in
            let cell = tv.dequeueCell(RepoTableViewCell.self)
            cell.textLabel?.text = e.name
            cell.detailTextLabel?.text = e.description
            return cell
        })
    }
}

