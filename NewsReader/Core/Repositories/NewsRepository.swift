//
//  NewsRepository.swift
//  NewsReader
//
//  Created by Muneeb Ahmed Anwar on 28/08/2025.
//

import Combine

protocol NewsRepository {
    func loadMostPopular(section: NewsSection, period: NewsPeriod) -> AnyPublisher<[Article], Error>
}

class NewsDataRepository: NewsRepository {

    private let networkService: NetworkService
    private lazy var apiKey: String = {
        "DIT9ZamrqMgAPqVoW3uD12q0MbG3o8HW"
    }()

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func loadMostPopular(section: NewsSection, period: NewsPeriod) -> AnyPublisher<[Article], Error> {
        let request = RequestModel(
            endPoint: NewsEndPoint.mostPopular(section: section, period: period, apiKey: apiKey)
        )
        return networkService.fetch(from: request)
            .tryMap { (data: MostPopularResponseModel) -> [Article] in
                data.articles.map(ArticleApiToDataModelMapper.map)
            }
            .eraseToAnyPublisher()
    }
}
