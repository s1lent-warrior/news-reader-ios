//
//  ArticleListItemView.swift
//  NewsReader
//
//  Created by Muneeb Ahmed Anwar on 28/08/2025.
//

import SwiftUI

struct ArticleListItemView: View {
    let article: Article

    var body: some View {
        HStack(alignment: .center, spacing: Constants.contentSpacing) {
            AsyncCachedImage(url: article.heroImageUrl) { image in
                image.resizable().aspectRatio(1.0, contentMode: .fill)
            } placeholder: {
                Circle().overlay {
                    Image(systemName: Constants.imagePlaceholder)
                }
            }
            .frame(width: Constants.imageSize, height: Constants.imageSize)
            .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4.0) {
                Text(article.title)
                    .font(.headline)
                    .lineLimit(Constants.titleNumberOfLines)

                Text(article.byline)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                DateView(formattedDate: article.publishedDate)
            }
        }
        .background(.clear)
    }

    private enum Constants {
        static let contentSpacing: CGFloat = 12.0
        static let imageSize: CGFloat = 48.0
        static let titleNumberOfLines: Int = 2
        static let imagePlaceholder: String = "photo"
    }
}
