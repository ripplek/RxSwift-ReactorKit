//
//  MJRefresh+Rx.swift
//  MVVM
//
//  Created by 张坤 on 2019/5/14.
//  Copyright © 2019 ripple_k. All rights reserved.
//

import RxSwift
import RxCocoa
import MJRefresh

public enum RefreshStatus {
    case reset
    case end
    case noMore
}

public class RxTarget: NSObject, Disposable {  // RxTarget 是 Rxswift 源码
    private var retainSelf: RxTarget?
    public override init() {
        super.init()
        self.retainSelf = self
    }
    public func dispose() {
        self.retainSelf = nil
    }
}

public final class RefreshTarget<Component: MJRefreshComponent>: RxTarget {
    public typealias Callback = MJRefreshComponentRefreshingBlock
    public var callback: Callback?
    public weak var component: Component?
    
    public let selector = #selector(RefreshTarget.eventHandler)
    
    public init(_ component: Component, callback: @escaping Callback) {
        self.callback = callback
        self.component = component
        super.init()
        component.setRefreshingTarget(self, refreshingAction: selector)
    }
    @objc public func eventHandler() {
        if let callback = self.callback {
            callback()
        }
    }
    override public func dispose() {
        super.dispose()
        self.component?.refreshingBlock = nil
        self.callback = nil
    }
}

extension Reactive where Base: MJRefreshComponent {
    public var event: ControlEvent<Base> {
        let source: Observable<Base> = Observable.create { [weak control = self.base] observer  in
            MainScheduler.ensureExecutingOnScheduler()
            guard let control = control else {
                observer.on(.completed)
                return Disposables.create()
            }
            let observer = RefreshTarget(control) {
                observer.on(.next(control))
            }
            return observer
            }.takeUntil(deallocated)
        return ControlEvent(events: source)
    }
}

extension Reactive where Base: MJRefreshHeader {
    public var endRefresh: Binder<Bool> {
        return Binder.init(base, binding: { (refresher, shouldEnd) in
            if shouldEnd {
                if refresher.isRefreshing {
                    refresher.endRefreshing()
                }
            }
        })
    }
}

extension Reactive where Base: MJRefreshFooter {
    public var status: Binder<RefreshStatus> {
        return Binder.init(base, binding: { (refresher, status) in
            switch status {
            case .reset:
                refresher.resetNoMoreData()
                
            case .end:
                refresher.endRefreshing()
                
            case .noMore:
                refresher.endRefreshingWithNoMoreData()
            }
        })
    }
}
