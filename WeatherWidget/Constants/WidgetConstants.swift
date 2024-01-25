//
//  WidgetConstants.swift
//  WeatherWidget
//
//  Created by Daud Sandy Christianto on 11/01/24.
//

import Foundation
import UIKit

enum WidgetSize {
    case small(width: Double, height: Double)
    case medium(width: Double, height: Double)
    case large(width: Double, height: Double)
    
    var size: CGSize {
        switch self {
        case .small(let width, let height),
                .medium(let width, let height),
                .large(let width, let height):
            return CGSize(width: width, height: height)
        }
    }
}

// Creating instances with default values
let WIDTH_SCREEN = UIScreen.main.bounds.size.width
let SMALL_WIDGET_SIZE = WidgetSize.small(width: WIDTH_SCREEN/3, height: WIDTH_SCREEN/3)
let MEDIUM_WIDGET_SIZE = WidgetSize.medium(width: WIDTH_SCREEN*2/3, height: WIDTH_SCREEN/3)
let LARGE_WIDGET_SIZE = WidgetSize.large(width: WIDTH_SCREEN*2/3, height: WIDTH_SCREEN*2/3)

// Cache key
let WEATHER_DATA_KEY = "cachedWeatherData"
let WEATHER_IMAGE_KEY = "cachedWeatherImage"

let LOCATION_PERMISSION_NOT_GIVEN = "Please allow location permission to get the weather data"
let LOCATION_PERMISSION_WARNING_TITLE = "Location Services Disabled"
let LOCATION_PERMISSION_WARNING_MESSAGE = "To enable location services, please go to Settings > Privacy > Location Services and turn on for this app."


