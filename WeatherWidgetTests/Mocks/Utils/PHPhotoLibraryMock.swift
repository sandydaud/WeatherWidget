//
//  PHPhotoLibraryMock.swift
//  WeatherWidgetTests
//
//  Created by Daud Sandy Christianto on 23/01/24.
//
import Photos

class PHPhotoLibraryMock: PHPhotoLibrary {
    static var authorizationStatusToReturn: PHAuthorizationStatus = .notDetermined
    static var requestAuthorizationCalled = false
    static var requestAuthorizationCompletionHandler: ((PHAuthorizationStatus) -> Void)?

    override class func authorizationStatus() -> PHAuthorizationStatus {
        return authorizationStatusToReturn
    }

    override class func requestAuthorization(_ handler: @escaping (PHAuthorizationStatus) -> Void) {
        requestAuthorizationCalled = true
        requestAuthorizationCompletionHandler = handler
    }
}
