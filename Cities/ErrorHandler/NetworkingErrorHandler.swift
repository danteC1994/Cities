//
//  ErrorHandler.swift
//  Cities
//
//  Created by dante canizo on 19/12/2024.
//

import Networking

protocol NetworkingErrorHandler {
    func handle(error: APIError) -> UIError
}
