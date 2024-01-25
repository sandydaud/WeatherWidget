//
//  APIClientTest.swift
//  WeatherWidgetTests
//
//  Created by Daud Sandy Christianto on 22/01/24.
//

import XCTest
@testable import WeatherWidget

class APIClientTests: XCTestCase {
    
    var apiClient: APIClient!
    let mockApiData = APIDataObject(
        path: WEATHER_URL_PATH,
        method: .get,
        parameters: RequestParams(
            urlParameters: [:],
            bodyParameters: [:]
        ),
        dataType: .JSON
    )
    let networkManagerMock = NetworkManagerMock()
    
    override func setUp() {
        super.setUp()
        apiClient = APIClient(authorizationManager: networkManagerMock)
    }
    
    override func tearDown() {
        apiClient = nil
        super.tearDown()
    }
    
    func testFetchSuccess() {
        let expectation = XCTestExpectation(description: "Fetch data successfully")
        
        // Simulate a successful response
        let weatherResponse = WeatherResponse.exampleData()
        do {
            let jsonData = try JSONEncoder().encode(weatherResponse)
            networkManagerMock.data = jsonData
            networkManagerMock.response = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
            
            let request = mockApiData
            
            apiClient.fetch(request: request, basePath: "https://example.com", keyDecodingStrategy: .convertFromSnakeCase) { (result: Result<WeatherResponse, NetworkError>) in
                switch result {
                case .success(let response):
                    // Assert that the response is not nil
                    XCTAssertNotNil(response)
                    expectation.fulfill()
                case .failure(let error):
                    // Handle the failure case
                    XCTFail("Error fetching data: \(error.localizedDescription)")
                    expectation.fulfill()
                }
            }
            
            wait(for: [expectation], timeout: 5.0)
        } catch {
            
        }
    }
    
    func testFetchFailure() {
        let expectation = XCTestExpectation(description: "Fetch data with failure")
        
        // Simulate a failure scenario
        networkManagerMock.error = CustomError(message: "This is a custom error")
        
        let request = mockApiData
        
        apiClient.fetch(request: request, basePath: "https://example.com", keyDecodingStrategy: .convertFromSnakeCase) { (result: Result<WeatherResponse, NetworkError>) in
            switch result {
            case .success(_):
                // Unexpected success, fail the test
                XCTFail("Unexpected success")
                expectation.fulfill()
            case .failure(let error):
                // Assert that the error is not nil
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
}

struct CustomError: LocalizedError {
    let message: String
    
    init(message: String) {
        self.message = message
    }
    
    var errorDescription: String? {
        return message
    }
}
