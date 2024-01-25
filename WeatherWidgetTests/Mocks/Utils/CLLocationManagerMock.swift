//
//  CLLocationManagerMock.swift
//  WeatherWidgetTests
//
//  Created by Daud Sandy Christianto on 23/01/24.
//

import CoreLocation
@testable import WeatherWidget

class CLLocationManagerMock: CLLocationManager {
    private var mockAuthorizationStatus: CLAuthorizationStatus = .authorizedWhenInUse
    private(set) var isUpdatingLocation = false
    var handler: ((CLLocation) -> Void)?

    override var authorizationStatus: CLAuthorizationStatus {
        return mockAuthorizationStatus
    }

    func setAuthorizationStatus(_ status: CLAuthorizationStatus) {
        mockAuthorizationStatus = status
        self.delegate?.locationManagerDidChangeAuthorization?(self)
    }

    override var delegate: CLLocationManagerDelegate? {
        didSet {
            self.delegate?.locationManagerDidChangeAuthorization?(self)
        }
    }

    override func requestWhenInUseAuthorization() {
        self.delegate?.locationManagerDidChangeAuthorization?(self)
    }

    override func startUpdatingLocation() {
        isUpdatingLocation = true
    }

    override func stopUpdatingLocation() {
        isUpdatingLocation = false
    }

    private let mockLocation: CLLocation

    init(mockLocation: CLLocation) {
        self.mockLocation = mockLocation
        super.init()
    }

    override func requestLocation() {
        // Simulate a location update with the predefined coordinates
        self.handler?(mockLocation)
    }
}

