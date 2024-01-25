//
//  PhotoSelectionViewModelMock.swift
//  WeatherWidgetTests
//
//  Created by Daud Sandy Christianto on 22/01/24.
//

import Foundation
import Photos
import UIKit
@testable import WeatherWidget

class PhotoSelectionViewModelMock: PhotoSelectionViewModel {
    // MARK: Mock Variables
    var authorizationStatus: PHAuthorizationStatus = .notDetermined
    var didCallFetchPhotos = false
    var didCallRequestAuthorization = false
    var didCallWhenPhotoSelected = false

    // MARK: Initializer
    override init(model: PhotoSelectionModel) {
        super.init(model: model)
    }

    // MARK: Mock Functions

    // Simulate fetching photos
    override func fetchPhotos() {
        didCallFetchPhotos = true
        print("enter this dummy")
    }

    // Simulate requesting photo library authorization
    func requestAuthorization() {
        didCallRequestAuthorization = true
        handleAuthorizationStatus(authorizationStatus)
    }

    // Simulate selecting a photo
    override func whenPhotoSelected(indexPhoto: Int, vc: UIViewController, completion: @escaping () -> Void) {
        didCallWhenPhotoSelected = true
        super.whenPhotoSelected(indexPhoto: indexPhoto, vc: vc, completion: completion)
    }

    // MARK: Helper Function

    // Simulate handling authorization status
    private func handleAuthorizationStatus(_ status: PHAuthorizationStatus) {
        switch status {
        case .authorized, .limited:
            fetchPhotos()
        default:
            break
        }
    }
}
