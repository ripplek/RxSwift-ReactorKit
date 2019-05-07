//
//  GibHubService.swift
//  MVVM
//
//  Created by 张坤 on 2019/5/7.
//  Copyright © 2019 ripple_k. All rights reserved.
//

import RxSwift

protocol GitHubServiceType {
    func repos(username: String) -> Single<[String]>
}
