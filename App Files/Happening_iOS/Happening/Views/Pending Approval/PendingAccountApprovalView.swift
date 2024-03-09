//
//  PendingAccountApprovalView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-02-21.
//

import SwiftUI

struct PendingAccountApprovalView: View {
    
    @EnvironmentObject var currentUser: CurrentUser
    
    var body: some View {
        VStack {
            Text("Pending Approval")
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .padding(.top, 20)
            
            Spacer()
            
            Image("PendingApprovalImage")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.size.width - 150)
                .padding(.top)
            
            Spacer()
            
            Text("Happening is evaulating your profile")
                .font(.title3.weight(.semibold))
                .padding(.bottom)
            
            VStack(alignment: .leading, spacing: 30) {
                Text("To ensure our community holds up a standard, we don't allow any profiles to get in.")
                
                Text("You will receive a notification email once the profile is approved.")
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: true)
            .padding()
            .padding(.horizontal, 20)
            
            Spacer()
            
            ButtonView(name: "Refresh") {
                currentUser.isExistingUser { _ in }
            }
            
            Spacer()
        }
        .onAppear {
            currentUser.isExistingUser { _ in }
        }
    }
}

struct PendingAccountApprovalView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PendingAccountApprovalView()
            
            PendingAccountApprovalView()
                .preferredColorScheme(.dark)
        }
        .environmentObject(CurrentUser())
        .environmentObject(ColorTheme())
    }
}
