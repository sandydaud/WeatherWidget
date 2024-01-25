//
//  WeatherServiceTest.swift
//  WeatherWidgetTests
//
//  Created by Daud Sandy Christianto on 22/01/24.
//

import XCTest
@testable import WeatherWidget

class WeatherServiceTests: XCTestCase {
    
    var weatherService: WeatherService!
    var networkManagerMock: NetworkManager!
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
    
    
    override func setUpWithError() throws {
        mockSession = MockURLSession()
        networkManagerMock = NetworkManager()
        networkManagerMock.urlSession = mockSession
        
        weatherService = WeatherService.shared
        weatherService.network = networkManagerMock
    }
    
    // MARK: - getWeatherFromLocation Tests
    
    func testGetWeatherFromLocation_Success() {
        do {
            let expectation = XCTestExpectation(description: "Weather request should succeed")
            
            // Provide a valid latitude and longitude
            let lat = 37.7749
            let lon = -122.4194
            let urlRequest = try networkManagerMock.createURLRequest(apiData: mockApiData, basePath: "https://example.com")
            let jsonData = try JSONEncoder().encode(WeatherResponse.exampleData())
            let urlResponse = HTTPURLResponse(url: urlRequest.url!, statusCode: 200, httpVersion: nil, headerFields: nil)
            mockSession.data = jsonData
            mockSession.response = urlResponse
            mockSession.error = nil
            
            weatherService.getWeatherFromLocation(
                lat: lat,
                long: lon,
                onSuccess: { response in
                    // Assert the success scenario
                    XCTAssertNotNil(response)
                    expectation.fulfill()
                },
                onError: { error in
                    XCTFail("Unexpected error: \(error)")
                }
            )
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
        
//        wait(for: [expectation], timeout: 5.0)
    }
    
    func testGetWeatherFromLocation_Error() {
        let expectation = XCTestExpectation(description: "Weather request should result in an error")
        
        // Provide an invalid latitude and longitude
        let lat = 9999.0
        let lon = 9999.0
        
        weatherService.getWeatherFromLocation(
            lat: lat,
            long: lon,
            onSuccess: { _ in
                XCTFail("Unexpected success")
            },
            onError: { error in
                // Assert the error scenario
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        )
        
//        wait(for: [expectation], timeout: 5.0)
    }
    
    // MARK: - downloadImageFromUrl Tests
    
    func testDownloadImageFromUrl_Success() {
        do {
            let expectation = XCTestExpectation(description: "Image download should succeed")
            
            let image = UIImage(named: "SunBehindCloud")
            let pngData = image?.pngData()
            let urlRequest = try networkManagerMock.createURLRequest(apiData: mockApiData, basePath: "https://example.com")
            let urlResponse = HTTPURLResponse(url: urlRequest.url!, statusCode: 200, httpVersion: nil, headerFields: nil)
            
            mockSession.data = pngData
            mockSession.response = urlResponse
            
            // Provide a valid icon name
            let iconName = "01d"
            
            weatherService.downloadImageFromUrl(
                iconName: iconName,
                completion: { image in
                    // Assert the success scenario
                    XCTAssertNotNil(image)
                    expectation.fulfill()
                }
            )
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
        
//        wait(for: [expectation], timeout: 5.0)
    }
    
    func testDownloadImageFromUrl_Error() {
        let expectation = XCTestExpectation(description: "Image download should result in an error")
        
        // Provide an invalid icon name
        let iconName = "invalidIconName"
        
        weatherService.downloadImageFromUrl(
            iconName: iconName,
            completion: { image in
                // Assert the error scenario
                XCTAssertNil(image)
                expectation.fulfill()
            }
        )
        
//        wait(for: [expectation], timeout: 5.0)
    }

    // MARK: - Private Methods Tests

    func testGetImageAPIData() {
        let iconName = "01d"
        let apiData = weatherService.getImageAPIData(iconName: iconName)

        // Assert the correctness of the generated API data
        XCTAssertEqual(apiData.path, "\(WEATHER_ICON_PATH)\(iconName)@2x.png")
        XCTAssertEqual(apiData.method, .get)
        XCTAssertEqual(apiData.dataType, .JSON)
    }

    func testGetAPIData() {
        let lat = 37.7749
        let lon = -122.4194
        let apiData = weatherService.getAPIData(lat: lat, long: lon)

        // Assert the correctness of the generated API data
        XCTAssertEqual(apiData.path, WEATHER_URL_PATH)
        XCTAssertEqual(apiData.method, .get)
        XCTAssertEqual(apiData.parameters.urlParameters?[APP_ID_KEY] as? String, APP_ID_VALUE)
        XCTAssertEqual(apiData.parameters.urlParameters?[LOCATION_LATTITUDE_KEY] as? Double, lat)
        XCTAssertEqual(apiData.parameters.urlParameters?[LOCATION_LONGITUDE_KEY] as? Double, lon)
        XCTAssertEqual(apiData.dataType, .JSON)
    }
}

