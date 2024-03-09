//
//  ImageToThumbnailGenerator.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-01-08.
//

import Foundation
import SwiftUI

extension UIImage {
    func getThumbnail() -> UIImage? {
        guard let imageData = self.pngData() else { return nil }
        let options = [
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceThumbnailMaxPixelSize: 60] as CFDictionary
        guard let source = CGImageSourceCreateWithData(imageData as CFData, nil) else { return nil }
        guard let imageReference = CGImageSourceCreateThumbnailAtIndex(source, 0, options) else { return nil }
        return UIImage(cgImage: imageReference)
    }
}
