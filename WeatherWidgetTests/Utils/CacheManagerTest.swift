//
//  CacheManagerTest.swift
//  WeatherWidgetTests
//
//  Created by Daud Sandy Christianto on 23/01/24.
//

import XCTest
@testable import WeatherWidget

class CacheManagerTests: XCTestCase {

    let testWeatherData = WeatherResponse.exampleData()
    let testWeatherImage = UIImage(named: "SunBehindCloud")!

    func testSaveAndRetrieveWeatherData() {
        // Save data to cache
        CacheManager.shared.saveWeatherData(testWeatherData)

        // Retrieve data from cache
        let retrievedWeatherData = CacheManager.shared.retrieveWeatherData()

        XCTAssertEqual(testWeatherData, retrievedWeatherData)
    }

    func testSaveAndRetrieveWeatherImage() {
        // Save image to cache
        CacheManager.shared.saveWeatherImage(testWeatherImage)

        // Retrieve image from cache
        let retrievedWeatherImage = CacheManager.shared.retrieveWeatherImage()

        // Compare the sizes of PNG data with a tolerance
        if let testImageData = testWeatherImage.pngData(),
           let retrievedImageData = retrievedWeatherImage?.pngData() {
            XCTAssertEqual(testImageData.count, retrievedImageData.count, accuracy: 100) // Adjust the accuracy as needed
        } else {
            XCTFail("Failed to get PNG data for comparison.")
        }
    }

    func testDeleteData() {
        // Save data to cache
        CacheManager.shared.saveWeatherData(testWeatherData)

        // Delete data from cache
        CacheManager.shared.deleteData(forKey: WEATHER_DATA_KEY)

        // Attempt to retrieve data from cache after deletion
        let retrievedWeatherData = CacheManager.shared.retrieveWeatherData()

        XCTAssertNil(retrievedWeatherData)
    }
}

