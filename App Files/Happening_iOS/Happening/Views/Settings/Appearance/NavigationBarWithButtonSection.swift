//
//  NavigationBarWithButtonSection.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-01-05.
//

import SwiftUI

struct NavigationBarWithButtonSection: View {
    
    // MARK: PROPERTIES
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var color: ColorTheme
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @EnvironmentObject var profileBasicInfoViewModel: ProfileBasicInfoViewModel
    
    // reference to UserDefaults
    let defaults = UserDefaults.standard
    
    // MARK: BODY
    var body: some View {
        Section {
            HStack {
                Image(systemName: "chevron.left")
                    .font(Font.title3.weight(.medium))
                    .foregroundColor(color.accentColor)
                
                if let data = defaults.data(forKey: profileBasicInfoViewModel.profilePhotoUserDefaultsKeyName) {
                    Image(uiImage: UIImage(data: data)!)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 38, height: 38)
                        .clipShape(Circle())
                        .padding(.leading, 8)
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 38, height: 38)
                        .clipShape(Circle())
                        .padding(.leading, 8)
                }
                
                VStack(alignment: .leading, spacing: 0){
                    Text(defaults.string(forKey: ProfileBasicInfoViewModel.ProfileBasicInfoUserDefaultsType.userName.rawValue) ?? "User Name")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                    
                    HStack(spacing: 4) {
                        Text("following")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        
                        Circle()
                            .fill(Color.green)
                            .frame(width: 7)
                            .padding(.top, 2)
                    }
                }
                
                Spacer()
                
                Image(systemName: "bubble.left.and.bubble.right")
                    .font(Font.headline.weight(.medium))
                    .foregroundColor(color.accentColor)
                
                Image(systemName: "phone")
                    .font(Font.headline.weight(.medium))
                    .foregroundColor(color.accentColor)
                    .padding(.leading, 8)
                    .padding(.trailing, 4)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .padding(.horizontal, 10)
            .background(colorScheme == .light ? Color.white : Color.black)
            .previewLayout(.sizeThatFits)
        } header: {
            Text("Sample Navigation Bar")
                .font(.footnote)
        }
    }
}

// MARK: PREVIEWS
struct NavigationBarWithButtonSection_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                List {
                    NavigationBarWithButtonSection()
                        .preferredColorScheme(.dark)
                }
            }
            
            NavigationView {
                List {
                    NavigationBarWithButtonSection()
                }
            }
        }
        .listStyle(.grouped)
        .environmentObject(ColorTheme())
        .environmentObject(SettingsViewModel())
        .environmentObject(ProfileBasicInfoViewModel())
    }
}
