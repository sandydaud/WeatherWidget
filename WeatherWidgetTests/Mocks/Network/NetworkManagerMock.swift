//
//  NetworkManagerMock.swift
//  WeatherWidgetTests
//
//  Created by Daud Sandy Christianto on 22/01/24.
//

import Foundation
@testable import WeatherWidget

class NetworkManagerMock: NetworkManagerProtocol {
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    func startRequest(request: APIData, basePath: String, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        completion(data, response, error)
    }
}
