//
//  NetworkConfig.swift
//  WeatherWidget
//
//  Created by Daud Sandy Christianto on 10/01/24.
//

import Foundation

public enum HTTPMethod: String {
    case get
    case post
    case put
    case delete
    case patch
}

public enum ResponseDataType {
    case Data
    case JSON
}

enum HeaderContentType: String {
    case json = "application/json"
}

enum HTTPHeaderKeys: String {
    case contentType = "Content-Type"
    case cookie = "Cookie"
}

public struct RequestParams {
    let urlParameters: [String: Any]?
    let bodyParameters: [String: Any]?
    let contentType: HeaderContentType
    
    init(urlParameters: [String: Any]?, bodyParameters: [String: Any]?, contentType: HeaderContentType = .json) {
        self.urlParameters = urlParameters
        self.bodyParameters = bodyParameters
        self.contentType = contentType
    }
}
