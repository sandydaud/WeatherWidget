//
//  Double.swift
//  WeatherWidget
//
//  Created by Daud Sandy Christianto on 11/01/24.
//


extension Double {
    func rounded(toDecimalPlaces places: Int) -> String {
        return String(format: "%.\(places)f", self)
    }
}
