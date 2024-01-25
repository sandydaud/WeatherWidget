//
//  UIViewControllerMock.swift
//  WeatherWidgetTests
//
//  Created by Daud Sandy Christianto on 22/01/24.
//

import UIKit


class UIViewControllerMock: UIViewController {
    var didCallPresent = false
    var didCallDismiss = false
    var presentedVC: UIViewController?

    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        didCallPresent = true
        presentedVC = viewControllerToPresent
    }

    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        didCallDismiss = true
        super.dismiss(animated: flag, completion: completion)
    }
}
