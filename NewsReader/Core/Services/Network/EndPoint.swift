//
//  EndPoint.swift
//  NewsReader
//
//  Created by Muneeb Ahmed Anwar on 27/08/2025.
//

import Foundation

public protocol EndPoint {
    var scheme: HttpScheme { get }
    var baseURL: String { get }
    var path: String { get }
    var parameters: [String: String?] { get }
}

public extension EndPoint {
    var url: URL? {
        var components = URLComponents()
        components.scheme = scheme.rawValue
        components.host = baseURL
        components.path = path
        components.queryItems = parameters.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        return components.url
    }
}
