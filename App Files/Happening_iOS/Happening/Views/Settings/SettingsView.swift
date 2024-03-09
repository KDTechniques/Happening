//
//  SettingsView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-11-12.
//

import SwiftUI

struct SettingsView: View {
    
    // MARK: PROPERTIES
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var color: ColorTheme
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @EnvironmentObject var themeColorPickerViewModel: ThemeColorPickerViewModel
    @EnvironmentObject var networkManager: NetworkManger
    
    // refernce to ApprovalFormViewModel class environment object
    let approvalFormViewModel = ApprovalFormViewModel.shared
    
    // MARK: BODY
    var body: some View {
        NavigationView {
            List {
                // profile basic info
                Section {
                    ProfileBasicInfoView()
                }
                
                Section {
                    // my followers
                    MyFollowers()
                    
                    // my followings
                    MyFollowings()
                    
                    // my qr code
                    NavigationLink(destination: { MyQRCodeView() }) {
                        HStack(spacing: 14) {
                            Image(systemName: "qrcode")
                                .font(.subheadline)
                                .frame(width: settingsViewModel.iconWidthHeight, height: settingsViewModel.iconWidthHeight)
                                .background(Color.primary)
                                .cornerRadius(6.0)
                                .foregroundColor(colorScheme == .light ? Color.white : Color.black)
                            
                            Text("My QR Code")
                        }
                    }
                }
                
                Section {
                    // account
                    NavigationLink(destination: { AccountView() }) {
                        HStack(spacing: 14) {
                            Image(systemName: "person.crop.circle.fill")
                                .font(.subheadline)
                                .frame(width: settingsViewModel.iconWidthHeight, height: settingsViewModel.iconWidthHeight)
                                .background(Color.blue)
                                .cornerRadius(6.0)
                                .foregroundColor(.white)
                            
                            Text("Account")
                        }
                    }
                    
                    // messages
                    NavigationLink(destination: {Text("Message View")}) {
                        HStack(spacing: 14) {
                            Image(systemName: "bubble.left.and.bubble.right.fill")
                                .font(.footnote)
                                .frame(width: settingsViewModel.iconWidthHeight, height: settingsViewModel.iconWidthHeight)
                                .background(Color.green)
                                .cornerRadius(6.0)
                                .foregroundColor(.white)
                            
                            Text("Messages")
                        }
                    }
                    
                    // notifications
                    NavigationLink(destination: {Text("Notifications View")}) {
                        HStack(spacing: 14) {
                            Image(systemName: "bell.badge.fill")
                                .font(.subheadline)
                                .frame(width: settingsViewModel.iconWidthHeight, height: settingsViewModel.iconWidthHeight)
                                .background(Color.red)
                                .cornerRadius(6.0)
                                .foregroundColor(.white)
                            
                            Text("Notifications")
                        }
                    }
                    
                    // appearance
                    NavigationLink(destination: {AppearanceView()}) {
                        HStack(spacing: 14) {
                            Image(systemName: "eye.fill")
                                .font(.footnote)
                                .frame(width: settingsViewModel.iconWidthHeight, height: settingsViewModel.iconWidthHeight)
                                .background(Color.indigo)
                                .cornerRadius(6.0)
                                .foregroundColor(.white)
                            
                            Text("Appearance")
                        }
                    }
                }
                
                Section {
                    // send feedback
                    HStack(spacing: 14) {
                        Image(systemName: "exclamationmark.bubble.fill")
                            .font(.subheadline)
                            .frame(width: settingsViewModel.iconWidthHeight, height: settingsViewModel.iconWidthHeight)
                            .background(Color.purple)
                            .cornerRadius(6.0)
                            .foregroundColor(.white)
                        
                        FeedbackSupportView()
                    }
                    
                    // help
                    NavigationLink(destination: {Text("Help")}) {
                        HStack(spacing: 14) {
                            Image(systemName: "questionmark.circle.fill")
                                .font(.subheadline)
                                .frame(width: settingsViewModel.iconWidthHeight, height: settingsViewModel.iconWidthHeight)
                                .background(Color.blue)
                                .cornerRadius(6.0)
                                .foregroundColor(.white)
                            
                            Text("Help")
                        }
                    }
                    
                    // tell a friend
                    NavigationLink(destination: { TellAFriendView() }) {
                        HStack(spacing: 14) {
                            Image(systemName: "heart.fill")
                                .font(.subheadline)
                                .frame(width: settingsViewModel.iconWidthHeight, height: settingsViewModel.iconWidthHeight)
                                .background(Color.pink)
                                .cornerRadius(6.0)
                                .foregroundColor(.white)
                            
                            Text("Tell a Friend")
                        }
                    }
                }
            }
            .listStyle(.grouped)
            .navigationTitle("Settings 🇱🇰")
            .onAppear {
                themeColorPickerViewModel.setThemeColorSelection()
                if(networkManager.connectionStatus == .connected) {
                    MyFollowersFollowingsListViewModel.shared.getFollowersDataFromFirestore()
                    MyFollowersFollowingsListViewModel.shared.getFollowingsDataFromFirestore()
                    
                    ProfileBasicInfoViewModel.shared.getBasicProfileDataFromFirestore { _ in }
                }
            }
        }
    }
}

// MARK: PREVIEW
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SettingsView().preferredColorScheme(.dark)
            SettingsView()
        }
        .environmentObject(ColorTheme())
        .environmentObject(FaceIDAuthentication())
        .environmentObject(SettingsViewModel())
        .environmentObject(ThemeColorPickerViewModel())
        .environmentObject(NetworkManger())
    }
}
