//
//  Untitled.swift
//  Cities
//
//  Created by dante canizo on 19/12/2024.
//

import Networking

final class GenericErrorHandler: ErrorHandler {
    func handle(error: APIError) -> UIError {
        switch error {
        case .invalidURL, .decodingError, .encodingError, .unknownError:
                .nonRecoverableError(
                    title: "Oops! Something went wrong.",
                    description: "It seems we are having technical difficulties, try again later",
                    actionTitle: "Go back"
                )
        case let .networkError(description):
                .recoverableError(
                    title: "Oops! Something went wrong.",
                    description: description,
                    actionTitle: "Try again"
                )
        }
    }
}
