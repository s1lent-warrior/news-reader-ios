//
//  ArticleApiToDataModel.swift
//  NewsReader
//
//  Created by Muneeb Ahmed Anwar on 27/08/2025.
//

import Foundation

class ArticleApiToDataModelMapper {
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter
    }()

    static func map(_ model: ArticleResponseModel) -> Article {
        .init(
            id: model.id,
            title: model.title,
            byline: model.byline,
            section: model.section,
            abstract: model.abstract,
            url: model.url,
            publishedDate: model.publishedDate,
            thumbUrl: model.media.first?.mediaMetadata.first?.url,
            heroImageUrl: model.media.first?.mediaMetadata.last?.url
        )
    }
}
