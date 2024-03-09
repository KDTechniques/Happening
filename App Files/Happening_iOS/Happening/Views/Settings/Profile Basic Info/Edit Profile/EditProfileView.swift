//
//  EditProfileView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-12-29.
//

import SwiftUI

struct EditProfileView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var color: ColorTheme
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @EnvironmentObject var profileBasicInfoViewModel: ProfileBasicInfoViewModel
    @EnvironmentObject var editProfileViewModel: EditProfileViewModel
    
    // reference to UserDefaults
    let defaults = UserDefaults.standard
    
    // MARK: BODY
    var body: some View {
        List {
            // user name and profile picture
            Section {
                // profile picture
                NavigationLink {
                    UpdateImageView()
                } label: {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            if let data = defaults.data(forKey: profileBasicInfoViewModel.profilePhotoUserDefaultsKeyName) {
                                Image(uiImage: UIImage(data: data)!)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                    .clipShape(Circle())
                                    .padding(.trailing)
                            } else {
                                Circle()
                                    .fill(.ultraThinMaterial)
                                    .frame(width: 60, height: 60)
                                    .overlay(
                                        ProgressView()
                                            .tint(.secondary)
                                    )
                                    .padding(.trailing)
                            }
                            
                            Text("\(Text("Note:").fontWeight(.semibold))\nWhen updating the profile picture, it needs to be approved by the Happening.")
                                .foregroundColor(Color.secondary)
                                .font(.footnote)
                                .padding(.trailing)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        
                        HStack {
                            Text("Update")
                                .font(.subheadline)
                                .frame(width: 60)
                                .foregroundColor(color.accentColor)
                                .padding(.vertical, 4)
                        }
                    }
                }
                
                // username
                NavigationLink {
                    EditUserNameView()
                } label: {
                    Text(UserDefaults.standard.string(forKey: ProfileBasicInfoViewModel.ProfileBasicInfoUserDefaultsType.userName.rawValue) ?? "...")
                }
            } header: {
                Text("Profile Picture & User Name")
                    .font(.footnote)
            }
            
            // profession
            Section {
                NavigationLink {
                    EditProfessionView()
                } label: {
                    Text(defaults.string(forKey: ProfileBasicInfoViewModel.ProfileBasicInfoUserDefaultsType.profession.rawValue) ?? "...")
                }
            } header: {
                Text("Profession")
                    .font(.footnote)
            }
            
            // about
            Section {
                NavigationLink {
                    EditAboutView()
                } label: {
                    Text(defaults.string(forKey: ProfileBasicInfoViewModel.ProfileBasicInfoUserDefaultsType.about.rawValue) ?? "...")
                }
            } header: {
                Text("About")
                    .font(.footnote)
            }
            
            // address
            Section {
                NavigationLink {
                    EditAdderssView()
                } label: {
                    Text(defaults.string(forKey: EditProfileViewModel.EditProfileViewUserDefaultsType.address.rawValue) ?? "...")
                }
            } header: {
                Text("Permanent Address")
                    .font(.footnote)
            }
            
            // phone no
            Section {
                NavigationLink {
                    EditPhoneNumberView()
                } label: {
                    Text(defaults.string(forKey: EditProfileViewModel.EditProfileViewUserDefaultsType.phoneNo.rawValue) ?? "...")
                }
            } header: {
                Text("Phone Number")
                    .font(.footnote)
            }
            
            // email
            Section {
                NavigationLink {
                    EditEmailAddressView()
                } label: {
                    Text(defaults.string(forKey: EditProfileViewModel.EditProfileViewUserDefaultsType.email.rawValue) ?? "...")
                }
            } header: {
                Text("Email Address")
                    .font(.footnote)
            }
            
            // date of birth
            Section {
                NavigationLink {
                    OtherInfoView()
                } label: {
                    Text("Other Info")
                }
            }
        }
        .listStyle(.grouped)
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: PREVIEWS
struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                EditProfileView()
                    .preferredColorScheme(.dark)
            }
            
            NavigationView {
                EditProfileView()
            }
        }
        .environmentObject(ColorTheme())
        .environmentObject(SettingsViewModel())
        .environmentObject(ProfileBasicInfoViewModel())
        .environmentObject(EditProfileViewModel())
    }
}
