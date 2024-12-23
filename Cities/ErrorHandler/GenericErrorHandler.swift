//
//  Untitled.swift
//  Cities
//
//  Created by dante canizo on 19/12/2024.
//

import Networking

final class GenericErrorHandler { }

extension GenericErrorHandler: NetworkingErrorHandler {
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

extension GenericErrorHandler: DatabaseErrorHandler {
    func handle(error: DatabaseError) -> UIInformativeError {
        switch error {
        case .query:
                .informativeError(message: "Couldn't find element")
        case .save:
                .informativeError(message: "Couldn't save element")
        case .unknownError:
                .informativeError(message: "Oops! Something went wrong.")
        }
    }
}
