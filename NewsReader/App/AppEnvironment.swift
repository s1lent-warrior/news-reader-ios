//
//  AppEnvironment.swift
//  NewsReader
//
//  Created by Muneeb Ahmed Anwar on 28/08/2025.
//

import Combine

@MainActor
final class AppEnvironment: ObservableObject {
    let newsRepository: NewsRepository

    init(newsRepository: NewsRepository) {
        self.newsRepository = newsRepository
    }

    static func bootstrap() -> AppEnvironment {
        let networkService: NetworkService = DefaultNetworkService(session: .shared)
        return .init(newsRepository: NewsDataRepository(networkService: networkService))
    }
}
