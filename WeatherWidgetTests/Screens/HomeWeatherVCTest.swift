//
//  HomeWeatherVCTest.swift
//  WeatherWidgetTests
//
//  Created by Daud Sandy Christianto on 22/01/24.
//

import XCTest
@testable import WeatherWidget

class HomeWeatherVCTests: XCTestCase {

    var viewController: HomeWeatherVC!
    var viewModelMock: HomeWeatherViewModelMock!

    override func setUp() {
        super.setUp()
        viewController = HomeWeatherVC()
        viewModelMock = HomeWeatherViewModelMock(model: HomeWeatherModel())
        viewController.viewModel = viewModelMock
    }

    override func tearDown() {
        viewController = nil
        viewModelMock = nil
        super.tearDown()
    }

    // MARK: - Helper Functions
    
    // Simulate a weather response for testing
    func simulateWeatherUpdate() {
        let weatherResponse = WeatherResponse.exampleData()
        viewModelMock.simulateWeatherUpdate(response: weatherResponse)
    }

    // MARK: - Unit Tests

    func testRefreshAction() {
        // Set up expectation
        let expectation = XCTestExpectation(description: "Refresh action expectation")

        // Set up delegate
        viewModelMock.delegate = viewController

        // Execute the action
        viewController.refreshAction(UIBarButtonItem())

        // Fulfill the expectation after a short delay (simulating network response)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            expectation.fulfill()
        }

        // Wait for the expectation to be fulfilled
        wait(for: [expectation], timeout: 2.0)

        // Assert that the delegate method is called and collectionView is reloaded
        XCTAssertTrue(viewModelMock.didCallFetchWeather)
    }

    func testChangeBackgroundAction() {
        // Set up expectation
        let expectation = XCTestExpectation(description: "Change background action expectation")

        // Set up delegate
        viewModelMock.delegate = viewController

        // Execute the action
        viewController.changeBackground()

        // Fulfill the expectation after a short delay (simulating navigation)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            expectation.fulfill()
        }

        // Wait for the expectation to be fulfilled
        wait(for: [expectation], timeout: 2.0)

        // Assert that the navigation action is triggered
        XCTAssertTrue(viewModelMock.didCallNavigateToPhotoSelection)
    }
}

