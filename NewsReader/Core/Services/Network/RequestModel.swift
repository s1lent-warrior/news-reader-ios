//
//  RequestModel.swift
//  NewsReader
//
//  Created by Muneeb Ahmed Anwar on 27/08/2025.
//

import Foundation

public struct RequestModel {
    let endPoint: EndPoint
    let httpMethod: HttpMethod
    let headers: [String: String]
    let body: Data?
    let requestTimeOut: TimeInterval?

    var urlRequest: URLRequest {
        guard let url = endPoint.url else {
            fatalError("URL not found for EndPoint: \(endPoint)")
        }

        var request = URLRequest(url: url)
        if let requestTimeOut {
            request.timeoutInterval = requestTimeOut
        }
        request.httpMethod = httpMethod.rawValue
        request.httpBody = body
        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }

        return request
    }

    public init(
        endPoint: EndPoint,
        httpMethod: HttpMethod = .get,
        headers: [String: String] = [:],
        body: Data? = nil,
        timeout: TimeInterval? = nil
    ) {
        self.endPoint = endPoint
        self.httpMethod = httpMethod
        self.body = body
        self.requestTimeOut = timeout
        self.headers = headers
    }
}
