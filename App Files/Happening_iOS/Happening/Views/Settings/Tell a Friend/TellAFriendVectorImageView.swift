//
//  TellAFriendVectorImageView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-01-09.
//

import SwiftUI

struct TellAFriendVectorImageView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @EnvironmentObject var color: ColorTheme
    @EnvironmentObject var contactPickerSheetViewModel: ContactPickerSheetViewModel
    
    // MARK: BODY
    var body: some View {
        ZStack {
            Image(contactPickerSheetViewModel.tellAFriendImageSecondaryColorLayer)
                .resizable()
                .scaledToFit()
            
            Image(contactPickerSheetViewModel.tellAFriendImageAccentColorLayer)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .foregroundColor(color.accentColor)
            
            Image(contactPickerSheetViewModel.tellAFriendImageShadowLayer)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .foregroundColor(Color.black)
        }
    }
}

// MARK: PREVIEWS
struct TellAFriendVectorImageView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TellAFriendVectorImageView()
                .preferredColorScheme(.dark)
            
            TellAFriendVectorImageView()
        }
        .environmentObject(SettingsViewModel())
        .environmentObject(ColorTheme())
        .environmentObject(ContactPickerSheetViewModel())
    }
}
