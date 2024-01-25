//
//  WeatherResponse+Equatable.swift
//  WeatherWidgetTests
//
//  Created by Daud Sandy Christianto on 22/01/24.
//

@testable import WeatherWidget

extension WeatherResponse: Equatable {
    public static func == (lhs: WeatherResponse, rhs: WeatherResponse) -> Bool {
        return lhs.coord == rhs.coord &&
            lhs.weather == rhs.weather &&
            lhs.name == rhs.name
    }
}

extension Weather: Equatable {
    public static func == (lhs: Weather, rhs: Weather) -> Bool {
        return lhs.main == rhs.main &&
            lhs.icon == rhs.icon &&
            lhs.description == rhs.description
    }
}

extension Coord: Equatable {
    public static func == (lhs: Coord, rhs: Coord) -> Bool {
        return lhs.lat == rhs.lat && lhs.lon == rhs.lon
    }
}
