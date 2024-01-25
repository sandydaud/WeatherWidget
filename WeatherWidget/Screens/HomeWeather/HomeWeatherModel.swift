//
//  HomeWeatherModel.swift
//  WeatherWidget
//
//  Created by Daud Sandy Christianto on 11/01/24.
//

import Foundation
import CoreLocation
import UIKit
import Photos

class HomeWeatherModel {
    var latitude: Double?
    var longitude: Double?
    var weatherData: WeatherResponse?
    var weatherImage: UIImage?
    var selectedPhoto: PHAsset?
    var errorText: String = ""
    var isLoading: Bool = false
}
