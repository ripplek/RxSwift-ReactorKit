//
//  GitHubModel.swift
//  MVVM
//
//  Created by 张坤 on 2019/5/13.
//  Copyright © 2019 ripple_k. All rights reserved.
//

import Foundation

struct Org: Codable {
    let avatarUrl: URL?
    let description: String
    let name: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        avatarUrl = try? container.decodeIfPresent(URL.self, forKey: .avatarUrl)
        description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
    }
}

struct Repo: Codable {
    let id: Int
    let name: String
    let fullName: String
    let description: String
    let url: URL?
    let htmlUrl: URL?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        fullName = try container.decodeIfPresent(String.self, forKey: .fullName) ?? ""
        description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        url = try? container.decodeIfPresent(URL.self, forKey: .url)
        htmlUrl = try? container.decodeIfPresent(URL.self, forKey: .htmlUrl)
    }
}

extension Repo: Equatable { }
extension Org: Equatable { }
