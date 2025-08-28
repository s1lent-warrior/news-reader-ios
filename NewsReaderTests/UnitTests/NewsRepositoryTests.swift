//
//  NewsRepositoryTests.swift
//  NewsReader
//
//  Created by Muneeb Ahmed Anwar on 28/08/2025.
//

import Combine
import Foundation
import Testing

@testable import NewsReader

@MainActor
@Suite("NewsRepositoryTests")
struct NewsRepositoryTests {

    private var cancellables = Set<AnyCancellable>()

    @Test("fetches & maps Most Popular payload")
    mutating func testFetchingAndMapping() async throws {
        let session = URLSession.makeSession(mockSuccess: true)
        let service = DefaultNetworkService(session: session)
        let repository = NewsDataRepository(networkService: service)
        repository.loadMostPopular(section: .automobiles, period: .day).sink { completion in
            if case .finished = completion {
                #expect(true, "Most Popular Articles Fetched Successfully")
            }
        } receiveValue: { (articles: [Article]) in
            #expect(articles.isEmpty, "Articles not empty")
            #expect(articles.first?.title.isEmpty == false)
            #expect(articles.first?.url.absoluteString.isEmpty == false)
        }
        .store(in: &cancellables)
    }
}
