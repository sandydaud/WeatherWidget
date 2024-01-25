//
//  NetworkManagerTest.swift
//  WeatherWidgetTests
//
//  Created by Daud Sandy Christianto on 22/01/24.
//

import XCTest
@testable import WeatherWidget

class NetworkManagerTests: XCTestCase {
    
    var networkManager: NetworkManager!
    var mockSession: MockURLSession!
    let mockApiData = APIDataObject(
        path: "/example",
        method: .get,
        parameters: RequestParams(
            urlParameters: [:],
            bodyParameters: [:]
        ),
        dataType: .JSON
    )
    
    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        networkManager = NetworkManager.shared
        networkManager.urlSession = mockSession
    }
    
    override func tearDown() {
        networkManager = nil
        mockSession = nil
        super.tearDown()
    }
    
    func testStartRequestSuccess() {
        let expectation = XCTestExpectation(description: "Fetch data successfully")
        
        // Create a valid URLRequest for testing
        do {
            let urlRequest = try networkManager.createURLRequest(apiData: mockApiData, basePath: "https://example.com")
            
            // Set up the mock session to return data and response
            let jsonData = try JSONEncoder().encode(WeatherResponse.exampleData())
            let urlResponse = HTTPURLResponse(url: urlRequest.url!, statusCode: 200, httpVersion: nil, headerFields: nil)
            mockSession.data = jsonData
            mockSession.response = urlResponse
            
            // Call startRequest and verify the completion block
            networkManager.startRequest(request: mockApiData, basePath: "https://example.com") { (data, response, error) in
                XCTAssertEqual(data, jsonData)
                XCTAssertEqual(response, urlResponse)
                XCTAssertNil(error)
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 5.0)
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func testStartRequestWithError() {
        let expectation = XCTestExpectation(description: "Fetch data with failure")
        
        // Create a valid URLRequest for testing
        do {
//            let urlRequest = try networkManager.createURLRequest(apiData: mockApiData, basePath: "https://example.com")
            
            // Set up the mock session to return an error
            let mockError = NSError(domain: "MockErrorDomain", code: 123, userInfo: nil)
            mockSession.error = mockError
            
            // Call startRequest and verify the completion block
            networkManager.startRequest(request: mockApiData, basePath: "https://example.com") { (data, response, error) in
                XCTAssertNil(data)
                XCTAssertNil(response)
                XCTAssertEqual(error as NSError?, mockError)
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 5.0)
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
}
