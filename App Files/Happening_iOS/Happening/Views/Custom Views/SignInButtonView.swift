//
//  SignInButtonView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-12-22.
//

import SwiftUI

struct SignInButtonView: View {
    
    // MARK: PROPERTIES
    @Environment(\.colorScheme) var colorScheme
    
    // reference to button model
    let buttonModel: SignInButtonModel
    
    // MARK: BODY
    var body: some View {
        HStack{
            Image(buttonModel.imageName)
                .renderingMode(buttonModel.renderingMode)
                .resizable()
                .scaledToFit()
                .frame(width: 15)
                .foregroundColor(colorScheme == .light ? buttonModel.imageColorLight : buttonModel.imageColorDark)
            
            Text(buttonModel.text)
                .font(.headline.weight(.medium))
                .padding(.leading, 10)
            
            Spacer()
            
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(buttonModel.backgroundColor)
        .cornerRadius(10)
        .overlay(alignment: .trailing) {
            Image(systemName: "chevron.right")
                .font(.body.weight(.medium))
                .scaleEffect(1.1)
                .padding(.trailing)
        }
        .foregroundColor(colorScheme == .light ? buttonModel.chevronColorLight : buttonModel.chevronColorDark)
    }
}


// MARK: PREVIEW
struct SignInButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SignInButtonView(buttonModel: .init(imageName: "AppleLogo", renderingMode: .template, imageColorLight: .white, imageColorDark: .black, text: "Sign in with Apple", backgroundColor: .primary, chevronColorLight: .white, chevronColorDark: .black))
                .preferredColorScheme(.dark)
            
            SignInButtonView(buttonModel: .init(imageName: "AppleLogo", renderingMode: .template, imageColorLight: .white, imageColorDark: .black, text: "Sign in with Apple", backgroundColor: .primary, chevronColorLight: .white, chevronColorDark: .black))
        }
        .padding()
        .padding(.horizontal, 20)
    }
}
