//
//  GitHubAPI.swift
//  MVVM
//
//  Created by 张坤 on 2019/5/7.
//  Copyright © 2019 ripple_k. All rights reserved.
//

import Foundation

enum GitHubAPI {
    case repos(username: String)
}

extension GitHubAPI: MVVMTargetType {
    var router: Router {
        switch self {
        case .repos(let username):
            return .get("/users/\(username)/repos?sort=updated")
        }
    }
    
    var parameters: Parameters? {
        return nil
    }
}
