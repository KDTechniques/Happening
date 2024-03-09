//
//  ButtonView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-01-05.
//

import SwiftUI

struct ButtonView: View {
    
    // MARK: PROPERTIES
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var color: ColorTheme
    private var buttonName: String
    private var buttonPadding: CGFloat = 45.0
    private var buttonAction: () -> () = { }
    
    // MARK: INITIALIZERS
    init(name: String, padding: CGFloat, action: @escaping () -> ()) {
        buttonName = name
        buttonPadding = padding
        buttonAction = action
    }
    
    init(name: String, action: @escaping () -> ()) {
        buttonName = name
        buttonAction = action
    }
    
    // MARK: BODY
    var body: some View {
        Button(action: buttonAction) {
            Text(buttonName)
                .font(.headline.weight(.semibold))
                .foregroundColor(color.accentColor == Color("AccentColorContrast")
                                 ? colorScheme == .light ? .white : .black
                                 : .white
                )
                .padding(.vertical, 15)
                .frame(maxWidth: .infinity)
                .background(color.accentColor)
                .cornerRadius(14)
                .padding(.horizontal, buttonPadding)
        }
    }
}

// MARK: PREVIEWS
struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ButtonView(name: "Send", padding: 60) { }
            .preferredColorScheme(.dark)
            
            ButtonView(name: "Done") { }
        }
        .environmentObject(ColorTheme())
    }
}
