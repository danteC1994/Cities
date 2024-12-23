//
//  DatabaseErrorHandler.swift
//  Cities
//
//  Created by dante canizo on 21/12/2024.
//

protocol DatabaseErrorHandler {
    func handle(error: DatabaseError) -> UIInformativeError
}
