//
//  ContactPickerSheet.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-01-09.
//

import SwiftUI

struct ContactPickerSheet: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @EnvironmentObject var contactPickerSheetViewModel: ContactPickerSheetViewModel
    
    // MARK: BODY
    var body: some View {
        EmptyView()
//        ContactPicker( // ContactPicker is a sheet
//            showPicker: $contactPickerSheetViewModel.isPresentedContactPickerSheet,
//            onSelectContact: {
//                if let Number = ($0.phoneNumbers.first?.value.stringValue) {
//                    contactPickerSheetViewModel.sendInvitationMessage(phoneNo: Number)
//                } else {
//                    contactPickerSheetViewModel.isPresentedEmptyContactNoAlert = true
//                }
//            }
//        )
    }
}

// MARK: PREVIEWS
struct ContactPickerSheet_Previews: PreviewProvider {
    static var previews: some View {
        ContactPickerSheet()
            .environmentObject(SettingsViewModel())
            .environmentObject(ColorTheme())
            .environmentObject(ContactPickerSheetViewModel())
    }
}
