//
//  MyFollowers.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-12-27.
//

import SwiftUI

struct MyFollowers: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @EnvironmentObject var MyFollowersFollowingsVM: MyFollowersFollowingsListViewModel
    
    // MARK: BODY
    var body: some View {
        NavigationLink(destination: { FollowerFollowingListView(type: .followers) }) {
            HStack(spacing: 14) {
                Image(systemName: "person.2.fill")
                    .font(.footnote)
                    .frame(width: settingsViewModel.iconWidthHeight, height: settingsViewModel.iconWidthHeight)
                    .background(Color.orange)
                    .cornerRadius(6.0)
                    .foregroundColor(Color.white)
                
                Text("My Followers")
            }
            .badge(MyFollowersFollowingsVM.numberOfFollowers)
        }
    }
}

// MARK: PREVIEWS
struct MyFollowers_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView{
                List {
                    Section {
                        MyFollowers()
                            .preferredColorScheme(.dark)
                    }
                }
                .listStyle(.grouped)
                .navigationTitle(Text("Settings"))
            }
            
            NavigationView{
                List {
                    Section {
                        MyFollowers()
                    }
                }
                .listStyle(.grouped)
                .navigationTitle(Text("Settings"))
            }
        }
        .environmentObject(SettingsViewModel())
        .environmentObject(MyFollowersFollowingsListViewModel())
    }
}
