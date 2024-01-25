//
//  WeatherServiceProtocol.swift
//  WeatherWidget
//
//  Created by Daud Sandy Christianto on 10/01/24.
//

import Foundation
import CoreLocation
import UIKit

protocol WeatherServiceProtocol {
    func getWeatherFromLocation(
        lat: Double,
        long: Double,
        onSuccess: @escaping (WeatherResponse) -> Void,
        onError: @escaping (NetworkError) -> Void
    )
    func downloadImageFromUrl(iconName: String, completion: @escaping (UIImage?) -> Void)
}
