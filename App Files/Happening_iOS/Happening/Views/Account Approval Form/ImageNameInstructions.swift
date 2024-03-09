//
//  ImageNameInstructions.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-12-22.
//

import SwiftUI
import SDWebImageSwiftUI

struct ImageNameInstructions: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var authenticatedUserViewModel: AuthenticatedUserViewModel
    
    // MARK: BODY
    var body: some View {
        VStack {
            if let imageUrlString = authenticatedUserViewModel.userData?.userImage {
                
                WebImage(url: imageUrlString)
                    .resizable()
                    .placeholder {
                        Rectangle()
                            .fill(.ultraThinMaterial)
                    }
                    .indicator(.activity)
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
            }
            
            Text("Hello, \(authenticatedUserViewModel.userData?.userName ?? "User")")
                .font(.title2.weight(.bold))
                .foregroundColor(Color.primary.opacity(0.8))
            
            Text("Please, provide correct information about yourself to get your Happening account approved faster.")
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)
                .font(.subheadline)
                .padding(.horizontal)
                .padding(.vertical, 6)
                .foregroundColor(Color.primary.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom)
        .onAppear {
            if(authenticatedUserViewModel.userData == nil) {
                CurrentUser.shared.signOutUser()
            }
        }
    }
}

// MARK: PREVIEW
struct ImageNameInstructions_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ImageNameInstructions().preferredColorScheme(.dark)
            ImageNameInstructions()
        }
        .environmentObject(AuthenticatedUserViewModel())
    }
}

