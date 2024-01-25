//
//  LocationManagerTest.swift
//  WeatherWidgetTests
//
//  Created by Daud Sandy Christianto on 23/01/24.
//

import XCTest
import CoreLocation
@testable import WeatherWidget

class LocationManagerTests: XCTestCase {
    let mockLocation = CLLocation(latitude: 37.7749, longitude: -122.4194)
    var locationManager: LocationManager!
    var clLocationManagerMock: CLLocationManagerMock!
    var mockDelegate: MockLocationManagerDelegate!
    
    override func setUp() {
        super.setUp()
        clLocationManagerMock = CLLocationManagerMock(mockLocation: mockLocation)
        locationManager = LocationManager()
        locationManager.locManager = clLocationManagerMock
        mockDelegate = MockLocationManagerDelegate()
        locationManager.delegate = mockDelegate
    }
    
    func testFetchLocation() {
        let expectation = XCTestExpectation(description: "Location fetched successfully")
        
        // Inject the mock location manager with the predefined location
        locationManager.locManager = clLocationManagerMock
        clLocationManagerMock.handler = { _ in }
        
        // Perform the location fetch
        locationManager.fetchLocation { location in
            // Verify that the handler is called with the correct location
            XCTAssertNotNil(location.coordinate)
            expectation.fulfill()
        }
        
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testAuthorizationStatusChange() {
        locationManager.locationManagerDidChangeAuthorization(clLocationManagerMock)
        
        // Verify that the location manager starts updating location when authorized
        XCTAssertTrue(clLocationManagerMock.isUpdatingLocation)
        
        // Simulate changing authorization status to denied
        clLocationManagerMock.setAuthorizationStatus(.denied)
        locationManager.locationManagerDidChangeAuthorization(clLocationManagerMock)
        
        // Verify that the location manager stops updating location when denied
        XCTAssertFalse(clLocationManagerMock.isUpdatingLocation)
    }
    
    func testRequestLocationPermissionIfNeeded_NotDetermined() {
        // Arrange
        clLocationManagerMock.setAuthorizationStatus(.notDetermined)
        
        // Act
        let expectation = XCTestExpectation(description: "Location permission request completed")
        locationManager.requestLocationPermissionIfNeeded { isPermissionGiven in
            // Assert
            XCTAssertTrue(isPermissionGiven)
            expectation.fulfill()
        }
        
        // Wait for the expectation to be fulfilled (timeout: 5 seconds)
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testRequestLocationPermissionIfNeeded_Denied() {
        // Arrange
        clLocationManagerMock.setAuthorizationStatus(.denied)
        
        // Act
        let expectation = XCTestExpectation(description: "Location permission request completed")
        locationManager.requestLocationPermissionIfNeeded { isPermissionGiven in
            // Assert
            XCTAssertFalse(isPermissionGiven)
            XCTAssertTrue(self.mockDelegate.locationPermissionAlertShown)
            expectation.fulfill()
        }
        
        // Wait for the expectation to be fulfilled (timeout: 5 seconds)
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testRequestLocationPermissionIfNeeded_Restricted() {
        // Arrange
        clLocationManagerMock.setAuthorizationStatus(.restricted)
        
        // Act
        let expectation = XCTestExpectation(description: "Location permission request completed")
        locationManager.requestLocationPermissionIfNeeded { isPermissionGiven in
            // Assert
            XCTAssertFalse(isPermissionGiven)
            XCTAssertTrue(self.mockDelegate.locationPermissionAlertShown)
            expectation.fulfill()
        }
        
        // Wait for the expectation to be fulfilled (timeout: 5 seconds)
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testRequestLocationPermissionIfNeeded_AlreadyAuthorized() {
        // Arrange
        clLocationManagerMock.setAuthorizationStatus(.authorizedWhenInUse)
        
        // Act
        let expectation = XCTestExpectation(description: "Location permission request completed")
        locationManager.requestLocationPermissionIfNeeded { isPermissionGiven in
            // Assert
            XCTAssertTrue(isPermissionGiven)
            XCTAssertFalse(self.mockDelegate.locationPermissionAlertShown)
            expectation.fulfill()
        }
        
        // Wait for the expectation to be fulfilled (timeout: 5 seconds)
        wait(for: [expectation], timeout: 5.0)
    }
}

