//
//  WidthOfString.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-12-19.
//

import Foundation
import SwiftUI

public extension String {
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}

