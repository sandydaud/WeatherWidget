//
//  WidgetCVC.swift
//  WeatherWidget
//
//  Created by Daud Sandy Christianto on 11/01/24.
//

import UIKit
import SwiftUI

class WidgetCell: UICollectionViewCell {

    static let identifier = "WidgetCellIdentifier"
    private var smallHC: UIHostingController<SmallWidgetView>?
    private var mediumHC: UIHostingController<MediumWidgetView>?
    private var largeHC: UIHostingController<LargeWidgetView>?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.shadowColor = CGColor.init(gray: 0.5, alpha: 1)
        self.layer.shadowRadius = 8
        self.layer.shadowOpacity = 1
        self.backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(
        with widgetSize: WidgetSize,
        weather: WeatherResponse,
        image: UIImage? = nil,
        backgroundPhoto: UIImage? = nil,
        isLoading: Bool = false
    ) {
        self.contentView.subviews.forEach { $0.removeFromSuperview() }

        switch widgetSize {
        case .small:
            let smallWidget = SmallWidgetView(
                weatherConfig: weather,
                weatherImage: image,
                backgroundPhoto: backgroundPhoto
            )
            smallHC = UIHostingController(rootView: smallWidget)
            smallHC?.view.frame = contentView.bounds
            smallHC?.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            smallHC?.view.layer.cornerRadius = 16
            smallHC?.rootView.isLoading = isLoading
            
            if let view = smallHC?.view {
                contentView.addSubview(view)
                setCenteredWidget(widgetSubview: view, size: widgetSize.size)
            }
        case .medium:
            let mediumWidget = MediumWidgetView(
                weatherConfig: weather,
                weatherImage: image,
                backgroundPhoto: backgroundPhoto
            )
            mediumHC = UIHostingController(rootView: mediumWidget)
            mediumHC?.view.frame = contentView.bounds
            mediumHC?.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            mediumHC?.view.layer.cornerRadius = 16
            mediumHC?.rootView.isLoading = isLoading
            
            if let view = mediumHC?.view {
                contentView.addSubview(view)
                setCenteredWidget(widgetSubview: view, size: widgetSize.size)
            }
        case .large:
            let largeWidget = LargeWidgetView(
                weatherConfig: weather,
                weatherImage: image,
                backgroundPhoto: backgroundPhoto
            )
            largeHC = UIHostingController(rootView: largeWidget)
            largeHC?.view.frame = contentView.bounds
            largeHC?.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            largeHC?.view.layer.cornerRadius = 16
            largeHC?.rootView.isLoading = isLoading
            
            if let view = largeHC?.view {
                contentView.addSubview(view)
                setCenteredWidget(widgetSubview: view, size: widgetSize.size)
            }
        }
    }
    
    private func setCenteredWidget(widgetSubview: UIView, size: CGSize) {
        widgetSubview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            widgetSubview.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            widgetSubview.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            widgetSubview.heightAnchor.constraint(equalToConstant: size.height),
            widgetSubview.widthAnchor.constraint(equalToConstant: size.width)
        ])
    }
}
