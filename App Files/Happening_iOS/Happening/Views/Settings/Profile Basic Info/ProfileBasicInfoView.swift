//
//  ProfileBasicInfoView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-11-19.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileBasicInfoView: View {
    
    // MARK: PROPERTIES
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var color: ColorTheme
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @EnvironmentObject var profileBasicInfoViewModel: ProfileBasicInfoViewModel
    
    let defaults = UserDefaults.standard
    
    // MARK: BODY
    var body: some View {
        HStack {
            // profile photo
            ZStack {
                if let data = defaults.data(forKey: profileBasicInfoViewModel.profilePhotoUserDefaultsKeyName) {
                    Image(uiImage: UIImage(data: data)!)
                        .resizable()
                } else {
                    WebImage(url: URL(string: profileBasicInfoViewModel.basicProfileDataArray[0].profilePhotoURL))
                        .onSuccess(perform: { _, data, _ in
                            if let compressedData = data {
                                defaults.set(compressedData, forKey: profileBasicInfoViewModel.profilePhotoUserDefaultsKeyName)
                            }
                        })
                        .resizable()
                        .placeholder {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(Color(UIColor.systemGray5))
                                .frame(width: 58, height: 58)
                                .clipShape(Circle())
                                .padding(.trailing, 3)
                        }
                }
            }
            .scaledToFill()
            .frame(width: 58, height: 58)
            .clipShape(Circle())
            .padding(.trailing, 3)
            
            // user name
            VStack(alignment: .leading) {
                Text(UserDefaults.standard.string(forKey: ProfileBasicInfoViewModel.ProfileBasicInfoUserDefaultsType.userName.rawValue) ?? "...")
                    .font(.system(size: 20))
                    .foregroundColor(Color.primary)
                
                // about
                Text(UserDefaults.standard.string(forKey: ProfileBasicInfoViewModel.ProfileBasicInfoUserDefaultsType.about.rawValue) ?? "...")
                    .font(.subheadline)
                    .foregroundColor(Color.secondary)
                
                // profession
                if(UserDefaults.standard.string(forKey: ProfileBasicInfoViewModel.ProfileBasicInfoUserDefaultsType.profession.rawValue) != ProfessionType.none.rawValue) {
                    Text(UserDefaults.standard.string(forKey: ProfileBasicInfoViewModel.ProfileBasicInfoUserDefaultsType.profession.rawValue) ?? "...")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .baselineOffset(-1.5)
                }
            }
        }
        .padding(.vertical, 2)
        .background(NavigationLink("", destination: { EditProfileView() }).opacity(0))
    }
}

// MARK: PREVIEWS
struct ProfileBasicInfoView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView{
                List{
                    Section {
                        ProfileBasicInfoView()
                            .preferredColorScheme(.dark)
                    }
                }
                .listStyle(.grouped)
                .navigationTitle("Settings")
            }
            
            NavigationView{
                List{
                    Section {
                        ProfileBasicInfoView()
                    }
                }
                .listStyle(.grouped)
                .navigationTitle("Settings")
            }
        }
        .environmentObject(SettingsViewModel())
        .environmentObject(ColorTheme())
        .environmentObject(ProfileBasicInfoViewModel())
    }
}
