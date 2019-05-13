//
//  Paging.swift
//  MVVM
//
//  Created by 张坤 on 2019/5/13.
//  Copyright © 2019 ripple_k. All rights reserved.
//

import Foundation

//public enum Paging {
//    case refresh
//    case next(Int)
//}
private var pages: [String: Int] = [:]
struct Paging {
    static func refresh(file: StaticString = #file,
                        line: UInt = #line) -> Int {
        let key = file.description + line.description
        pages[key] = 1
        return 1
    }
    
    static func next(file: StaticString = #file,
                     line: UInt = #line) -> Int {
        let key = file.description + line.description
        if let currentPage = pages[key] {
            pages[key] = currentPage + 1
        } else {
            pages[key] = 1
        }
        return pages[key]!
    }
}

//extension Paging: Equatable {
//    public static func == (lhs: Paging, rsh: Paging) -> Bool {
//        switch (lhs, rsh) {
//        case (.refresh, .refresh):
//            return true
//
//        case let (.next(lNum), .next(rNum)) where lNum == rNum:
//            return true
//
//        default:
//            return false
//        }
//    }
//}
