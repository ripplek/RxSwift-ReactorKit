//
//  RepoListViewReactor.swift
//  MVVM
//
//  Created by 张坤 on 2019/5/14.
//  Copyright © 2019 ripple_k. All rights reserved.
//

import RxSwift
import ReactorKit

class RepoListViewReactor: Reactor {
    enum Action {
        case refresh
        case loadMore
    }
    
    enum Mutation {
        case setRepos([Repo])
        case addRepos([Repo])
        case setLoading(Bool)
    }
    
    struct State {
        let name: String
        var isLoading = false
        var repos: [Repo] = []
        var status: RefreshStatus = .reset
        var page = 1
        
        init(name: String) {
            self.name = name
        }
    }
    
    let initialState: State
    let service = GitHubService.shared
    
    init(name: String) {
        initialState = State(name: name)
    }
    
    func mutate(action: RepoListViewReactor.Action) -> Observable<RepoListViewReactor.Mutation> {
        switch action {
        case .refresh:
            guard !self.currentState.isLoading else { return .empty() }
            let start = Observable.just(Mutation.setLoading(true))
            let end = Observable.just(Mutation.setLoading(false))
            let data = service
                .repos(username: currentState.name, page: 1)
                .asObservable()
                .map(Mutation.setRepos)
            return .concat([start, data, end])
        case .loadMore:
            guard !self.currentState.isLoading else { return .empty() }
            let start = Observable.just(Mutation.setLoading(true))
            let end = Observable.just(Mutation.setLoading(false))
            let data = service
                .repos(username: currentState.name, page: currentState.page + 1)
                .asObservable()
                .map(Mutation.addRepos)
            return .concat([start, data, end])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setRepos(let repos):
            state.repos = repos
            state.page = 1
            state.status = .reset
        case .addRepos(let repos):
            guard repos.isNotEmpty else {
                state.status = .noMore
                return state
            }
            state.page += 1
            state.repos += repos
            state.status = .end
        case .setLoading(let loading):
            state.isLoading = loading
        }
        return state
    }
}
