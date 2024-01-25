//
//  WeatherServiceMock.swift
//  WeatherWidgetTests
//
//  Created by Daud Sandy Christianto on 22/01/24.
//

import UIKit
@testable import WeatherWidget

class WeatherServiceMock: WeatherServiceProtocol {
    
    var stubbedGetWeatherFromLocationCompletionResult: (WeatherResponse?, NetworkError?) = (nil, nil)
    var stubbedDownloadImageFromUrlCompletionResult: UIImage? = nil
    
    var didCallGetWeatherFromLocation = false
    var didCallDownloadImageFromUrl = false
    
    func getWeatherFromLocation(lat: Double, long: Double, onSuccess: @escaping (WeatherResponse) -> Void, onError: @escaping (NetworkError) -> Void) {
        didCallGetWeatherFromLocation = true
        if let result = stubbedGetWeatherFromLocationCompletionResult.0 {
            onSuccess(result)
        } else if let error = stubbedGetWeatherFromLocationCompletionResult.1 {
            onError(error)
        }
    }
    
    func downloadImageFromUrl(iconName: String, completion: @escaping (UIImage?) -> Void) {
        didCallDownloadImageFromUrl = true
        completion(stubbedDownloadImageFromUrlCompletionResult)
    }
}
