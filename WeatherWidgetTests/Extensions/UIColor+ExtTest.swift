//
//  UIColor+ExtTest.swift
//  WeatherWidgetTests
//
//  Created by Daud Sandy Christianto on 23/01/24.
//

import XCTest
@testable import WeatherWidget

class UIColorExtensionTests: XCTestCase {

    func testLightSandColor() {
        let lightSandColor = UIColor.lightSand()

        XCTAssertEqual(Double(lightSandColor.cgColor.components?[0] ?? 0), 241/255, accuracy: 0.01)
        XCTAssertEqual(Double(lightSandColor.cgColor.components?[1] ?? 0), 239/255, accuracy: 0.01)
        XCTAssertEqual(Double(lightSandColor.cgColor.components?[2] ?? 0), 229/255, accuracy: 0.01)
        XCTAssertEqual(Double(lightSandColor.cgColor.components?[3] ?? 0), 1.0, accuracy: 0.01)
    }

    func testAccentGreenColor() {
        let accentGreenColor = UIColor.accentGreen()

        XCTAssertEqual(Double(accentGreenColor.cgColor.components?[0] ?? 0), 85/255, accuracy: 0.01)
        XCTAssertEqual(Double(accentGreenColor.cgColor.components?[1] ?? 0), 171/255, accuracy: 0.01)
        XCTAssertEqual(Double(accentGreenColor.cgColor.components?[2] ?? 0), 103/255, accuracy: 0.01)
        XCTAssertEqual(Double(accentGreenColor.cgColor.components?[3] ?? 0), 1.0, accuracy: 0.01)
    }

    func testKingCrimsonColor() {
        let kingCrimsonColor = UIColor.kingCrimson()

        XCTAssertEqual(Double(kingCrimsonColor.cgColor.components?[0] ?? 0), 198/255, accuracy: 0.01)
        XCTAssertEqual(Double(kingCrimsonColor.cgColor.components?[1] ?? 0), 74/255, accuracy: 0.01)
        XCTAssertEqual(Double(kingCrimsonColor.cgColor.components?[2] ?? 0), 74/255, accuracy: 0.01)
        XCTAssertEqual(Double(kingCrimsonColor.cgColor.components?[3] ?? 0), 1.0, accuracy: 0.01)
    }
}
