//
//  ArticleDetailView.swift
//  NewsReader
//
//  Created by Muneeb Ahmed Anwar on 28/08/2025.
//

import SwiftUI

struct ArticleDetailView: View {
    @StateObject var viewModel: ArticleDetailViewModel

    var body: some View {
        ScrollView {
            contentView
        }
        .scrollBounceBehavior(.basedOnSize, axes: [.vertical])
        .navigationTitle(viewModel.article.section)
        .toolbarBackground(.accent, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .sheet(isPresented: $viewModel.showWebView) {
            SafariWebView(url: viewModel.article.url)
                .onDisappear {
                    viewModel.showWebView = false
                }
        }
    }

    @ViewBuilder private var contentView: some View {
        VStack(alignment: .leading, spacing: Constants.contentSpacing) {
            if let url = viewModel.article.heroImageUrl {
                AsyncCachedImage(url: url) {
                    $0.resizable()
                } placeholder: {
                    ProgressView()
                }
                .aspectRatio(Constants.imageAspectRatio, contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: Constants.imageCornerRadius))
            }

            Text(viewModel.article.title)
                .font(.title2)
                .bold()

            HStack(alignment: .top) {
                Text(viewModel.article.byline)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Spacer(minLength: 8.0)

                DateView(formattedDate: viewModel.article.publishedDate)
            }

            if !viewModel.article.abstract.isEmpty {
                Text(viewModel.article.abstract)
                    .font(.body)
            }

            Button {
                viewModel.showWebView = true
            } label: {
                Label("Read more at NYTimes...", systemImage: "safari")
                    .tint(Color.blue)
            }

        }
        .padding()
    }

    private enum Constants {
        static let contentSpacing: CGFloat = 12.0
        static let imageAspectRatio: CGFloat = 3.0/2.0
        static let imageCornerRadius: CGFloat = 12.0
    }
}
