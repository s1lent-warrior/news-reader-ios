//
//  ArticlesListView.swift
//  NewsReader
//
//  Created by Muneeb Ahmed Anwar on 28/08/2025.
//

import SwiftUI

struct ArticlesListView: View {

    @StateObject var viewModel: ArticlesListViewModel

    var body: some View {
        contentView
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        selectSectionMenu

                        Text(viewModel.title)
                            .font(.headline)
                            .foregroundColor(.white)

                        Spacer()

                        toolbarTrailingItems
                    }
                }
            }
            .refreshable {
                viewModel.refresh()
            }
            .searchable(
                text: $viewModel.searchText,
                isPresented: $viewModel.showSearchBar
            )
            .onChange(of: viewModel.searchText) { (_, newText) in
                viewModel.updateLoadingState()
                if newText.isEmpty {
                    viewModel.showSearchBar = false
                }
            }
            .onAppear {
                if viewModel.state == .idle  {
                    viewModel.refresh()
                }
            }
    }

    @ViewBuilder private var contentView: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        case let .failed(message):
            ErrorView(message: message) {
                viewModel.refresh()
            }

        case .empty:
            ContentUnavailableView(Constants.noDataText, systemImage: Constants.noDataIcon)

        case .loaded:
            listView
        }

    }

    private var listView: some View {
        List(viewModel.filteredArticles) { article in
            NavigationLink(value: article) {
                ArticleListItemView(article: article)
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(.clear)
        .padding(.zero)
        .navigationDestination(for: Article.self) {
            ArticleDetailView(viewModel: .init(article: $0))
        }
    }

    private var toolbarTrailingItems: some View {
        HStack {
            Button {
                viewModel.showSearchBar = true
            } label: {
                Image(systemName: Constants.searchIcon)
                    .tint(.white)
            }

            selectPeriodMenu
        }
    }

    private var selectPeriodMenu: some View {
        Menu {
            Picker("Select Period", selection: $viewModel.period) {
                ForEach(NewsPeriod.allCases, id: \.self) { item in
                    Text(item.title).tag(item.rawValue)
                }
            }
        } label: {
            Image(systemName: Constants.rightMenuIcon)
                .rotationEffect(.degrees(Constants.rightMenuIconRotation))
                .tint(.white)
        }
    }

    private var selectSectionMenu: some View {
        Menu {
            Picker("Choose Section", selection: $viewModel.section) {
                ForEach(NewsSection.allCases, id: \.self) { item in
                    Text(item.title).tag(item.rawValue)
                }
            }
        } label: {
            Image(systemName: Constants.leftMenuIcon)
                .tint(.white)
        }
    }


    private enum Constants {
        static let noDataIcon: String = "newspaper"
        static let noDataText: String = "No articles"

        static let searchIcon: String = "magnifyingglass"
        static let rightMenuIcon: String = "ellipsis"
        static let rightMenuIconRotation: CGFloat = 90.0

        static let leftMenuIcon: String = "line.3.horizontal"
    }
}

//#Preview {
//    ArticlesListView(viewModel: .init(title: "Most Viewed"))
//}
