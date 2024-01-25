//
//  LocationManagerMock.swift
//  WeatherWidgetTests
//
//  Created by Daud Sandy Christianto on 22/01/24.
//

import CoreLocation
@testable import WeatherWidget

class LocationManagerMock: LocationManager {
    var didCallFetchLocation = false
    
    override func fetchLocation(handler: @escaping (CLLocation) -> Void) {
        didCallFetchLocation = true
        // Simulate location fetching by calling the completion with a mock location
        let mockLocation = CLLocation(latitude: 12.34, longitude: 56.78)
        handler(mockLocation)
    }
}
