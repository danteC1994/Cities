//
//  GenericErrorView.swift
//  Cities
//
//  Created by dante canizo on 19/12/2024.
//

import SwiftUI

struct GenericErrorView: View {
    let title: String
    let description: String
    let actionTitle: String
    let action: () -> Void

    var body: some View {
        VStack {
            Image(systemName: "xmark.octagon.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(.red)
                .frame(width: 100, height: 100)
                .padding()
            Button(action: {
                Task {
                    action()
                }
            }) {
                Text(actionTitle)
                    .bold()
                    .padding(.bottom)
            }
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
    }
}

#Preview {
    GenericErrorView(
        title: "Oops! Something went wrong.",
        description: "It seems we are having technical difficulties, try again later",
        actionTitle: "Go back",
        action: {}
    )
}
