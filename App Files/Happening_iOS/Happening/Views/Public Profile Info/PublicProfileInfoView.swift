//
//  PublicProfileOverView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-03-15.
//

import SwiftUI
import SDWebImageSwiftUI

struct PublicProfileInfoView: View {
    
    // MARK: PROPERTIES
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var color: ColorTheme
    @EnvironmentObject var publicProfileInfoVM: PublicProfileInfoViewModel
    @EnvironmentObject var qrCodeVM: QRCodeViewModel
    @EnvironmentObject var networkManager: NetworkManger
    
    let screenWidth: CGFloat = UIScreen.main.bounds.size.width
    
    let item: PublicProfileInfoModel
    
    @State var amIFollowingQRCodeUser: Bool?
    
    // MARK: BODY
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // profile picture
                WebImage(url: URL(string: item.profilePhotoThumbnailURL))
                    .resizable()
                    .placeholder {
                        Rectangle()
                            .fill(.ultraThinMaterial)
                    }
                    .indicator(.activity)
                    .scaledToFill()
                    .frame(width: screenWidth, height: screenWidth)
                    .clipped()
                
                Divider()
                
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.userName)
                            .fontWeight(.medium)
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Text(item.about)
                            .font(.subheadline.weight(.medium))
                            .lineLimit(2)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Text(item.profession)
                            .font(.footnote.weight(.medium))
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Button {
                        if(networkManager.connectionStatus == .connected) {
                            publicProfileInfoVM.FollowUnfollowDeterminer(qrCodeUserUID: item.id, amIFollowingQRCodeUser: amIFollowingQRCodeUser ?? item.amIFollowingQRCodeUser) { status in
                                if(status) {
                                    amIFollowingQRCodeUser?.toggle()
                                }
                            }
                            publicProfileInfoVM.followingUnfollowingProgressView = true
                        } else {
                            qrCodeVM.isPresentedAlertItemForPublicProfileInfoSheet = AlertItemModel(
                                title: "Couldn't Follow/Unfollow",
                                message: "Please check your phone's connection.",
                                dismissButton: .cancel(Text("OK")){ publicProfileInfoVM.followingUnfollowingProgressView = false }
                            )
                        }
                    } label: {
                        HStack {
                            ProgressView()
                                .tint(.secondary)
                                .opacity(publicProfileInfoVM.followingUnfollowingProgressView ? 1 : 0)
                                .scaleEffect(0.8)
                                .padding(.trailing, 1)
                            
                            Text(amIFollowingQRCodeUser ?? item.amIFollowingQRCodeUser ? "Following" : item.isQrCodeUserFollowingMe  ? "Follow back" : "Follow")
                                .font(.subheadline.weight(.medium))
                                .foregroundColor(.white)
                                .padding(.vertical, 8)
                                .frame(width: 120)
                                .background(ColorTheme.shared.accentColor)
                                .cornerRadius(5)
                        }
                        .frame(width: 160, alignment: .trailing)
                    }
                    .disabled(publicProfileInfoVM.followingUnfollowingProgressView)
                    
                }
                .padding(20)
                .background(colorScheme == .dark ? Color(UIColor.secondarySystemBackground) : .white)
                
                Divider()
                
                List {
                    Section {
                        HStack {
                            HStack(spacing: 14) {
                                Image(systemName: "star.leadinghalf.filled")
                                    .font(.subheadline)
                                    .frame(width: 28, height: 28)
                                    .background(Color.yellow)
                                    .cornerRadius(6)
                                    .foregroundColor(.white)
                                
                                Text("Ratings")
                            }
                            
                            Spacer()
                            
                            HStack {
                                ForEach(1...Int(item.ratings), id: \.self) { _ in
                                    Image(systemName: "star.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 14)
                                        .foregroundColor(.yellow)
                                }
                                
                                if (item.ratings - floor(item.ratings) > 0.000001) {
                                    Image(systemName: "star.leadinghalf.filled")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 14)
                                        .foregroundColor(.yellow)
                                }
                                
                                Text(String(format: "%.1f", item.ratings))
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        HStack {
                            HStack(spacing: 14) {
                                Image(systemName: "building.2.fill")
                                    .font(.subheadline)
                                    .frame(width: 28, height: 28)
                                    .background(Color.blue)
                                    .cornerRadius(6)
                                    .foregroundColor(.white)
                                
                                Text("City")
                            }
                            
                            Spacer()
                            
                            Text(item.city)
                                .foregroundColor(.secondary)
                        }
                        
                        HStack {
                            HStack(spacing: 14) {
                                Image(systemName: "person.fill")
                                    .font(.subheadline)
                                    .frame(width: 28, height: 28)
                                    .background(Color.orange)
                                    .cornerRadius(6)
                                    .foregroundColor(.white)
                                
                                Text("Full Name")
                            }
                            
                            Spacer()
                            
                            Text(item.fullName)
                                .multilineTextAlignment(.trailing)
                                .foregroundColor(.secondary)
                                .frame(width: 200, alignment: .trailing)
                        }
                        
                        HStack {
                            HStack(spacing: 14) {
                                Image(systemName: "person.fill")
                                    .font(.subheadline)
                                    .frame(width: 28, height: 28)
                                    .background(Color.green)
                                    .cornerRadius(6)
                                    .foregroundColor(.white)
                                
                                Text("Age")
                            }
                            
                            Spacer()
                            
                            Text(item.age)
                                .foregroundColor(.secondary)
                        }
                        
                        HStack {
                            HStack(spacing: 14) {
                                Image(systemName: "person.fill")
                                    .font(.subheadline)
                                    .frame(width: 28, height: 28)
                                    .background(Color.indigo)
                                    .cornerRadius(6)
                                    .foregroundColor(.white)
                                
                                Text("Gender")
                            }
                            
                            Spacer()
                            
                            Text(item.gender)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Section {
                        NavigationLink {
                            // past happenings view goes here...
                        } label: {
                            HStack(spacing: 14) {
                                Image(systemName: "clock.arrow.circlepath")
                                    .font(.subheadline)
                                    .frame(width: 28, height: 28)
                                    .background(Color.brown)
                                    .cornerRadius(6)
                                    .foregroundColor(.white)
                                
                                Text("Past Happenings")
                            }
                        }
                        
                        NavigationLink {
                            // ongoing happenings view goes here...
                        } label: {
                            HStack(spacing: 14) {
                                Image(systemName: "clock.arrow.2.circlepath")
                                    .font(.subheadline)
                                    .frame(width: 28, height: 28)
                                    .background(Color.teal)
                                    .cornerRadius(6)
                                    .foregroundColor(.white)
                                
                                Text("Ongoing Happenings")
                            }
                        }
                    } header: {
                        Text("Happenings")
                            .font(.footnote)
                    }
                }
                .listStyle(.grouped)
            }
            .padding(.top)
            .navigationBarHidden(true)
            .onAppear {
                amIFollowingQRCodeUser = item.amIFollowingQRCodeUser
            }
            .onDisappear {
                publicProfileInfoVM.publicProfileInfoDataObject = nil
            }
            .alert(item: $publicProfileInfoVM.alertItemForPublicProfileInfoView) { alert -> Alert in
                Alert(
                    title: Text(alert.title),
                    message: Text(alert.message),
                    dismissButton: alert.dismissButton)
            }
        }
    }
}

// MARK: PREVIEWS
//struct PublicProfileOverView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            PublicProfileInfoView()
//                .preferredColorScheme(.dark)
//
//            PublicProfileInfoView()
//        }
//        .environmentObject(ColorTheme())
//        .environmentObject(QRCodeViewModel())
//        .environmentObject(NetworkManger())
//    }
//}
