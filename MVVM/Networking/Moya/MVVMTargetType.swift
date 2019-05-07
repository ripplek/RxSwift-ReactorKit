//
//  MVVMTargetType.swift
//  MVVM
//
//  Created by 张坤 on 2019/5/7.
//  Copyright © 2019 ripple_k. All rights reserved.
//

import Moya

let baseURLString: String = "https://api.github.com"

public protocol MVVMTargetType: TargetType {
    var router: Router { get }
    
    var parameters: Parameters? { get }
    
    /// setup global parameters
    var parametersDefault: Parameters { get }
}

extension MVVMTargetType {
    public var baseURL: URL {
        return URL(string: baseURLString)!
    }
    
    public var path: String {
        return router.path
    }
    
    public var method: Method {
        return router.method
    }
    
    /// setup global parameters
    public var parametersDefault: Parameters {
        let defaultParameter = parameters ?? [:]
        
        return defaultParameter
    }
    
    public var task: Task {
        return .requestParameters(parameters: parametersDefault.values, encoding: parametersDefault.encoding)
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var headers: [String : String]? {
        return [:]
    }
}
