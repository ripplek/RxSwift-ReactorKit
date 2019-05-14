//
//  GitHubAPI.swift
//  MVVM
//
//  Created by 张坤 on 2019/5/7.
//  Copyright © 2019 ripple_k. All rights reserved.
//

import Foundation

enum GitHubAPI {
    case orgs(orgName: String)
    case repos(username: String, page: Int)
}

extension GitHubAPI: MVVMTargetType {
    var router: Router {
        switch self {
        case .repos(let param):
            return .get("/users/\(param.username)/repos")
        case .orgs(let orgName):
            return .get("orgs/\(orgName)")
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .repos(let page):
            return ["page": page, "sort": "updated"]
        default:
            return nil
        }
    }
}
