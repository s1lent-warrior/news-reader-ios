//
//  Article.swift
//  NewsReader
//
//  Created by Muneeb Ahmed Anwar on 27/08/2025.
//

import Foundation

struct ArticleResponseModel: Codable {
    let id: Int64
    let assetId: Int64
    let title: String
    let byline: String
    let section: String
    let abstract: String
    let url: URL
    let publishedDate: String
    let media: [MediaResponseModel]

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case byline
        case section
        case abstract
        case url
        case media
        case assetId = "asset_id"
        case publishedDate = "published_date"
    }
}
