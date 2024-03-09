//
//  TextFieldPlaceholder.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-12-19.
//

import Foundation
import SwiftUI

public struct PlaceholderStyle: ViewModifier {
    var showPlaceHolder: Bool
    var placeholder: String
    var textColor: Color
    
    public func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
            if showPlaceHolder {
                Text(placeholder)
                    .foregroundColor(Color(UIColor.systemGray))
            }
            content
                .foregroundColor(textColor)
        }
    }
}
