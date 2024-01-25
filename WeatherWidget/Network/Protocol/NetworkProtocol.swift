//
//  NetworkProtocol.swift
//  WeatherWidget
//
//  Created by Daud Sandy Christianto on 10/01/24.
//

import Foundation

protocol NetworkManagerProtocol {
    func startRequest(request: APIData, basePath: String, completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void)
}
