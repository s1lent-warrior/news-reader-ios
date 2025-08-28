//
//  NewsReaderApp.swift
//  NewsReader
//
//  Created by Muneeb Ahmed Anwar on 27/08/2025.
//

import SwiftUI

@main
struct NewsReaderApp: App {
    @StateObject private var appEnvironment = AppEnvironment.bootstrap()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ArticlesListView(
                    viewModel: ArticlesListViewModel(
                        title: "NY Times Most Popular",
                        repository: appEnvironment.newsRepository
                    )
                )
                .toolbarTitleDisplayMode(.inline)
                .toolbarBackground(.accent, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarColorScheme(.dark, for: .navigationBar)
            }
            .environmentObject(appEnvironment)
        }
    }
}
