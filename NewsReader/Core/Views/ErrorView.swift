//
//  ErrorView.swift
//  NewsReader
//
//  Created by Muneeb Ahmed Anwar on 28/08/2025.
//

import SwiftUI

struct ErrorView: View {
    private let title: String
    private let message: String
    private let actionTitle: String
    private let action: (() -> Void)

    init(
        title: String = "Couldn’t load articles due to Error",
        message: String,
        actionTitle: String = "Retry",
        action: @escaping () -> Void
    ) {
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.action = action
    }

    var body: some View {
        VStack {
            Text(title)
            Text(message)
            Button(actionTitle) {
                action()
            }
        }
        .padding()
    }
}

