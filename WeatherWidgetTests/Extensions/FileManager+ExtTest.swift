//
//  FileManager+ExtTest.swift
//  WeatherWidgetTests
//
//  Created by Daud Sandy Christianto on 23/01/24.
//

import XCTest
import Photos
@testable import WeatherWidget

class FileManagerExtensionTests: XCTestCase {

    let mockCoord = Coord(lat: 37.7749, lon: -122.4194)
    let mockPHAsset = PHAsset()

    func testReadWriteCoordToDisk() {
        // Write to disk
        FileManager.writeCitiesToDisk(location: mockCoord)

        // Read from disk
        let readCoord = FileManager.readCitiesFromDisk()

        XCTAssertEqual(mockCoord, readCoord)
    }
}
