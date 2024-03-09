//
//  TellAFriendView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-11-22.
//

import SwiftUI

struct TellAFriendView: View {
    
    // MARK: PROPERTIES
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var color: ColorTheme
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @EnvironmentObject var contactPickerSheetViewModel: ContactPickerSheetViewModel
    
    // MARK: BODY
    var body: some View {
        ZStack {
            ContactPickerSheet()
            
            VStack{
                TellAFriendVectorImageView()
                
                Text("Invite Your Friends to Happening")
                    .font(.title.weight(.bold))
                    .multilineTextAlignment(.center)
                    .padding()
                
                Spacer()
                
                Text("Click on Invite a Friend to pick a contact and send an SMS Invitation.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding()
                    .fixedSize(horizontal: false, vertical: true)
                
                ButtonView(name: "Invite a Friend") {
                    contactPickerSheetViewModel.isPresentedContactPickerSheet = true
                }
                
                Spacer()
            }
            .offset(x: 0, y: -90)
        }
        .alert(isPresented: $contactPickerSheetViewModel.isPresentedEmptyContactNoAlert) {
            cancelOKAlertReturner(title: "Number Not Found", message: "Pick a contact that has a valid number.")
        }
    }
}

// MARK: PREVIEWS
struct TellAFriendView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                TellAFriendView()
                    .preferredColorScheme(.dark)
            }
            
            NavigationView {
                TellAFriendView()
            }
        }
        .environmentObject(ColorTheme())
        .environmentObject(SettingsViewModel())
        .environmentObject(ContactPickerSheetViewModel())
    }
}
