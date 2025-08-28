//
//  MockNewsRepository.swift
//  NewsReader
//
//  Created by Muneeb Ahmed Anwar on 28/08/2025.
//

import Combine
import Foundation

@testable import NewsReader

class MockNewsRepository: NewsRepository {

    private let mockSuccess: Bool

    init(mockSuccess: Bool) {
        self.mockSuccess = mockSuccess
    }

    func loadMostPopular(section: NewsSection, period: NewsPeriod) -> AnyPublisher<[Article], any Error> {
        if mockSuccess {
            Just(dummyArticles)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            Fail(
                error: NSError(domain: "MockError", code: 0, userInfo: nil)
            )
            .eraseToAnyPublisher()
        }
    }

    private var dummyArticles: [Article] = [
        Article(
            id: 1,
            title: "Article 1",
            byline: "Author 1",
            section: "sports",
            abstract: "",
            url: URL(string: "https://localhost.com")!,
            publishedDate: "2025-12-12",
            thumbUrl: nil,
            heroImageUrl: nil
        ),
        Article(
            id: 2,
            title: "Article 2",
            byline: "Author 2",
            section: "business",
            abstract: "",
            url: URL(string: "https://localhost.com")!,
            publishedDate: "2025-12-12",
            thumbUrl: nil,
            heroImageUrl: nil
        ),
        Article(
            id: 3,
            title: "Article 3",
            byline: "Author 3",
            section: "sports",
            abstract: "",
            url: URL(string: "https://localhost.com")!,
            publishedDate: "2025-12-12",
            thumbUrl: nil,
            heroImageUrl: nil
        ),
        Article(
            id: 4,
            title: "Article 4",
            byline: "Author 4",
            section: "business",
            abstract: "",
            url: URL(string: "https://localhost.com")!,
            publishedDate: "2025-12-12",
            thumbUrl: nil,
            heroImageUrl: nil
        )
    ]
}
