//
//  MyFollowings.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-01-02.
//

import SwiftUI

struct MyFollowings: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @EnvironmentObject var MyFollowersFollowingsVM: MyFollowersFollowingsListViewModel
    
    // MARK: BODY
    var body: some View {
        NavigationLink(destination: { FollowerFollowingListView(type: .followings) }) {
            HStack(spacing: 14) {
                Image(systemName: "person.2.fill")
                    .font(.footnote)
                    .frame(width: settingsViewModel.iconWidthHeight, height: settingsViewModel.iconWidthHeight)
                    .background(Color.green)
                    .cornerRadius(6.0)
                    .foregroundColor(Color.white)
                
                Text("My Followings")
            }
            .badge(MyFollowersFollowingsVM.numberOfFollowings)
        }
    }
}

// MARK: PREVIEWS
struct MyFollowings_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView{
                List {
                    Section {
                        MyFollowings()
                            .preferredColorScheme(.dark)
                    }
                }
                .listStyle(.grouped)
                .navigationTitle(Text("Settings"))
            }
            
            NavigationView{
                List {
                    Section {
                        MyFollowings()
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
