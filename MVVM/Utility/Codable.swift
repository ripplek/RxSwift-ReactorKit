//
//  Codable.swift
//  MVVM
//
//  Created by 张坤 on 2019/5/13.
//  Copyright © 2019 ripple_k. All rights reserved.
//

import Foundation

extension KeyedDecodingContainer {
    public func decodeIfPresent(_ type: URL.Type, forKey key: K) throws -> URL? {
        guard let str = try decodeIfPresent(String.self, forKey: key)
            else { return nil }
        return URL(string: str)
    }
}
