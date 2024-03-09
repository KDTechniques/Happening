//
//  HideKeyboardPlacementView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-12-19.
//

import Foundation
import SwiftUI

struct HideKeyboardPlacementView: View {
    var body: some View {
        HStack {
            Spacer()
            
            Button {
                hideKeyboard()
            } label: {
                HStack {
                    Text("Hide  Keyboard")
                        .font(.caption2)
                    Image(systemName: "keyboard.chevron.compact.down")
                }
            }
            .tint(ColorTheme.shared.accentColor)
        }
    }
}

public extension View {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}

public func hideKeyboard() {
    let resign = #selector(UIResponder.resignFirstResponder)
    UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
}
