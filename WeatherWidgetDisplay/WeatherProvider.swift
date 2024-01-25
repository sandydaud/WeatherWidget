//
//  WeatherProvider.swift
//  WeatherWidget
//
//  Created by Daud Sandy Christianto on 18/01/24.
//

import Foundation
import WidgetKit
import Intents
import UIKit

struct WeatherProvider: IntentTimelineProvider {
    let locationsManager = LocationManager()
    let weatherService: WeatherService = WeatherService.shared
    
    func placeholder(in context: Context) -> WeatherEntry {
        WeatherEntry(
            date: Date(),
            configuration: ConfigurationIntent(),
            weather: WeatherResponse.exampleData()
        )
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (WeatherEntry) -> ()) {
        let entry = WeatherEntry(
            date: Date(),
            configuration: configuration,
            weather: WeatherResponse.exampleData(),
            backgroundPhoto: FileManager.readPHAssetImageFromDisk()
        )
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<WeatherEntry>) -> ()) {
        if let isAuthorized = FileManager.readLocationAuthorizationFromDisk(), isAuthorized {
        getWeatherData(
            configuration: configuration,
            completion: completion
        )
        } else {
            updateTimeline(
                configuration: configuration,
                weatherData: WeatherResponse.emptyData(),
                completion: completion
            )
        }
    }
    
    func getWeatherData(
        configuration: ConfigurationIntent,
        completion: @escaping (Timeline<WeatherEntry>) -> ()
    ) {
        let coord = FileManager.readCitiesFromDisk() ?? Coord(lat: 0, lon: 0)
        let latitude = coord.lat
        let longitude = coord.lon
        
        weatherService.getWeatherFromLocation(
            lat: latitude,
            long: longitude,
            onSuccess: { response in
                let iconName = response.weather.first?.icon ?? ""
                
                weatherService.downloadImageFromUrl(iconName: iconName) { image in
                    updateTimeline(
                        configuration: configuration,
                        weatherData: response,
                        weatherImage: image,
                        completion: completion
                    )
                }
            },
            onError: { _ in }
        )
    }
    
    func updateTimeline(
        configuration: ConfigurationIntent,
        weatherData: WeatherResponse,
        weatherImage: UIImage? = nil,
        completion: @escaping (Timeline<WeatherEntry>) -> Void
    ) {
        let currentDate = Date()
        let calendar = Calendar.current
        let refreshDate = calendar.date(byAdding: .minute, value: 1, to: currentDate)!
        let entry = WeatherEntry(
          date: currentDate,
          configuration: configuration,
          weather: weatherData,
          image: weatherImage,
          backgroundPhoto: FileManager.readPHAssetImageFromDisk()
        )
        let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
        completion(timeline)
    }
}
