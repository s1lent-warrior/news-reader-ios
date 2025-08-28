//
//  NewsEndPoint.swift
//  NewsReader
//
//  Created by Muneeb Ahmed Anwar on 27/08/2025.
//

public enum NewsEndPoint: EndPoint {
    case mostPopular(section: NewsSection, period: NewsPeriod, apiKey: String)

    public var scheme: HttpScheme { .https }

    public var baseURL: String { "api.nytimes.com" }

    public var path: String {
        switch self {
        case let .mostPopular(section, period, _):
            "/svc/mostpopular/v2/mostviewed/\(section.rawValue)/\(period.rawValue).json"
        }
    }

    public var parameters: [String : String?] {
        switch self {
        case let .mostPopular(_, _, apiKey):
            ["api-key": apiKey]
        }
    }
}
