//
//  LocationManager.swift
//  WeatherWidget
//
//  Created by Daud Sandy Christianto on 18/01/24.
//

import Foundation
import CoreLocation
import WidgetKit
import UIKit

protocol LocationManagerDelegate: AnyObject {
    func locationsDidChange(location: Coord)
    func showLocationPermissionAlert(withTitle title: String, message: String)
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    var locManager: CLLocationManager?
    weak var delegate: LocationManagerDelegate?
    private var handler: ((CLLocation) -> Void)?
    
    var cacheManager: CacheManager = .shared

    override init() {
        super.init()
        DispatchQueue.main.async {
            self.locManager = CLLocationManager()
            self.locManager?.delegate = self
            self.locManager?.desiredAccuracy = kCLLocationAccuracyBest
            
            if self.locManager?.authorizationStatus == .notDetermined {
                self.locManager?.requestWhenInUseAuthorization()
            }
        }
    }
    
    func fetchLocation(handler: @escaping (CLLocation) -> Void) {
        self.handler = handler
        self.locManager?.requestLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .notDetermined || manager.authorizationStatus == .denied ||
            manager.authorizationStatus == .restricted {
            locManager?.stopUpdatingLocation()
            locManager?.stopMonitoringSignificantLocationChanges()
        }

        if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse {
            locManager?.startUpdatingLocation()
            locManager?.startMonitoringSignificantLocationChanges()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            self.locManager?.startUpdatingLocation()
            FileManager.writeLocationAuthorizationToDisk(isAuthorized: true)
        } else {
            FileManager.writeLocationAuthorizationToDisk(isAuthorized: false)
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            let coord = Coord(lat: lat, lon: lon)
            
            cacheManager.deleteData(forKey: WEATHER_DATA_KEY)
            cacheManager.deleteData(forKey: WEATHER_IMAGE_KEY)
            
            handler?(location)
            delegate?.locationsDidChange(location: coord)
            FileManager.writeCitiesToDisk(location: coord)
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func requestLocationPermissionIfNeeded(completion: @escaping (Bool) -> Void) {
        if CLLocationManager.locationServicesEnabled() {
            switch locManager?.authorizationStatus {
            case .notDetermined:
                locManager?.requestWhenInUseAuthorization()
                completion(true)
            case .denied, .restricted:
                delegate?.showLocationPermissionAlert(
                    withTitle: LOCATION_PERMISSION_WARNING_TITLE,
                    message: LOCATION_PERMISSION_WARNING_MESSAGE
                )
                completion(false)
            case .authorizedAlways, .authorizedWhenInUse:
                completion(true)
            default:
                completion(false)
            }
        } else {
            completion(false)
        }
    }
}
