//
//  Networking.swift
//  MVVM
//
//  Created by 张坤 on 2019/5/6.
//  Copyright © 2019 ripple_k. All rights reserved.
//

import Foundation
import Moya
import RxSwift

open class Networking<Target: TargetType>: MoyaProvider<Target> {
    func request(
        _ target: Target,
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
        ) -> Single<Response> {
        let requestString = "\(target.method) \(target.path)"
        return self.rx.request(target)
            .do(onSuccess: { (value) in
                let message = "SUCCESS: \(requestString) (\(value.statusCode))"
                log.debug(message, file: file, function: function, line: line)
            }, onError: { (error) in
                if let response = (error as? MoyaError)?.response {
                    if let jsonObject = try? response.mapJSON(failsOnEmptyData: false) {
                        let message = "FAILURE: \(requestString) (\(response.statusCode))\n\(jsonObject)"
                        log.warning(message, file: file, function: function, line: line)
                    } else if let rawString = String(data: response.data, encoding: .utf8) {
                        let message = "FAILURE: \(requestString) (\(response.statusCode))\n\(rawString)"
                        log.warning(message, file: file, function: function, line: line)
                    } else {
                        let message = "FAILURE: \(requestString) (\(response.statusCode))"
                        log.warning(message, file: file, function: function, line: line)
                    }
                } else {
                    let message = "FAILURE: \(requestString)\n\(error)"
                    log.warning(message, file: file, function: function, line: line)
                }
            }, onSubscribe: {
                let message = "REQUEST: \(requestString)"
                log.debug(message, file: file, function: function, line: line)
            })
    }
}
