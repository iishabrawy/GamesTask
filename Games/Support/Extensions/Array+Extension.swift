//
//  Array+Extension.swift
//  Games
//
//  Created by Ismael Mahmoud AlShabrawy on 22/05/2023.
//

import Foundation

extension Array where Element: Equatable {

    /// Removes duplicate elements from the array.
    /// - Returns: An array with duplicate elements removed.
    func removeDuplicates() -> [Element] {
        var result = [Element]()

        for value in self where result.contains(value) == false {
            result.append(value)
        }

        return result
    }

    /// Concatenates the elements of the array into a single string, filtering out empty strings.
    /// - Parameter separator: The separator to use between the concatenated elements.
    /// - Returns: The concatenated string.
    func compactConcatenateString(separator: String) -> String {
        return compactMap { $0 as? String }.filter { !$0.isEmpty }.joined(separator: separator)
    }
}
