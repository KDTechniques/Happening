//
//  QRCodeView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-01-04.
//

import SwiftUI

struct QRCodeCardView: View {
    
    // MARK: PROPERTIES
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var qrCodeViewModel: QRCodeViewModel
    
    // reference to ProfileBasicInfoViewModel
    let profileBasicInfoViewModel =  ProfileBasicInfoViewModel.shared
    
    // reference to UserDefaults
    let defaults = UserDefaults.standard
    
    // controls the background color to be dynamic or static for different contexts
    @Binding var backgroundColorType: QRCodeViewModel.QRCodeCardBackgroundColorType
    
    // MARK: BODY
    var body: some View {
        VStack(spacing: 3) {
            // profile photo on top of the card view
            if let data = defaults.data(forKey: profileBasicInfoViewModel.profilePhotoUserDefaultsKeyName) {
                Image(uiImage: UIImage(data: data)!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .padding(3)
                    .background(
                        Circle()
                            .fill(backgroundColorType == .dynamicColor
                                  ? colorScheme == .light ? .white
                                  : Color(UIColor.secondarySystemBackground) : .white)
                    )
            } else {
                ProgressView()
                    .tint(.secondary)
                    .frame(width: 50, height: 50)
                    .padding(3)
                    .background(
                        Circle()
                            .fill(backgroundColorType == .dynamicColor
                                  ? colorScheme == .light ? .white
                                  : Color(UIColor.secondarySystemBackground) : .white)
                            .overlay(
                                Circle()
                                    .fill(.ultraThinMaterial)
                                    .frame(width: 40, height: 40)
                            )
                    )
            }
            
            // user name
            Text(defaults.string(forKey: ProfileBasicInfoViewModel.ProfileBasicInfoUserDefaultsType.userName.rawValue) ?? "...")
                .font(.headline.weight(.medium))
                .foregroundColor(backgroundColorType == .dynamicColor ? .primary : .black)
            
            Text("Happening Creator")
                .font(.footnote)
                .foregroundColor(Color(UIColor.systemGray2))
                .padding(.bottom)
            
            HStack {
                Spacer()
                // once a qrcode is generated, it'll will be displayed here
                if(QRCodeViewModel.shared.generatedQRCodeImage == nil) {
                    ProgressView()
                        .tint(.secondary)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(.ultraThinMaterial)
                                .frame(width: 210, height: 210)
                        )
                        .frame(width: 210, height: 210)
                } else {
                    Image(uiImage: QRCodeViewModel.shared.generatedQRCodeImage!)
                        .resizable()
                        .scaledToFit()
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                    // logo icon goes on top of the qr code to provide authenticity and to make it more identifiable
                        .overlay(alignment: .center) {
                            Image("LogoIcon")
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40)
                                .foregroundColor(.black)
                                .background(
                                    Rectangle()
                                        .fill(Color.white)
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                )
                        }
                        .frame(width: 210, height: 210)
                }
                
                Spacer()
            }
        }
        .offset(x: 0, y: -25)
        .frame(width: UIScreen.main.bounds.size.width - 70, height: UIScreen.main.bounds.size.width - 70)
        .background(backgroundColorType == .dynamicColor
                    ? Color(colorScheme == .light
                            ? .white
                            : UIColor.secondarySystemBackground)
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0), radius: 20, x: 0, y: 10)
                    : Color.white
                        .cornerRadius(15)
                    // shadow will be applied on when the back ground color is static
                        .shadow(color: Color.black.opacity(0.4), radius: 20, x: 0, y: 10)
        )
    }
}

// MARK: PREVIEWS
struct QRCodeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                QRCodeCardView(backgroundColorType: Binding.constant(.dynamicColor))
                    .preferredColorScheme(.dark)
                    .navigationTitle(Text("QR Code"))
                    .navigationBarTitleDisplayMode(.inline)
            }
            
            NavigationView {
                QRCodeCardView(backgroundColorType: Binding.constant(.dynamicColor))
                    .navigationTitle(Text("QR Code"))
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
        .environmentObject(QRCodeViewModel())
    }
}
