//
//  PhotoSelectionViewModelDelegate.swift
//  WeatherWidget
//
//  Created by Daud Sandy Christianto on 21/01/24.
//

import Foundation
import Photos

protocol PhotoSelectionViewModelDelegate: AnyObject {
    func updatePhoto(with selectedPhoto: PHAsset)
}
