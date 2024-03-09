//
//  AccountView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-02-26.
//

import SwiftUI

struct AccountView: View {
    
    // MARK: BODY
    var body: some View {
        List {
            Section {
                NavigationLink("Privacy") {
                    PrivacyView()
                }
            }
        }
        .listStyle(.grouped)
        .navigationTitle(Text("Account"))
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: PREVIEWS
struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                AccountView()
                    .preferredColorScheme(.dark)
            }
            
            NavigationView {
                AccountView()
            }
        }
        .environmentObject(FaceIDAuthentication())
    }
}
