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
@Suite("ArticlesListViewModelTests")
struct ArticlesListViewModelTests {

    @Test("ViewModel goes: idle -> loading -> loaded")
    func testLoadingArticles() async throws {
        let repository = MockNewsRepository(mockSuccess: true)
        let viewModel = ArticlesListViewModel(title: "NY Times News", repository: repository)
        #expect(viewModel.state == .idle)

        viewModel.refresh(section: .arts, period: .month)

        #expect(viewModel.state == .loading)

        try await Task.sleep(nanoseconds: 300_000_000)

        #expect(!viewModel.filteredArticles.isEmpty)
        #expect(viewModel.state == .loaded)
    }

    @Test("ViewModel: Searching returns filtered results")
    func testArticlesSearchingFiltering() async throws {
        let repository = MockNewsRepository(mockSuccess: true)
        let viewModel = ArticlesListViewModel(title: "NY Times News", repository: repository)
        #expect(viewModel.filteredArticles.isEmpty, "Articles Initially Empty")
        #expect(viewModel.searchText.isEmpty, "Search Text is Initially Empty")

        viewModel.refresh(section: .arts, period: .month)

        try await Task.sleep(nanoseconds: 100_000_000)

        #expect(viewModel.state == .loaded)
        #expect(!viewModel.filteredArticles.isEmpty, "Filtered Articles > zero")
        let articlesCount = viewModel.filteredArticles.count

        viewModel.searchText = "xyz"

        #expect(viewModel.filteredArticles.count != articlesCount)
    }
}
