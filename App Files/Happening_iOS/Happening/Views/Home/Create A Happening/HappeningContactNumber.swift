//
//  HappeningContactNumber.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-03-07.
//

import SwiftUI

struct HappeningContactNumber: View {
    
    @EnvironmentObject var createAHappeningVM: CreateAHappeningViewModel
    
    var body: some View {
        Section {
            Text(UserDefaults.standard.string(forKey: EditProfileViewModel.EditProfileViewUserDefaultsType.phoneNo.rawValue) ?? "...")
                .foregroundColor(.secondary)
        } header: {
            Text("Contact Number")
        } footer: {
            Text("*not editable")
        }
    }
}

struct HappeningContactNumber_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            List {
                HappeningContactNumber()
            }
            
            List {
                HappeningContactNumber()
            }
            .preferredColorScheme(.dark)
        }
        .listStyle(.grouped)
        .environmentObject(CreateAHappeningViewModel())
    }
}
