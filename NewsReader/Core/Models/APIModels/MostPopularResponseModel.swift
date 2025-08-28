//
//  MostPopularResponse.swift
//  NewsReader
//
//  Created by Muneeb Ahmed Anwar on 27/08/2025.
//

import Foundation

struct MostPopularResponseModel: Codable {
    let status: String
    let resultsCount: Int
    let articles: [ArticleResponseModel]

    enum CodingKeys: String, CodingKey {
        case status
        case articles = "results"
        case resultsCount = "num_results"
    }
}
