//
//  ActionButton.swift
//  WeatherWidget
//
//  Created by Daud Sandy Christianto on 21/01/24.
//

import Foundation
import UIKit

class ActionButton {
    func createButton(title: String, icon: UIImage?, backgroundColor: UIColor, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        
        // Button text
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        // Button image
        if let icon = icon?.withRenderingMode(.alwaysTemplate) {
            let resizedIcon = icon.resize(targetSize: CGSize(width: 24, height: 24))
            button.setImage(resizedIcon, for: .normal)
        }
        
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.contentCompressionResistancePriority(for: .horizontal)
        
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 8)
        button.addTarget(self, action: action, for: .touchUpInside)
        
        return button
    }
}
