//
//  APIClientTests.swift
//  NewsReader
//
//  Created by Muneeb Ahmed Anwar on 28/08/2025.
//

import Combine
import Foundation
import Testing

@testable import NewsReader

@MainActor
@Suite("NetworkService")
struct NetworkServiceTests {
    private var cancellables = Set<AnyCancellable>()

    @Test("fetch succeeds (200)")
    mutating func testFetchSuccess() async throws {
        let session = URLSession.makeSession(mockSuccess: true)
        let service = DefaultNetworkService(session: session)

        let requestModel = RequestModel(
            endPoint: NewsEndPoint.mostPopular(section: .all, period: .month, apiKey: "123")
        )

        service.fetch(from: requestModel).sink { completion in
            if case .finished = completion {
                #expect(true, "Request Completed Successfully")
            }
        } receiveValue: { (data: MostPopularResponseModel) in
            #expect(!data.articles.isEmpty, "Articles not empty")
        }
        .store(in: &cancellables)
    }

    @Test("fetch fails (non-200)")
    mutating func testFetchNon200() throws {
        let session = URLSession.makeSession(mockSuccess: true)
        let service = DefaultNetworkService(session: session)

        let requestModel = RequestModel(
            endPoint: NewsEndPoint.mostPopular(section: .all, period: .month, apiKey: "123")
        )

        MockURLProtocol.requestHandler = { _ in
            throw NetworkError.requestFailed(statusCode: 400)
        }

        service.fetch(from: requestModel).sink { completion in
            if case .failure = completion {
                #expect(true, "Request Failed!")
            }
        } receiveValue: { (data: MostPopularResponseModel) in
            #expect(data.articles.isEmpty, "Articles list is empty")
        }
        .store(in: &cancellables)
    }
}
