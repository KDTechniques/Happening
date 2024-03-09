//
//  MyQRCodeView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-11-24.
//

import SwiftUI

struct MyQRCodeView: View {
    
    // MARK: PROPERTIES
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var color: ColorTheme
    @EnvironmentObject var qrCodeVM: QRCodeViewModel
    @EnvironmentObject var profileBasicInfoViewModel: ProfileBasicInfoViewModel
    @EnvironmentObject var networkManager: NetworkManger
    @EnvironmentObject var publicProfileInfoVM: PublicProfileInfoViewModel
    
    // reference to UserDefaults
    let defaults = UserDefaults.standard
    
    // MARK: BODY
    var body: some View {
        ZStack {
            // background color
            Color(colorScheme == .light ? UIColor.secondarySystemBackground : .black)
                .edgesIgnoringSafeArea(.all)
                .sheet(isPresented: $qrCodeVM.isPresentedQRCodePhotoPicker, content: {
                    PhotoPicker(image: $qrCodeVM.QRCodeImageFromPhotoLibrary,
                                imageErrorAlert: $qrCodeVM.isPresentedQRCodeImageErrorAlert,
                                isAddedSucess: $qrCodeVM.isQRCodeImageAddedSucessful)
                        .dynamicTypeSize(.large)
                })
            
            VStack {
                Spacer()
                
                // card that consist of qr code related data
                QRCodeCardView(backgroundColorType: Binding.constant(.dynamicColor))
                    .sheet(isPresented: $qrCodeVM.isPresentedSheetForFollowingUsers) {
                        qrCodeVM.scannedQRCodeText = ""
                        publicProfileInfoVM.publicProfileInfoDataObject = nil
                    } content: {
                        ZStack {
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
                        .alert(item: $qrCodeVM.isPresentedAlertItemForPublicProfileInfoSheet) { alert -> Alert in
                            Alert(title: Text(alert.title), message: Text(alert.message), dismissButton: alert.dismissButton)
                        }
                    }
                
                Text("Your QR code is private. If you share it with someone, they can scan it with their Happening camera to add you as a follower.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(8)
                    .fixedSize(horizontal: false, vertical: true)
                    .sheet(isPresented: $qrCodeVM.isQRCodeImageAddedSucessful) {
                        qrCodeVM.isQRCodeImageAddedSucessful = false
                    } content: {
                        ScanQRCodeFromImageSheetView(QRCodeImage: $qrCodeVM.QRCodeImageFromPhotoLibrary,
                                                     isPresentedQRCodeImageSheet: $qrCodeVM.isQRCodeImageAddedSucessful)
                            .dynamicTypeSize(.large)
                    }
                
                Button {
                    qrCodeVM.isPresentedQRCodeResetActionSheet = true
                } label: {
                    Text("Reset QR Code")
                        .font(.subheadline)
                }
                .padding(.bottom)
                .actionSheet(isPresented: $qrCodeVM.isPresentedQRCodeResetActionSheet, content: {
                    ActionSheet(title: Text(""), message: Text("Are you sure you want to reset your QR code? If you reset it, your existing QR code and invite link will no longer work."),
                                buttons: [
                                    .destructive(
                                        Text("Reset"),
                                        action: {
                                            if(networkManager.connectionStatus == .connected) {
                                                qrCodeVM.isPresentedResettingProgress = true
                                                qrCodeVM.updatePrivateCodeInFirestore { status, code  in
                                                    if(status) {
                                                        defaults.set(code, forKey: qrCodeVM.privateCodeUserDefaultsKeyName)
                                                        
                                                        qrCodeVM.privateCode = defaults.string(forKey: qrCodeVM.privateCodeUserDefaultsKeyName) ?? ""
                                                        
                                                        qrCodeVM.generatedQRCodeImage = UIImage(data: qrCodeVM.getQRCodeData(text: qrCodeVM.privateCode)!)
                                                        
                                                        qrCodeVM.renderImage()
                                                        
                                                        qrCodeVM.alertItemForMyQRCodeView = AlertItemModel(
                                                            title: "The previous QR code has been reset and a new QR code has been created.",
                                                            message: ""
                                                        )
                                                    }
                                                }
                                            } else {
                                                qrCodeVM.alertItemForMyQRCodeView = AlertItemModel(title: "Couldn't Reset QR Code", message: "Check your phone's connection and try again.")
                                            }
                                        }),
                                    .cancel()
                                ])
                })
                
                Spacer()
                
                ButtonView(name: "Scan", padding: 40) {
                    if(networkManager.connectionStatus == .connected) {
                        qrCodeVM.isPresentedQRCodeScanner = true
                    } else {
                        qrCodeVM.alertItemForMyQRCodeView = AlertItemModel(title: "Couldn't Scan", message: "Please check your phone's connection.")
                    }
                }
                // sheet that will open up the camera and trying to find and scan qr codes
                .sheet(isPresented: $qrCodeVM.isPresentedQRCodeScanner) {
                    ZStack {
                        CodeScannerView(codeTypes: [.qr], simulatedData: "Sample Simulated Data From QR Code Scanner.", completion: qrCodeVM.handleScan)
                        
                        QRCodeScannerOverlappingView()
                    }
                    .dynamicTypeSize(.large)
                    .onDisappear(perform: { qrCodeVM.isQRCodeScannerTorchOn = false })
                    .edgesIgnoringSafeArea(.bottom)
                }
                
                Spacer()
            }
            .padding(.horizontal, 35)
        }
        .alert(item: $qrCodeVM.alertItemForMyQRCodeView, content: { alert -> Alert in
            Alert(
                title: Text(alert.title),
                message: Text(alert.message)
            )
        })
        .onAppear(perform: {
            qrCodeVM.onAppearActions()
        })
        .onDisappear(perform: {
            // toggle is a function in the viewController class
            qrCodeVM.viewController.toggle()
        })
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    if(defaults.data(forKey: profileBasicInfoViewModel.profilePhotoUserDefaultsKeyName) != nil && qrCodeVM.generatedQRCodeImage != nil && defaults.string(forKey: ProfileBasicInfoViewModel.ProfileBasicInfoUserDefaultsType.userName.rawValue) != nil) {
                        qrCodeVM.isPresentedQRCodeShareSheet = true
                    } else {
                        qrCodeVM.alertItemForMyQRCodeView = AlertItemModel(title: "Unable To Share QR Code", message: "Please try again in a moment.")
                    }
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .font(.body.weight(.medium))
                }
            }
            
            ToolbarItem(placement: .principal) {
                if(qrCodeVM.isPresentedResettingProgress) {
                    CustomProgressView1(text: Binding.constant("Resetting..."))
                } else {
                    
                    Text("QR Code")
                        .fontWeight(.semibold)
                }
            }
        }
        .sheet(isPresented: $qrCodeVM.isPresentedQRCodeShareSheet) {
            ShareSheet(activityItems: [qrCodeVM.readyShareImage!]).edgesIgnoringSafeArea(.bottom)
                .dynamicTypeSize(.large)
        }
    }
}

// MARK: PREVIEW
struct MyQRCodeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                MyQRCodeView().preferredColorScheme(.dark)
            }
            NavigationView {
                MyQRCodeView()
            }
        }
        .environmentObject(ColorTheme())
        .environmentObject(QRCodeViewModel())
        .environmentObject(ProfileBasicInfoViewModel())
        .environmentObject(NetworkManger())
        .environmentObject(PublicProfileInfoViewModel())
    }
}
