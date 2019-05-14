//
//  HomePageViewReactor.swift
//  MVVM
//
//  Created by 张坤 on 2019/5/5.
//  Copyright © 2019 ripple_k. All rights reserved.
//

import RxSwift
import ReactorKit

class HomepageViewReactor: Reactor {
    enum Action {
        case loadOrgs([String])
    }
    
    enum Mutation {
        case setOrgReactor([OrgTableViewCellReactor])
    }
    
    struct State {
        var section: [HomepageViewController.Section] = []
    }
    
    var initialState = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadOrgs(let orgs):
            return Observable
                .just(orgs.map { OrgTableViewCellReactor(name: $0) })
                .map(Mutation.setOrgReactor)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setOrgReactor(let reactors):
            state.section = [HomepageViewController.Section(model: (), items: reactors)]
        }
        return state
    }
}
