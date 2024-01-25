//
//  PhotoSelectionViewModel.swift
//  WeatherWidget
//
//  Created by Daud Sandy Christianto on 19/01/24.
//

import Photos
import UIKit

#if DEBUG
let isRunningTests = NSClassFromString("XCTestCase") != nil
#else
let isRunningTests = false
#endif

class PhotoSelectionViewModel {
    var model: PhotoSelectionModel
    
    weak var delegate: PhotoSelectionViewModelDelegate?
    
    init(model: PhotoSelectionModel) {
        self.model = model
    }
    
    init(model: PhotoSelectionModel, selectedPhoto: PHAsset?) {
        self.model = model
        self.model.selectedPhoto = selectedPhoto
    }
    
    
    func fetchPhotos() {
        let fetchOptions = PHFetchOptions()
        let result = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        result.enumerateObjects { [weak self] (asset, _, _) in
            guard let ws = self else { return }
            ws.model.photos.append(asset)
        }
    }
    
    private func selectPhoto(at index: Int) {
        // Clear previous selection
        model.selectedPhoto = nil

        // Set the new selection
        if index < model.photos.count {
            model.selectedPhoto = model.photos[index]
        }
    }
    
    func isPhotoSelected(at index: Int) -> Bool {
        if let selectedPhoto = model.selectedPhoto, index < model.photos.count {
            let photo = model.photos[index]
            return selectedPhoto.localIdentifier == photo.localIdentifier
        }
        
        return false
    }
    
    func whenPhotoSelected(indexPhoto: Int, vc: UIViewController, completion: @escaping () -> Void) {
        selectPhoto(at: indexPhoto)
        completion()

        if let photo = model.selectedPhoto {
            if !isRunningTests {
                FileManager.writePHAssetImageToDisk(phAsset: photo)
            }
            delegate?.updatePhoto(with: photo)
        }

        // Dismiss the screen after 0.5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            vc.dismiss(animated: true, completion: nil)
        }
    }
}
