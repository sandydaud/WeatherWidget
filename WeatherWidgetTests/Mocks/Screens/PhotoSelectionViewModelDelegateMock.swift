//
//  PhotoSelectionViewModelDelegateMock.swift
//  WeatherWidgetTests
//
//  Created by Daud Sandy Christianto on 22/01/24.
//

import Photos
@testable import WeatherWidget

class PhotoSelectionViewModelDelegateMock: PhotoSelectionViewModelDelegate {
    var didCallUpdatePhoto = false
    
    func updatePhoto(with selectedPhoto: PHAsset) {
        didCallUpdatePhoto = true
    }
}
