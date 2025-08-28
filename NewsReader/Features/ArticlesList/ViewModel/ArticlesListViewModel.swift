//
//  ArticlesListViewModel.swift
//  NewsReader
//
//  Created by Muneeb Ahmed Anwar on 28/08/2025.
//

import Combine
import Foundation
import SwiftUI

enum LoadState: Equatable {
    case idle, loading, loaded, empty, failed(String)
}

final class ArticlesListViewModel: ObservableObject {

    @Published var section: NewsSection = .all
    @Published var period: NewsPeriod = .week
    @Published var searchText: String = ""
    @Published var showSearchBar: Bool = false

    @Published private(set) var title: String
    @Published private(set) var state: LoadState = .idle
    @Published private(set) var toolbarColorScheme: ColorScheme = .dark

    private var articles: [Article] = []

    var filteredArticles: [Article] {
        if searchText.isEmpty {
            articles
        } else {
            articles.filter {
                $0.title.contains(searchText) ||
                $0.byline.contains(searchText) ||
                $0.abstract.contains(searchText)
            }
        }
    }

    private let repository: NewsRepository
    private var cancellables = Set<AnyCancellable>()

    init(title: String, repository: NewsRepository) {
        self.title = title
        self.repository = repository
        // Auto refresh when period or section changes (debounced to avoid spamming API)
        $period
            .removeDuplicates()
            .debounce(for: .milliseconds(250), scheduler: DispatchQueue.main)
            .sink { [weak self] newPeriod in
                self?.refresh(period: newPeriod)
            }
            .store(in: &cancellables)

        $section
            .removeDuplicates()
            .debounce(for: .milliseconds(250), scheduler: DispatchQueue.main)
            .sink { [weak self] newSection in
                self?.refresh(section: newSection)
            }
            .store(in: &cancellables)
    }

    func refresh(section: NewsSection? = .none, period: NewsPeriod? = .none) {
        state = .loading
        searchText = ""
        showSearchBar = false

        repository.loadMostPopular(
            section: section ?? self.section,
            period: period ?? self.period
        )
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.state = .failed(error.localizedDescription)
                }
            } receiveValue: { [weak self] items in
                self?.articles = items
                self?.state = items.isEmpty ? .empty : .loaded
            }
            .store(in: &cancellables)
    }

    func updateLoadingState() {
        state = filteredArticles.isEmpty ? .empty : .loaded
    }
}

extension NewsPeriod {
    var title: String {
        switch self {
        case .day:
            "1 Day"
        case .week:
            "7 Days"
        case .month:
            "30 Days"
        }
    }
}

extension NewsSection {
    var title: String {
        switch self {
        case .all:
            "All"
        case .arts:
            "Arts"
        case .automobiles:
            "Automobiles"
        case .books:
            "Books"
        case .briefing:
            "Briefing"
        case .business:
            "Business"
        case .climate:
            "Climate"
        case .corrections:
            "Corrections"
        case .education:
            "Education"
        case .enEspanol:
            "En español"
        case .fashion:
            "Fashion"
        case .food:
            "Food"
        case .gameplay:
            "Gameplay"
        case .guide:
            "Guide"
        case .health:
            "Health"
        case .homeAndGarden:
            "Home & Garden"
        case .homePage:
            "Home Page"
        case .jobMarket:
            "Job Market"
        case .theLearningNetwork:
            "The Learning Network"
        case .lens:
            "Lens"
        case .magazine:
            "Magazine"
        case .movies:
            "Movies"
        case .newYork:
            "New York"
        case .obituaries:
            "Obituaries"
        case .opinion:
            "Opinion"
        case .parenting:
            "Parenting"
        case .podcasts:
            "Podcasts"
        case .readerCenter:
            "Reader Center"
        case .realEstate:
            "Real Estate"
        case .smarterLiving:
            "Smarter Living"
        case .science:
            "Science"
        case .sports:
            "Sports"
        case .style:
            "Style"
        case .sundayReview:
            "Sunday Review"
        case .tBrand:
            "T Brand"
        case .tMagazine:
            "T Magazine"
        case .technology:
            "Technology"
        case .theater:
            "Theater"
        case .timesInsider:
            "Times Insider"
        case .todaysPaper:
            "Today’s Paper"
        case .travel:
            "Travel"
        case .us:
            "U.S."
        case .universal:
            "Universal"
        case .theUpshot:
            "The Upshot"
        case .video:
            "Video"
        case .theWeekly:
            "The Weekly"
        case .well:
            "Well"
        case .world:
            "World"
        case .yourMoney:
            "Your Money"
        }
    }
}
