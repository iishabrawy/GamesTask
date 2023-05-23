//
//  Colors.swift
//  Games
//
//  Created by Ismael Mahmoud AlShabrawy on 19/05/2023.
//

import UIKit

extension DesignSystem {

    /// An enum representing the app's color palette.
    enum AppColors: String {
        case bgColor = "bgColor"
        case whiteColor = "whiteColor"
        case accentColor = "AccentColor"
        case blackColor = "blackColor"
        case blueColor = "blueColor"
        case grayColor = "grayColor"
        case redColor = "redColor"
        case openedGameBGColor = "openedGameBGColor"

        /// The UIColor value corresponding to the color case.
        var color: UIColor {
            guard let color = UIColor(named: rawValue) else {
                fatalError("Failed to load color: \(rawValue)")
            }
            return color
        }
    }
}
