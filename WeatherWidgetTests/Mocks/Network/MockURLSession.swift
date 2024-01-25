//
//  MockURLSession.swift
//  WeatherWidgetTests
//
//  Created by Daud Sandy Christianto on 22/01/24.
//

import Foundation
import CoreMedia

class MockURLSession: URLSession {
    
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    var completionHandler: CompletionHandler?
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping CompletionHandler) -> URLSessionDataTask {
        self.completionHandler = completionHandler
        return MockURLSessionDataTask(mockSession: self, completionHandler: completionHandler)
    }
}

class MockURLSessionDataTask: URLSessionDataTask {
    
    private weak var mockSession: MockURLSession?
    private let completionHandler: MockURLSession.CompletionHandler
    
    init(mockSession: MockURLSession, completionHandler: @escaping MockURLSession.CompletionHandler) {
        self.mockSession = mockSession
        self.completionHandler = completionHandler
    }
    
    override func resume() {
        // Simulate the behavior of URLSessionDataTask by calling the completion handler with provided data, response, and error.
        mockSession?.completionHandler?(mockSession?.data, mockSession?.response, mockSession?.error)
    }
}
