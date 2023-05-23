//
//  CNavigation.swift
//  Games
//
//  Created by Ismael Mahmoud AlShabrawy on 19/05/2023.
//

import UIKit

/// A custom subclass of `UINavigationController` that provides additional customization options.
public class CNavigation: UINavigationController {

    /// A closure that can be used as a callback handler.
    var callBackHandler: (() -> Void)?

    override public func pushViewController(
        _ viewController: UIViewController,
        animated: Bool
    ) {
        // Set the back bar button item title to a blank space
//        visibleViewController?.navigationItem.backBarButtonItem = UIBarButtonItem(
//            title: nil,
//            style: .plain,
//            target: nil,
//            action: nil
//        )
        super.pushViewController(viewController, animated: animated)
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // You can add additional behavior here when the view appears
    }

    override public var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
}
