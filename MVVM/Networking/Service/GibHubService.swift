//
//  GibHubService.swift
//  MVVM
//
//  Created by 张坤 on 2019/5/7.
//  Copyright © 2019 ripple_k. All rights reserved.
//

import RxSwift

protocol GitHubServiceType {
    func orgs(orgname: String) -> Single<Org>
    func repos(username: String, page: Int) -> Single<[Repo]>
}

class GitHubService: GitHubServiceType {
    public static let shared = GitHubService()
    
    private let _networking = Networking<GitHubAPI>()
    
    func orgs(orgname: String) -> Single<Org> {
        return _networking
            .request(.orgs(orgName: orgname))
            .mapModel(Org.self)
    }
    
    func repos(username: String, page: Int) -> Single<[Repo]> {
        return _networking
            .request(.repos(username: username, page: page))
            .mapModel([Repo].self)
    }
}
