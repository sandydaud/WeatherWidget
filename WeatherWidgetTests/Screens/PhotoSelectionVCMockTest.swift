//
//  PhotoSelectionVCMockTest.swift
//  WeatherWidgetTests
//
//  Created by Daud Sandy Christianto on 22/01/24.
//

import XCTest
@testable import WeatherWidget
import Photos

class PhotoSelectionVCTests: XCTestCase {
    var photoSelectionVC: PhotoSelectionVC!
    var viewModelMock: PhotoSelectionViewModelMock!

    override func setUp() {
        photoSelectionVC = PhotoSelectionVC()
        viewModelMock = PhotoSelectionViewModelMock(model: PhotoSelectionModel())
        photoSelectionVC.viewModel = viewModelMock
    }

    override func tearDown() {
        photoSelectionVC = nil
        viewModelMock = nil
    }

    func testCheckPhotoLibraryPermissionNotDetermined() {
        // Given
        viewModelMock = PhotoSelectionViewModelMock(model: PhotoSelectionModel())
        viewModelMock.authorizationStatus = .notDetermined

        // When
        photoSelectionVC.checkPhotoLibraryPermission()

        // Then
        XCTAssertFalse(viewModelMock.didCallFetchPhotos)
    }

    func testCheckPhotoLibraryPermissionDenied() {
        // Given
        viewModelMock = PhotoSelectionViewModelMock(model: PhotoSelectionModel())
        viewModelMock.authorizationStatus = .denied

        // When
        photoSelectionVC.checkPhotoLibraryPermission()

        // Then
        XCTAssertFalse(viewModelMock.didCallFetchPhotos)
    }

    func testCollectionViewDidSelectItemAt() {
        // Given
        let indexPath = IndexPath(item: 0, section: 0)

        // When
        photoSelectionVC.collectionView(photoSelectionVC.collectionView, didSelectItemAt: indexPath)

        // Then
        XCTAssertTrue(viewModelMock.didCallWhenPhotoSelected)
    }
    
    private func mockAuthorizationStatus(_ status: PHAuthorizationStatus) {
        PHPhotoLibraryMock.authorizationStatusToReturn = status
    }
}


