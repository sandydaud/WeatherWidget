//
//  HomeWeatherViewModelTest.swift
//  WeatherWidgetTests
//
//  Created by Daud Sandy Christianto on 21/01/24.
//

import XCTest
import Photos
@testable import WeatherWidget

class HomeWeatherViewModelTests: XCTestCase {
    
    var viewModel: HomeWeatherViewModel!
    let model = HomeWeatherModel()
    let weatherServiceMock = WeatherServiceMock()
    let cacheManagerMock = CacheManagerMock()
    let locationManagerMock = LocationManagerMock()
    let clLocationManagerMock = CLLocationManagerMock(
        mockLocation:  CLLocation(latitude: 37.7749, longitude: -122.4194)
    )
    let delegation = HomeWeatherViewModelDelegateMock()
    
    override func setUp() {
        super.setUp()
        locationManagerMock.locManager = clLocationManagerMock
        
        viewModel = HomeWeatherViewModel(model: model)
        viewModel.weatherService = weatherServiceMock
        viewModel.cacheManager = cacheManagerMock
        viewModel.locationManager = locationManagerMock
        viewModel.delegate = delegation
    }
    
    // MARK: - Test Location
    
    func testSetupLocationAndWeather() {
        viewModel.setupLocationAndWeather()
        
        // Verify that fetchLocation is called
        XCTAssert(locationManagerMock.didCallFetchLocation)
    }
    
    func testLocationsDidChange() {
        let location = Coord(lat: 12.34, lon: 56.78)
        viewModel.locationsDidChange(location: location)
        
        // Verify that model's latitude and longitude are updated
        XCTAssertEqual(viewModel.model.latitude, location.lat)
        XCTAssertEqual(viewModel.model.longitude, location.lon)
        
        // Verify that fetchWeather is called
        XCTAssert(weatherServiceMock.didCallGetWeatherFromLocation)
    }
    
    // MARK: - Test Weather
    
    func testFetchWeatherWithCachedData() {
        let cachedWeatherData = WeatherResponse.exampleData()
        let cachedWeatherImage = UIImage(named: "SunBehindCloud")
        cacheManagerMock.stubbedRetrieveWeatherData = cachedWeatherData
        cacheManagerMock.stubbedRetrieveWeatherImage = cachedWeatherImage

        viewModel.fetchWeather()

        // Verify that cached data is used
        XCTAssertEqual(viewModel.model.weatherData, cachedWeatherData)
        XCTAssertEqual(viewModel.model.weatherImage, cachedWeatherImage)
    }

    func testFetchWeatherWithoutCachedData() {
        let location = Coord(lat: 12.34, lon: 56.78)
        model.latitude = location.lat
        model.longitude = location.lon
        
        let expectedWeatherData = WeatherResponse.exampleData()
        let expectedWeatherImage = UIImage(named: "SunBehindCloud")
        weatherServiceMock.stubbedGetWeatherFromLocationCompletionResult = (expectedWeatherData, nil)
        weatherServiceMock.stubbedDownloadImageFromUrlCompletionResult = expectedWeatherImage

        viewModel.fetchWeather()

        // Verify that weather data is fetched and cached
        XCTAssertEqual(viewModel.model.weatherData, expectedWeatherData)
        XCTAssertEqual(viewModel.model.weatherImage, expectedWeatherImage)
        XCTAssert(cacheManagerMock.didCallSaveWeatherData)
        XCTAssert(cacheManagerMock.didCallSaveWeatherImage)
    }

    func testFetchWeatherWithError() {
        var errorResult: Error?
        let expectedError = NetworkError.authenticationError
        weatherServiceMock.stubbedGetWeatherFromLocationCompletionResult = (nil, expectedError)
        
        viewModel.fetchWeather(onError: { error in
            errorResult = error
        })

        // Verify that onError block is called
        XCTAssert(errorResult != nil)
    }
    
    // MARK: - Test Navigation
    func testNavigateToPhotoSelection() {
        let viewControllerMock = UIViewControllerMock()
        
        viewModel.navigateToPhotoSelection(vc: viewControllerMock)
        
        XCTAssertNotNil(viewControllerMock.presentedVC)
    }
    
    func testRemoveBackground() {
        viewModel.removeBackground()

        // Verify that removePHAssetImageFromDisk is called
        XCTAssert(FileManager.readPHAssetImageFromDisk() == nil)
    }

    // MARK: - Test Delegate Methods
    func testUpdatePhoto() {
        let selectedPhoto = PHAsset()
        
        viewModel.updatePhoto(with: selectedPhoto)

        XCTAssertEqual(viewModel.model.selectedPhoto, selectedPhoto)

        // Verify that updateView is called on the delegate
        XCTAssert(delegation.didCallUpdateView == true)
    }
    
    func testRequestLocationPermission_Success() {
        // Arrange
        clLocationManagerMock.setAuthorizationStatus(.authorizedWhenInUse)
        
        // Act
        let expectation = XCTestExpectation(description: "Location permission request completed")
        viewModel.requestLocationPermission { isPermissionGiven in
            // Assert
            XCTAssertTrue(isPermissionGiven)
            expectation.fulfill()
        }
    }
    
    func testRequestLocationPermission_Failure() {
        // Arrange
        clLocationManagerMock.setAuthorizationStatus(.denied)
        
        // Act
        let expectation = XCTestExpectation(description: "Location permission request completed")
        viewModel.requestLocationPermission { isPermissionGiven in
            // Assert
            XCTAssertFalse(isPermissionGiven)
            expectation.fulfill()
        }
    }
}

class HomeWeatherViewModelDelegateMock: HomeWeatherViewModelDelegate {
    var didCallUpdateView = false
    
    func updateView() {
        didCallUpdateView = true
    }
}
