//
//  Router.swift
//  Cities
//
//  Created by dante canizo on 17/12/2024.
//

import Networking
import SwiftUI

enum Route {
    case citiesListNavigation(selectedCity: City?, _ onSelectedCity: ((City?) -> Void))
    case citiesList(selectedCity: City?, _ onSelectedCity: ((City?) -> Void))
    case map(city: City?)
}

class Router: ObservableObject {
    private var viewFactory: ViewFactory
    @Published var navigationStack: [Route] = []

    init(viewFactory: ViewFactory) {
        self.viewFactory = viewFactory
    }

    func push(route: Route) -> some View {
        return viewFactory.createView(for: route)
    }

    func pop() {
        if !navigationStack.isEmpty {
            navigationStack.removeLast()
        }
    }
}
