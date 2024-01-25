//
//  Weather.swift
//  WeatherWidget
//
//  Created by Daud Sandy Christianto on 10/01/24.
//

struct WeatherResponse: Codable {
    let coord: Coord
    let weather: [Weather]
    let name: String
    
    static func exampleData() -> WeatherResponse {
        return WeatherResponse(
            coord: Coord(lat: 6.2297401, lon: 106.7471169), // Jakarta Coordinate
            weather: [Weather(
                main: "Thunderstorm" ,
                icon: "11d",
                description: "thunderstorm with heavy rain")],
            name: "DKI Jakarta"
        )
    }
    
    static func emptyData() -> WeatherResponse {
        let coord = Coord(lat: 0.0, lon: 0.0)
        let weather1 = Weather(main: "N/A", icon: "N/A", description: "N/A")
        let weatherArray = [weather1]
        let weatherResponse = WeatherResponse(coord: coord, weather: weatherArray, name: "N/A")
        
        return weatherResponse
    }
}

struct Weather: Codable {
    let main: String
    let icon: String
    let description: String
}

struct Coord: Codable {
    let lat: Double
    let lon: Double
    
    init(lat: Double, lon: Double) {
      self.lat  = lat
      self.lon  = lon
    }
}
