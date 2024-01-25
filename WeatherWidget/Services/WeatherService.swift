//
//  WeatherService.swift
//  WeatherWidget
//
//  Created by Daud Sandy Christianto on 10/01/24.
//

import Foundation
import CoreLocation
import UIKit

class WeatherService: WeatherServiceProtocol {
    static let shared = WeatherService()
    
    private init() {}
    
    var network: NetworkManagerProtocol = NetworkManager.shared
    var api: APIClientProtocol = APIClient()
    
    func getWeatherFromLocation(
        lat: Double,
        long: Double,
        onSuccess: @escaping (WeatherResponse) -> Void,
        onError: @escaping (NetworkError) -> Void
    ) {
        api.fetch(
            request: getAPIData(lat: lat, long: long),
            basePath: OPEN_WEATHER_MAP_API,
            keyDecodingStrategy: .convertFromSnakeCase
        ) { (result: Result<WeatherResponse, NetworkError>) in
            switch result {
                case .success(let apiResponseModel):
                    // Handle the success case with the received model
                    onSuccess(apiResponseModel)
                case .failure(let error):
                    // Handle the failure case with the received error
                    onError(error)
                }
        }
    }
    
    func downloadImageFromUrl(iconName: String, completion: @escaping (UIImage?) -> Void) {
        network.startRequest(
            request: getImageAPIData(iconName: iconName),
            basePath: OPEN_WEATHER_MAP_URL,
            completion: { data, _, error in
                guard error == nil else {
                    completion(nil)
                    return
                }
                if let dataResponse = data, let imageResult = UIImage(data: dataResponse) {
                    completion(imageResult)
                } else {
                    completion(nil)
                }
                
            }
        )
    }
    
    func getImageAPIData(iconName: String) -> APIData {
        let requestParam = RequestParams(
            urlParameters: [:],
            bodyParameters: [:]
        )
        let apiData = APIDataObject(
            path: "\(WEATHER_ICON_PATH)\(iconName)@2x.png",
            method: .get,
            parameters: requestParam,
            dataType: .JSON
        )
        return apiData
    }
    
    func getAPIData(lat: Double, long: Double) -> APIData {
        let urlParam: [String: Any] = [
            APP_ID_KEY: APP_ID_VALUE,
            LOCATION_LATTITUDE_KEY: lat,
            LOCATION_LONGITUDE_KEY: long
        ]
        let requestParam = RequestParams(
            urlParameters: urlParam,
            bodyParameters: [:]
        )
        
        let apiData = APIDataObject(
            path: WEATHER_URL_PATH,
            method: .get,
            parameters: requestParam,
            dataType: .JSON
        )
        return apiData
    }
}
