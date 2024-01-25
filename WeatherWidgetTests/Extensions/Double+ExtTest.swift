//
//  Double+ExtTest.swift
//  WeatherWidgetTests
//
//  Created by Daud Sandy Christianto on 23/01/24.
//

import XCTest
@testable import WeatherWidget

class DoubleExtensionTests: XCTestCase {
    func testRounded() {
        // Test case 1
        XCTAssertEqual(3.14159.rounded(toDecimalPlaces: 2), "3.14")

        // Test case 2
        XCTAssertEqual(5.6789.rounded(toDecimalPlaces: 1), "5.7")

        // Test case 3
        XCTAssertEqual((-7.12345).rounded(toDecimalPlaces: 3), "-7.123")

        // Test case 4
        XCTAssertEqual(10.0.rounded(toDecimalPlaces: 0), "10")
    }
}
