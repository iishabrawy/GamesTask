//
//  String+Extension.swift
//  Games
//
//  Created by Ismael Mahmoud AlShabrawy on 19/05/2023.
//

import UIKit

extension String {
    /// Asynchronously loads an image from the specified URL string.
    ///
    /// - Parameters:
    ///   - completion: The completion block to be called when the image is loaded.
    ///                 It provides the loaded image, or `nil` if the image failed to load.
    func loadImage(completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = getCachedImage(for: self) {
            completion(cachedImage)
            return
        }

        guard let url = URL(string: self) else {
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error downloading image: \(error)")
                completion(nil)
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }

            cacheImage(image, for: self)
            completion(image)
        }

        task.resume()
    }

    /// Retrieves a cached image from the cache directory for the specified URL string.
    ///
    /// - Parameter urlString: The URL string to retrieve the cached image for.
    /// - Returns: The cached image, or `nil` if the image is not cached or failed to load from disk.
    func getCachedImage(for urlString: String) -> UIImage? {
        guard let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first,
              let url = URL(string: urlString) else {
            return nil
        }

        let fileURL = cacheDirectory.appendingPathComponent(url.lastPathComponent)

        if FileManager.default.fileExists(atPath: fileURL.path) {
            return UIImage(contentsOfFile: fileURL.path)
        }

        return nil
    }

    /// Caches the specified image for the given URL string in the cache directory.
    ///
    /// - Parameters:
    ///   - image: The image to cache.
    ///   - urlString: The URL string associated with the image.
    func cacheImage(_ image: UIImage, for urlString: String) {
        guard let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first,
              let url = URL(string: urlString),
              let imageData = image.pngData() else {
            return
        }

        let fileURL = cacheDirectory.appendingPathComponent(url.lastPathComponent)

        do {
            try imageData.write(to: fileURL)
        } catch {
            print("Error caching image: \(error)")
        }
    }
}

extension NSAttributedString {
    /*
     label.attributedText = NSAttributedString(
     html: "<span> recognized <a href='#/userProfile/NZ==/XQ=='> Punit Kumar </a> for Delivers on time</span>"
     )
     */
    convenience init?(html: String) {
        guard let data = html.data(using: String.Encoding.utf16, allowLossyConversion: false) else {
            // not sure which is more reliable: String.Encoding.utf16 or String.Encoding.unicode
            return nil
        }
        guard let attributedString = try? NSMutableAttributedString(
            data: data,
            options: [NSAttributedString
                .DocumentReadingOptionKey
                .documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil
        ) else {
            return nil
        }
        self.init(attributedString: attributedString)
    }
}

extension NSAttributedString {
    convenience init(data: Data, documentType: DocumentType, encoding: String.Encoding = .utf8) throws {
        try self.init(data: data,
                      options: [.documentType: documentType,
                                .characterEncoding: encoding.rawValue],
                      documentAttributes: nil)
    }

    convenience init(html data: Data) throws {
        try self.init(data: data, documentType: .html)
    }

    convenience init(txt data: Data) throws {
        try self.init(data: data, documentType: .plain)
    }

    convenience init(rtf data: Data) throws {
        try self.init(data: data, documentType: .rtf)
    }

    convenience init(rtfd data: Data) throws {
        try self.init(data: data, documentType: .rtfd)
    }
}

extension StringProtocol {
    var data: Data { return Data(utf8) }
    var htmlToAttributedString: NSAttributedString? {
        do {
            return try .init(html: data)
        } catch {
            debugPrint("html error:", error)
            return nil
        }
    }

    var htmlDataToString: String? {
        return htmlToAttributedString?.string
    }
}

extension Data {
    var htmlToAttributedString: NSAttributedString? {
        do {
            return try .init(html: self)
        } catch {
            debugPrint("html error:", error)
            return nil
        }
    }
}
