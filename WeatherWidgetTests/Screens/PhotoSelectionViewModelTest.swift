//
//  PhotoSelectionViewModelTest.swift
//  WeatherWidgetTests
//
//  Created by Daud Sandy Christianto on 22/01/24.
//

import XCTest
import Photos
@testable import WeatherWidget

class PhotoSelectionViewModelTests: XCTestCase {
    let model = PhotoSelectionModel()
    var viewModel: PhotoSelectionViewModel!
    var delegateMock: PhotoSelectionViewModelDelegateMock!
    
    override func setUp() {
        super.setUp()
        
        delegateMock = PhotoSelectionViewModelDelegateMock()
        
        let asset1 = MockPHAsset()
        let asset2 = MockPHAsset()
        model.photos = [asset1, asset2] // Add sample PHAssets
        viewModel = PhotoSelectionViewModel(model: model)
        viewModel.delegate = delegateMock
        
    }
    
    // Test fetching photos
    func testFetchPhotos() {
        viewModel.fetchPhotos()
        
        // Verify that the photos array is not empty after fetching
        XCTAssertFalse(viewModel.model.photos.isEmpty)
    }
    
    // Test whenPhotoSelected
    func testWhenPhotoSelected() {
        let vcMock = UIViewControllerMock()
        viewModel.model.selectedPhoto = model.photos[1]

        // Mock delegate
        let delegateMock = PhotoSelectionViewModelDelegateMock()
        viewModel.delegate = delegateMock

        let expectation = XCTestExpectation(description: "Operation completes")
        viewModel.whenPhotoSelected(indexPhoto: 1, vc: vcMock) {
            expectation.fulfill()
        }

        // Verify that FileManager method is called
        XCTAssertTrue(delegateMock.didCallUpdatePhoto)
        XCTAssertNotNil(FileManager.readPHAssetImageFromDisk)
    }
}

class MockPHAsset: PHAsset {
    override var localIdentifier: String {
        return "mocked_local_identifier"
    }
}
