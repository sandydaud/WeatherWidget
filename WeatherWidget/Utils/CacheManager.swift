//
//  CacheManager.swift
//  WeatherWidget
//
//  Created by Daud Sandy Christianto on 16/01/24.
//

import Foundation
import UIKit
import CoreLocation

class CacheManager {
    static let shared = CacheManager()
    private let CACHE_EXPIRATION_TIME: TimeInterval = 60 // 1 minute

    private func saveData(_ data: Data, forKey key: String) {
        let expirationDate = Date().addingTimeInterval(CACHE_EXPIRATION_TIME)
        let cacheData = CachedData(data: data, expirationDate: expirationDate)
        if let encodedData = try? JSONEncoder().encode(cacheData) {
            UserDefaults.standard.set(encodedData, forKey: key)
        }
    }

    private func retrieveData(forKey key: String) -> Data? {
        if let encodedData = UserDefaults.standard.data(forKey: key) {
            if let cacheData = try? JSONDecoder().decode(CachedData.self, from: encodedData) {
                // Check if data has not expired
                if cacheData.expirationDate > Date() {
                    return cacheData.data
                } else {
                    // Data has expired, remove it from cache
                    UserDefaults.standard.removeObject(forKey: key)
                }
            }
        }
        return nil
    }
    
    func deleteData(forKey key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }

    func saveWeatherData(_ data: WeatherResponse) {
        if let encodedData = try? JSONEncoder().encode(data) {
            saveData(encodedData, forKey: WEATHER_DATA_KEY)
        }
    }

    func retrieveWeatherData() -> WeatherResponse? {
        if let encodedData = retrieveData(forKey: WEATHER_DATA_KEY) {
            if let weatherData = try? JSONDecoder().decode(WeatherResponse.self, from: encodedData) {
                return weatherData
            }
        }
        return nil
    }

    func saveWeatherImage(_ data: UIImage) {
        if let imageData = data.pngData() {
            saveData(imageData, forKey: WEATHER_IMAGE_KEY)
        }
    }

    func retrieveWeatherImage() -> UIImage? {
        if let imageData = retrieveData(forKey: WEATHER_IMAGE_KEY) {
            if let image = UIImage(data: imageData) {
                return image
            }
        }
        return nil
    }
}

struct CachedData: Codable {
    let data: Data
    let expirationDate: Date
}
