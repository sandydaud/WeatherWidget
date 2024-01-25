//
//  APIClient.swift
//  WeatherWidget
//
//  Created by Daud Sandy Christianto on 10/01/24.
//

import Foundation

class APIClient: APIClientProtocol {
    private let authManager: NetworkManagerProtocol
    
    init(authorizationManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.authManager = authorizationManager
    }
    
    func fetch<T: Codable>(request: APIData, basePath: String, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy, completionHandler: @escaping ((Result<T, NetworkError>) -> Void)) {
        self.authManager.startRequest(request: request, basePath: basePath) { (data, response, error) in
            
            if let _ = error {
                let errorType = NetworkError.failed
                completionHandler(.failure(errorType))
                return
            }
            
            guard let responseData = response as? HTTPURLResponse,
                let receivedData = data else{
                    let errorType = NetworkError.noResponseData
                    completionHandler(.failure(errorType))
                    return
            }
            
            let responseStatus = self.isValidResponse(response: responseData)
            switch responseStatus {
            case .success:
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = keyDecodingStrategy
                do {
                    let apiResponseModel = try jsonDecoder.decode(T.self, from: receivedData)
                    completionHandler(.success(apiResponseModel))
                } catch {
                    completionHandler(.failure(NetworkError.unableToDecodeResponseData(errorDescription: error.localizedDescription)))
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    private func isValidResponse(response: HTTPURLResponse) -> Result<String, NetworkError>{
        switch response.statusCode{
        case 200...299:
            return .success("Valid Response")
        case 401:
            return .failure(NetworkError.authenticationError)
        case 500:
            return .failure(NetworkError.badRequest)
        default:
            return .failure(NetworkError.failed)
        }
    }
}

