//
//  OrgTableViewCellReactor.swift
//  MVVM
//
//  Created by 张坤 on 2019/5/13.
//  Copyright © 2019 ripple_k. All rights reserved.
//

import RxSwift
import ReactorKit

class OrgTableViewCellReactor: Reactor {
    enum Action {
        case org
    }
    
    enum Mutation {
        case set(org: Org)
    }
    
    struct State {
        let name: String
        var org: Org?
        init(name: String) {
            self.name = name
        }
    }
    
    let initialState: State
    let service = GitHubService.shared
    
    init(name: String) {
        initialState = State(name: name)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .org:
            return service
                .orgs(orgname: currentState.name)
                .asObservable()
                .map(Mutation.set(org:))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .set(let org):
            state.org = org
        }
        return state
    }
}
