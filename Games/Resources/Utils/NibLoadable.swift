//
//  NibLoadable.swift
//  Games
//
//  Created by Ismael Mahmoud AlShabrawy on 19/05/2023.
//

import UIKit

/// A protocol for views that can be loaded from a XIB file.
protocol NibLoadable: AnyObject {
    /// The nib file associated with the view.
    static var nibFile: UINib { get }
}

// MARK: - Default implementation

extension NibLoadable {
    /// The default implementation returns a UINib object based on the view's class name and bundle.
    static var nibFile: UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
}

// MARK: - UICollectionViewCell extensions

extension UICollectionViewCell: NibLoadable {
    /// Returns the reuse identifier for the UICollectionViewCell.
    static func identifier() -> String {
        return String(describing: self)
    }
}

// MARK: - UITableViewCell extensions

extension UITableViewCell: NibLoadable {
    /// Returns the reuse identifier for the UITableViewCell.
    static func identifier() -> String {
        return String(describing: self)
    }
}
