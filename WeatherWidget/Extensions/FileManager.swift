//
//  FileManager.swift
//  WeatherWidget
//
//  Created by Daud Sandy Christianto on 18/01/24.
//

import Foundation
import UIKit
import Photos

extension FileManager {
    static func sharedContainerURL() -> URL {
        FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: "group.com.daudsandy.Weather.contents"
        )!
    }
    
    static func readCitiesFromDisk() -> Coord? {
        var contents: Coord?
        let containerURL = FileManager.sharedContainerURL()
        let archiveURL = containerURL.appendingPathComponent("weatherData.json")
        
        let decoder = JSONDecoder()
        if let codeData = try? Data(contentsOf: archiveURL) {
            do {
                contents = try decoder.decode(Coord.self, from: codeData)
            } catch {
                print("Error: Can't decode contents")
            }
        }
        return contents
    }
    
    static func writeCitiesToDisk(location: Coord) {
        let archiveURL = FileManager.sharedContainerURL()
            .appendingPathComponent("weatherData.json")
        let encoder = JSONEncoder()
        if let dataToSave = try? encoder.encode(location) {
            do {
                try dataToSave.write(to: archiveURL)
            } catch {
                print("Error: Can't write contents")
                return
            }
        }
    }
    
    static func readLocationAuthorizationFromDisk() -> Bool? {
        var isLocationAuthorized: Bool?
        let containerURL = FileManager.sharedContainerURL()
        let authorizationURL = containerURL.appendingPathComponent("locationAuthorization.json")
        
        let decoder = JSONDecoder()
        if let authData = try? Data(contentsOf: authorizationURL) {
            do {
                isLocationAuthorized = try decoder.decode(Bool.self, from: authData)
            } catch {
                print("Error: Can't decode location authorization status")
            }
        }
        return isLocationAuthorized
    }

    static func writeLocationAuthorizationToDisk(isAuthorized: Bool) {
        let authorizationURL = FileManager.sharedContainerURL()
            .appendingPathComponent("locationAuthorization.json")
        let encoder = JSONEncoder()
        if let dataToSave = try? encoder.encode(isAuthorized) {
            do {
                try dataToSave.write(to: authorizationURL)
            } catch {
                print("Error: Can't write location authorization status")
                return
            }
        }
    }
    
    static func readPHAssetImageFromDisk() -> UIImage? {
        var image: UIImage?
        let containerURL = FileManager.sharedContainerURL()
        let imageArchiveURL = containerURL.appendingPathComponent("weatherBackgroungImage.png")
        
        if let imageData = try? Data(contentsOf: imageArchiveURL) {
            image = UIImage(data: imageData)
        }
        
        return image
    }
    
    static func writePHAssetImageToDisk(phAsset: PHAsset) {
        let containerURL = FileManager.sharedContainerURL()
        let imageArchiveURL = containerURL.appendingPathComponent("weatherBackgroungImage.png")

        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true

        let imageManager = PHImageManager.default()
        imageManager.requestImage(
            for: phAsset,
               targetSize: CGSize(width: 300, height: 300),
               contentMode: .aspectFill,
               options: requestOptions
        ) { (image, _) in
            if let image = image, let imageData = image.pngData() {
                do {
                    try imageData.write(to: imageArchiveURL)
                } catch {
                    print("Error: Can't write PHAsset image data")
                }
            }
        }
    }
    
    static func removePHAssetImageFromDisk() {
        let containerURL = FileManager.sharedContainerURL()
        let imageArchiveURL = containerURL.appendingPathComponent("weatherBackgroungImage.png")

        do {
            try FileManager.default.removeItem(at: imageArchiveURL)
        } catch {
            print("Error: Unable to remove PHAsset image - \(error.localizedDescription)")
        }
    }
}
