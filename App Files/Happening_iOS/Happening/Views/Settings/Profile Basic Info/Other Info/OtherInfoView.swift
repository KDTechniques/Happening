//
//  OtherInfoView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-01-02.
//

import SwiftUI

// MARK: BODY
struct OtherInfoView: View {
    
    // MARK: PROPERTIES
    
    // reference to UserDefaults
    let defaults = UserDefaults.standard
    
    // MARK: BODY
    var body: some View {
        List {
            // nic no
            Section {
                Text(defaults.string(forKey: EditProfileViewModel.EditProfileViewUserDefaultsType.nicNo.rawValue) ?? "...")
            } header: {
                Text("Your NIC Number")
                    .font(.footnote)
            } footer: {
                Text("*not editable")
                    .font(.footnote)
            }
            
            // birth date
            Section {
                Text(defaults.string(forKey: EditProfileViewModel.EditProfileViewUserDefaultsType.dateOfBirth.rawValue) ?? "...")
            } header: {
                Text("Your Date of Birth")
                    .font(.footnote)
            } footer: {
                Text("*not editable")
                    .font(.footnote)
            }
            
            // age
            Section {
                Text(calculateAge(birthDate: defaults.string(forKey: EditProfileViewModel.EditProfileViewUserDefaultsType.dateOfBirth.rawValue) ?? ""))
            } header: {
                Text("Your Age")
                    .font(.footnote)
            } footer: {
                Text("*not editable")
                    .font(.footnote)
            }
            
            // gender
            Section {
                Text(defaults.string(forKey: EditProfileViewModel.EditProfileViewUserDefaultsType.gender.rawValue) ?? "...")
            } header: {
                Text("Your Gender")
                    .font(.footnote)
            } footer: {
                Text("*not editable")
                    .font(.footnote)
            }
        }
        .listStyle(.grouped)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(Text("Other Info"))
    }
}

// MARK: PREVIEWS
struct OtherInfoView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                OtherInfoView()
                    .preferredColorScheme(.dark)
            }
            
            NavigationView {
                OtherInfoView()
            }
        }
        .environmentObject(ProfileBasicInfoViewModel())
    }
}
