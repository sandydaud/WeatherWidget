//
//  HomeWeatherViewModelMock.swift
//  WeatherWidgetTests
//
//  Created by Daud Sandy Christianto on 22/01/24.
//

import Foundation
import UIKit

@testable import WeatherWidget

class HomeWeatherViewModelMock: HomeWeatherViewModel {
    // MARK: Mock Variables
    var didCallFetchWeather = false
    var didCallNavigateToPhotoSelection = false

    // MARK: Initializer
    override init(model: HomeWeatherModel) {
        super.init(model: model)
    }

    // MARK: Mock Functions

    // Simulate a successful weather update
    func simulateWeatherUpdate(response: WeatherResponse) {
        model.weatherData = response
        delegate?.updateView()
    }

    // MARK: Overrides

    // Override the fetchWeather function to track its usage
    override func fetchWeather(
        onSuccess: ((WeatherResponse) -> Void)? = nil,
        onError: ((NetworkError) -> Void)? = nil
    ) {
        didCallFetchWeather = true
        super.fetchWeather(onSuccess: onSuccess, onError: onError)
    }

    // Override the navigateToPhotoSelection function to track its usage
    override func navigateToPhotoSelection(vc: UIViewController) {
        didCallNavigateToPhotoSelection = true
        super.navigateToPhotoSelection(vc: vc)
    }
}

