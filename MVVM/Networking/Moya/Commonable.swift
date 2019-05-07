//
//  Commonable.swift
//  MVVM
//
//  Created by 张坤 on 2019/5/7.
//  Copyright © 2019 ripple_k. All rights reserved.
//

import Foundation
import RxSwift

public extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}

public struct Commonable<T: Codable>: Codable {
    public var code: Int
    public var msg: String
    public var data: T
    
    static func `default`(_ data: T) -> Commonable {
        return Commonable(code: 50000, msg: "error", data: data)
    }
}

public struct CommonableList<T: Codable>: Codable {
    public var code: Int
    public var msg: String
    public var data: List<T>
    
    static var empty: CommonableList {
        return CommonableList<T>.init(code: -1, msg: "", data: List<T>.init(list: []))
    }
    
    public struct List<T: Codable>: Codable {
        public let list: [T]
        
        private enum CodingKeys: String, CodingKey {
            case list
        }
    }
}

public struct LogMessage: Error, Decodable {
    public let code: Int
    public let message: String
    
    private enum CodingKeys: String, CodingKey {
        case code
        case message = "msg"
    }
    
    public init(code: Int, message: String) {
        self.code = code
        self.message = message
    }
    
    static let normalCode = 0
    static let successCode = 10000
}

extension LogMessage {
    func updateFailure(newMessage: String) -> LogMessage {
        switch code {
        case LogMessage.successCode:
            return self
        default:
            return LogMessage(code: code, message: newMessage)
        }
    }
}

extension LogMessage: Equatable {
    public static func == (lhs: LogMessage, rhs: LogMessage) -> Bool {
        return lhs.code == lhs.code
    }
    
}


public struct NoEvent {}

public protocol ModelType: Codable, Then {
    associatedtype Event
    
    static var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy { get }
}

extension ModelType {
    public static var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy {
        return JSONDecoder.DateDecodingStrategy.secondsSince1970
    }
    
    public static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = self.dateDecodingStrategy
        return decoder
    }
}

private var streams: [String: Any] = [:]

extension ModelType {
    public static var event: PublishSubject<Event> {
        let key = String(describing: self)
        if let stream = streams[key] as? PublishSubject<Event> {
            return stream
        }
        let stream = PublishSubject<Event>()
        streams[key] = stream
        return stream
    }
}

