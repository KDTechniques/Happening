//
//  PrivacyView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-02-26.
//

import SwiftUI

struct PrivacyView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var blockedUsersVM: BlockedUsersViewModel
    @EnvironmentObject var settingsVM: SettingsViewModel
    
    // MARK: BODY
    var body: some View {
        List {
            Section {
                NavigationLink("Screen Lock") {
                    ScreenLockView()
                }
            } footer: {
                Text("Require \(bioMetricIdentifier()) to unlock Happening.")
            }
            
            Section {
                NavigationLink(destination: { BlockedUsersListView() }) {
                    Text("Blocked")
                        .badge(blockedUsersVM.numberOfBlockedUsers)
                }
            } footer: {
                Text("List of users you have blocked.")
            }
            
            Section {
                Button("Sign Out") {
                    settingsVM.isPresentedSignoutActionSheet = true
                }
                .foregroundColor(.red)
            }
            .actionSheet(isPresented: $settingsVM.isPresentedSignoutActionSheet) {
                ActionSheet(
                    title: Text("Are you sure you want to sign out?"),
                    message: Text("We do not recommend you sign out if you have pending happenings to complete."),
                    buttons: [
                        .destructive(Text("Confirm Sign Out")) {
                            CurrentUser.shared.signOutUser()
                        },
                        .cancel()
                    ]
                )
            }
        }
        .listStyle(.grouped)
        .navigationTitle(Text("Privacy"))
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            blockedUsersVM.getBlockedUsersFromFirestore { _ in }
        }
    }
}

// MARK: PREVIEWS
struct PrivacyView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                PrivacyView()
                    .preferredColorScheme(.dark)
            }
            
            NavigationView {
                PrivacyView()
            }
        }
        .environmentObject(ColorTheme())
        .environmentObject(BlockedUsersViewModel())
        .environmentObject(FaceIDAuthentication())
        .environmentObject(NetworkManger())
        .environmentObject(SettingsViewModel())
    }
}
