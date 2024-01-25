//
//  APIClientProtocol.swift
//  WeatherWidget
//
//  Created by Daud Sandy Christianto on 10/01/24.
//

import Foundation

protocol APIClientProtocol {
    func fetch<T: Codable>(request: APIData,
                             basePath: String,
                             keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy,
                             completionHandler: @escaping ((Result<T, NetworkError>) -> Void))
}
