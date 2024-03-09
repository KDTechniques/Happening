//
//  MessageTextFieldBarView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-11-11.
//

import SwiftUI

struct MessegeTextFieldBarView: View {
    
    // MARK: PROPERTIES
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var color: ColorTheme
    @Binding var textFieldText: String
    @Binding var isEnabled: Bool
    let placeholder: String
    @Binding var textFieldBackgroundColor: Color
    @Binding var fullBackgroundColor: Color
    let dividerOpacity: CGFloat
    let textForegroundColor: Color
    let textFieldVerticalPadding: CGFloat
    @Binding var buttonHeight: CGFloat
    @Binding var buttonColor1: Color
    @Binding var buttonColor2: Color
    @Binding var buttonColor3: Color
    let isAlwaysEnabled: Bool
    @Binding var specialBlackCondition: Bool
    
    @State var onClicked: () -> ()
    
    // MARK: BODY
    var body: some View{
        HStack(spacing: 0){
            TextField("", text: $textFieldText)
                .modifier(PlaceholderStyle(showPlaceHolder: textFieldText.isEmpty, placeholder: placeholder, textColor: textForegroundColor))
                .padding(.horizontal)
                .padding(.vertical, textFieldVerticalPadding)
                .background(textFieldBackgroundColor)
                .cornerRadius(.infinity)
                .overlay(
                    RoundedRectangle(cornerRadius: .infinity)
                        .stroke(Color.primary.opacity(0.3), lineWidth: 0.2)
                )
                .padding(.horizontal)
                .onChange(of: textFieldText) { _ in
                    if (textFieldText.count > 0){
                        isEnabled = true
                    } else{
                        if(isAlwaysEnabled) {
                            isEnabled = true
                        } else {
                            isEnabled = false
                        }
                    }
                }
                .accentColor(specialBlackCondition ? Color.black : color.accentColor)
            
            Button {
                onClicked()
            }label: {
                Image(systemName: "paperplane.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: buttonHeight)
                    .rotationEffect(.degrees(45))
                    .accentColor(color.accentColor)
                    .background(color.accentColor == Color("AccentColorContrast")
                                ? (colorScheme == .light ? Circle().fill(isEnabled ? buttonColor1 : Color(UIColor.systemGray6)) : Circle().fill(isEnabled ? buttonColor2 : Color(UIColor.systemGray6)))
                                : colorScheme == .light ? Circle().fill(isEnabled ? buttonColor1 : Color(UIColor.systemGray6)) : Circle().fill(isEnabled ? buttonColor2 : Color(UIColor.systemGray6)))
                
            }
            .disabled(!isEnabled)
            .padding(.trailing)
        }
        .padding(.vertical, 8)
        .background(fullBackgroundColor)
        .overlay(alignment: .top) {
            Divider().opacity(dividerOpacity)
        }
    }
}

// MARK: PREVIEWS
struct MessegeTextFieldBarView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MessegeTextFieldBarView(
                textFieldText: .constant(""),
                isEnabled: .constant(false),
                placeholder: "",
                textFieldBackgroundColor: .constant(Color("MessageTextFieldColor")),
                fullBackgroundColor: .constant(Color("NavBarTabBarColor")),
                dividerOpacity: 1,
                textForegroundColor: .primary,
                textFieldVerticalPadding: 5,
                buttonHeight: .constant(32),
                buttonColor1: .constant(.white),
                buttonColor2: .constant(Color("NavBarTabBarColor")),
                buttonColor3: .constant(Color("NavBarTabBarColor")),
                isAlwaysEnabled: false,
                specialBlackCondition: .constant(false),
                onClicked: { }
            )
                .preferredColorScheme(.dark)
            
            MessegeTextFieldBarView(
                textFieldText: .constant("this is a sample text"),
                isEnabled: .constant(true),
                placeholder: "",
                textFieldBackgroundColor: .constant(Color("MessageTextFieldColor")),
                fullBackgroundColor: .constant(Color("NavBarTabBarColor")),
                dividerOpacity: 1,
                textForegroundColor: .primary,
                textFieldVerticalPadding: 5,
                buttonHeight: .constant(32),
                buttonColor1: .constant(.white),
                buttonColor2: .constant(Color("NavBarTabBarColor")),
                buttonColor3: .constant(Color("NavBarTabBarColor")),
                isAlwaysEnabled: false,
                specialBlackCondition: .constant(false),
                onClicked: { }
            )
        }
        .previewLayout(.sizeThatFits)
        .environmentObject(ColorTheme())
    }
}
