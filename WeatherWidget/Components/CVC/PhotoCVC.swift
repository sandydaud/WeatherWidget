//
//  PhotoCVC.swift
//  WeatherWidget
//
//  Created by Daud Sandy Christianto on 19/01/24.
//

import UIKit
import Photos

class PhotoCVC: UICollectionViewCell {
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var selectedOverlay: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.red.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        setupImageView()
        setupSelectedOverlay()
    }
    
    func configure(with asset: PHAsset?, isSelected: Bool?) {
        guard let asset = asset, let isSelected = isSelected else {
            return
        }

        let manager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.deliveryMode = .highQualityFormat
        requestOptions.isNetworkAccessAllowed = true
        
        let targetSize = CGSize(width: frame.width, height: frame.height)
        
        manager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: requestOptions) { (image, _) in
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
        selectedOverlay.isHidden = !isSelected
    }
    
    override var isSelected: Bool {
        didSet {
            selectedOverlay.isHidden = !isSelected
        }
    }
    
    private func setupImageView() {
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func setupSelectedOverlay() {
        addSubview(selectedOverlay)
        
        NSLayoutConstraint.activate([
            selectedOverlay.topAnchor.constraint(equalTo: topAnchor),
            selectedOverlay.leadingAnchor.constraint(equalTo: leadingAnchor),
            selectedOverlay.trailingAnchor.constraint(equalTo: trailingAnchor),
            selectedOverlay.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

