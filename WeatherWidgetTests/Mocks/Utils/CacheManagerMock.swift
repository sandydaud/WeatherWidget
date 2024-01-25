//
//  CacheManagerMock.swift
//  WeatherWidgetTests
//
//  Created by Daud Sandy Christianto on 22/01/24.
//

import UIKit
@testable import WeatherWidget

class CacheManagerMock: CacheManager {
    var stubbedRetrieveWeatherData: WeatherResponse? = nil
    var stubbedRetrieveWeatherImage: UIImage? = nil
    
    var didCallRetrieveWeatherData = false
    var didCallRetrieveWeatherImage = false
    var didCallSaveWeatherData = false
    var didCallSaveWeatherImage = false
    var didCallDeleteDataForKey = false
    
    override func retrieveWeatherData() -> WeatherResponse? {
        didCallRetrieveWeatherData = true
        return stubbedRetrieveWeatherData
    }
    
    override func retrieveWeatherImage() -> UIImage? {
        didCallRetrieveWeatherImage = true
        return stubbedRetrieveWeatherImage
    }
    
    override func saveWeatherData(_ data: WeatherResponse) {
        didCallSaveWeatherData = true
    }
    
    override func saveWeatherImage(_ data: UIImage) {
        didCallSaveWeatherImage = true
    }
    
    override func deleteData(forKey key: String) {
        didCallDeleteDataForKey = true
    }
}
