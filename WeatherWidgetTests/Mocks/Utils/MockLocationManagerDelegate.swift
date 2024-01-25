//
//  MockLocationManagerDelegate.swift
//  WeatherWidgetTests
//
//  Created by Daud Sandy Christianto on 23/01/24.
//

@testable import WeatherWidget

class MockLocationManagerDelegate: LocationManagerDelegate {
    func locationsDidChange(location: Coord) {
        
    }
    
    var locationPermissionAlertShown = false

    func showLocationPermissionAlert(withTitle title: String, message: String) {
        locationPermissionAlertShown = true
    }
}
