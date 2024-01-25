//
//  APIDataProtocol.swift
//  WeatherWidget
//
//  Created by Daud Sandy Christianto on 10/01/24.
//

import Foundation

protocol APIData {
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: RequestParams { get }
    var headers: [String: String]? { get }
    var dataType: ResponseDataType { get }
    func absolutePath(from basePath: String) -> String
}

extension APIData {
    func absolutePath(from basePath: String) -> String {
        return basePath + path
    }
}

struct APIDataObject: APIData {
    var path: String
    
    var method: HTTPMethod
    
    var parameters: RequestParams
    
    var headers: [String : String]?
    
    var dataType: ResponseDataType
    
}
