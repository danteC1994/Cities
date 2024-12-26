//
//  CitiesListUITests.swift
//  Cities
//
//  Created by dante canizo on 24/12/2024.
//

import XCTest

final class CitiesListViewUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app.launch()
    }

    func test_citiesListDisplaysCorrectCities() {
        let firstCity = "Hurzuf, UA"
        XCTAssertTrue(app.staticTexts[firstCity].exists)

        let secondCity = "Novinki, RU"
        XCTAssertTrue(app.staticTexts[secondCity].exists)
        
        let thirdCity = "Gorkhā, NP"
        XCTAssertTrue(app.staticTexts[thirdCity].exists)
    }

    func test_selectCity() {
        let cityName = "Gorkhā, NP"
        let cityButton = app.buttons[cityName]
        XCTAssertTrue(cityButton.exists)
        
        
        cityButton.tap()

        let navigationTitle = app.staticTexts["Gorkhā"]

        // Navigated to map view
        XCTAssertTrue(navigationTitle.exists, "Navigation title should exist")
    }

    func test_toggleFavoriteStatus() {
        let firstCityName = "Gorkhā, NP"
        
        let cityRow = app.staticTexts[firstCityName].firstMatch
        
        XCTAssertTrue(cityRow.exists)

        let saveButton = app.buttons["Gorkhā_notSaved"]
        
        XCTAssertTrue(saveButton.exists)
        saveButton.tap()

        XCTAssertTrue(app.buttons["Gorkhā_saved"].exists)
    }
}
