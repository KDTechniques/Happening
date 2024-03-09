//
//  ReservedHappeningSoonInfoToolBarLeadingContentView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-04-03.
//

import SwiftUI
import SDWebImageSwiftUI

struct ReservedHappeningSoonInfoToolBarLeadingContentView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var publicProfileInfoVM: PublicProfileInfoViewModel
    
    let profilePhotoURL: String
    let userName: String
    let ratings: Double
    let userUID: String
    
    @State private var showSheet: Bool = false
    @State private var showAlert: AlertItemModel?
    
    // MARK: BODY
    var body: some View {
        Button {
            showSheet = true
            publicProfileInfoVM.getPublicProfileInfoFromUserUID(userUID: userUID) { status in
                if !status {
                    showSheet = false
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                        showAlert = AlertItemModel(title: "Unable To Get Profile Info", message: "Something went wrong. Please try again later.")
                    }
                }
            }
        } label: {
            // profile picture
            WebImage(url: URL(string: profilePhotoURL))
                .resizable()
                .placeholder {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 38)
                        .foregroundColor(Color(UIColor.systemGray3))
                }
                .indicator(.activity)
                .scaledToFill()
                .frame(width: 38, height: 38, alignment: .center)
                .clipShape(Circle())
            
            // user name
            VStack(alignment: .leading, spacing: 0) {
                Text(userName)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .frame(width: 180, alignment: .leading)
                
                // ratings
                HStack(spacing: 4) {
                    // online indicator
                    Circle()
                        .fill(.green)
                        .frame(width: 8, height: 8)
                        .padding(.leading, 1)
                    
                    // rating stars
                    HStack(spacing: 3) {
                        ForEach(1...Int(ratings), id: \.self) { _ in
                            Image(systemName: "star.fill")
                                .resizable()
                                .scaledToFit()
                        }
                        
                        if (ratings - floor(ratings) > 0.000001) {
                            Image(systemName: "star.leadinghalf.filled")
                                .resizable()
                                .scaledToFit()
                        }
                    }
                    .frame(height: 10)
                    .foregroundColor(.yellow)
                    .padding(.leading, 6)
                }
            }
        }
        .sheet(isPresented: $showSheet) {
            publicProfileInfoVM.publicProfileInfoDataObject = nil
        } content: {
            if let dataObject = publicProfileInfoVM.publicProfileInfoDataObject {
                VStack {
                    Rectangle()
                        .frame(width: 100, height: 4)
                        .cornerRadius(.infinity)
                        .padding(.top, 10)
                    
                    Text("Profile Info")
                        .fontWeight(.semibold)
                        .padding(.top)
                    
                    PublicProfileInfoView(item: dataObject)
                }
            } else {
                VStack {
                    ProgressView()
                        .tint(.secondary)
                    
                    Text("Loading...")
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(.secondary)
                        .padding(.top)
                }
            }
        }
        .alert(item: $showAlert) { alert -> Alert in
            Alert(title: Text(alert.title), message: Text(alert.message), dismissButton: alert.dismissButton)
        }
    }
}