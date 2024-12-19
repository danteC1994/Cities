//
//  UIError.swift
//  Cities
//
//  Created by dante canizo on 19/12/2024.
//

enum UIError: Error {
    case recoverableError(title: String, description: String, actionTitle: String)
    case nonRecoverableError(title: String, description: String, actionTitle: String)
}
