//
//  HomeWeatherViewModel.swift
//  WeatherWidget
//
//  Created by Daud Sandy Christianto on 11/01/24.
//

import Foundation
import CoreLocation
import WidgetKit
import UIKit
import Photos

class HomeWeatherViewModel: NSObject {
    var model: HomeWeatherModel
    
    var weatherService: WeatherServiceProtocol = WeatherService.shared
    var cacheManager: CacheManager = .shared
    var locationManager = LocationManager()
    
    weak var delegate: HomeWeatherViewModelDelegate?
    
    init(model: HomeWeatherModel) {
        self.model = model
        super.init()
        locationManager.delegate = self
        setupLocationAndWeather()
    }
    
    // MARK: Location
    func setupLocationAndWeather() {
        locationManager.fetchLocation { [weak self] locationResult in
            let latitude = locationResult.coordinate.latitude
            let longitude = locationResult.coordinate.longitude
            let coord = Coord(
                lat: latitude,
                lon: longitude
            )
            
            guard let ws = self,  !ws.isLocationSame(newLoc: coord) else { return }
            ws.model.latitude = latitude
            ws.model.longitude = longitude
            ws.fetchWeather()
        }
    }
    
    func requestLocationPermission(completion: @escaping (Bool)-> Void) {
        locationManager.requestLocationPermissionIfNeeded { [weak self] isPermissionGiven in
            guard let ws = self else { return }
            if isPermissionGiven {
                ws.fetchWeather()
            } else {
                ws.model.errorText = LOCATION_PERMISSION_NOT_GIVEN
            }
            completion(isPermissionGiven)
        }
    }
    
    // MARK: Weather
    func fetchWeather(
        onSuccess: ((WeatherResponse) -> Void)? = nil,
        onError: ((NetworkError) -> Void)? = nil
    ) {
        // Check if cached data is available
        if let cachedWeatherData = cacheManager.retrieveWeatherData(),
           let cachedWeatherImage = cacheManager.retrieveWeatherImage() {
            model.weatherData = cachedWeatherData
            model.weatherImage = cachedWeatherImage
            updateView()
            onSuccess?(cachedWeatherData)
            return
        }
        
        // If no cached data, fetch from the weather service
        guard let latitude = model.latitude, let longitude = model.longitude else {
            onError?(NetworkError.parametersNil)
            return
        }
        
        model.isLoading = true
        updateView()
        
        weatherService.getWeatherFromLocation(
            lat: latitude,
            long: longitude,
            onSuccess: { [weak self] response in
                guard let ws = self else { return }
                ws.model.errorText = ""
                ws.cacheManager.saveWeatherData(response)
                ws.model.weatherData = response
                ws.fetchWeatherImage()
                ws.model.isLoading = false
                onSuccess?(response)
            },
            onError: { [weak self] errorResponse in
                guard let ws = self else { return }
                ws.model.isLoading = false
                ws.model.errorText = errorResponse.localizedDescription
                ws.updateView()
                onError?(errorResponse)
            }
        )
    }
    
    private func fetchWeatherImage() {
        guard let iconName = model.weatherData?.weather.first?.icon else { return }
        weatherService.downloadImageFromUrl(iconName: iconName) { [weak self] imageData in
            guard let ws = self, let imageData = imageData else { return }
            ws.model.weatherImage = imageData
            ws.cacheManager.saveWeatherImage(imageData)
            ws.updateView()
        }
    }
    
    private func updateView() {
        DispatchQueue.main.async {
            self.delegate?.updateView()
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    // MARK : Navigation
    func navigateToPhotoSelection(vc: UIViewController) {
        let photoSelectionVC = PhotoSelectionVC()
        let photoSelectionViewModel = PhotoSelectionViewModel(model: PhotoSelectionModel(), selectedPhoto: model.selectedPhoto)
        photoSelectionVC.viewModel = photoSelectionViewModel
        photoSelectionVC.viewModel?.delegate = self
        
        let nav = UINavigationController(rootViewController: photoSelectionVC)
        nav.modalPresentationStyle = .pageSheet
        nav.modalTransitionStyle = .coverVertical
        
        vc.present(nav, animated: true, completion: nil)
    }
    
    func removeBackground() {
        FileManager.removePHAssetImageFromDisk()
        delegate?.updateView()
    }
    
    func isLocationSame(newLoc: Coord) -> Bool {
        let latitude = model.latitude
        let longitude = model.longitude
        return newLoc.lat == latitude && newLoc.lon == longitude
    }
}

extension HomeWeatherViewModel: LocationManagerDelegate {
    func locationsDidChange(location: Coord) {
        guard !isLocationSame(newLoc: location) else { return }
        model.latitude = location.lat
        model.longitude = location.lon
        fetchWeather()
    }
    
    func showLocationPermissionAlert(withTitle title: String, message: String) {
        // Use UIAlertController to display a message to the user
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        // Present the alert on the topmost view controller
        if let topViewController = UIApplication.shared.windows.first?.rootViewController {
            topViewController.present(alertController, animated: true, completion: nil)
        }
    }
}

extension HomeWeatherViewModel: PhotoSelectionViewModelDelegate {
    func updatePhoto(with selectedPhoto: PHAsset) {
        model.selectedPhoto = selectedPhoto
        delegate?.updateView()
    }
}


