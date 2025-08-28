//
//  DateView.swift
//  NewsReader
//
//  Created by Muneeb Ahmed Anwar on 28/08/2025.
//

import SwiftUI

struct DateView: View {

    private let formattedDate: String

    init(formattedDate: String) {
        self.formattedDate = formattedDate
    }

    var body: some View {
        HStack {
            Image(systemName: "calendar")

            Text(formattedDate)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    DateView(formattedDate: Date().description)
}
