//
//  ScanQRCodeImageSheetView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-01-04.
//

import SwiftUI

struct ScanQRCodeFromImageSheetView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var qrCodeVM: QRCodeViewModel
    @EnvironmentObject var publicProfileInfoVM: PublicProfileInfoViewModel
    @EnvironmentObject var networkManager: NetworkManger
    
    @Binding var QRCodeImage: UIImage?
    @Binding var isPresentedQRCodeImageSheet: Bool
    
    // MARK: BODY
    var body: some View {
        // this image will appear on a fill scale sheet that egnores all the edges
        Image(uiImage: QRCodeImage!)
            .resizable()
            .scaledToFill()
            .frame(maxWidth: UIScreen.main.bounds.size.width)
            .edgesIgnoringSafeArea(.all)
        // sheet will only appear when user select an image from the photo library
        // so once the sheet is appeared we have to scan the image and let the user know whether it has a valid qr code in the image or not
            .onAppear {
                if let features = qrCodeVM.readQRCodeFromImage(QRCodeImage), !features.isEmpty{
                    for case let row as CIQRCodeFeature in features {
                        if(row.messageString!.contains(qrCodeVM.happeningQRIdentityData)) {
                            print("Valid QR code found!\nQR Code Data: \(row.messageString ?? "nil")")
                            
                            qrCodeVM.scannedQRCodeText = row.messageString ?? "nil"
                            
                            if(networkManager.connectionStatus == .connected) {
                                isPresentedQRCodeImageSheet = false
                                
                                publicProfileInfoVM.followUserByQRCode(privateQRCodeData: qrCodeVM.scannedQRCodeText)
                                
                                qrCodeVM.isPresentedSheetForFollowingUsers = true
                            } else {
                                qrCodeVM.alertItemForQRCodeFromImageSheetView = AlertItemModel(
                                    title: "Couldn't Scan",
                                    message: "Please check your phone's connection.",
                                    dismissButton: .cancel(Text("OK")) {
                                        isPresentedQRCodeImageSheet = false
                                    }
                                )
                            }
                        } else {
                            qrCodeVM.alertItemForQRCodeFromImageSheetView = AlertItemModel(
                                title: "Invalid QR Code",
                                message: "Please scan a valid QR code.",
                                dismissButton: .cancel(Text("OK")) {
                                    isPresentedQRCodeImageSheet = false
                                }
                            )
                        }
                    }
                } else {
                    qrCodeVM.alertItemForQRCodeFromImageSheetView = AlertItemModel(
                        title: "No QR Code Found",
                        message: "Please scan a valid QR code.",
                        dismissButton: .cancel(Text("OK")) {
                            isPresentedQRCodeImageSheet = false
                        }
                    )
                }
            }
            .alert(item: $qrCodeVM.alertItemForQRCodeFromImageSheetView) { alert -> Alert in
                Alert(
                    title: Text(alert.title),
                    message: Text(alert.message),
                    dismissButton: alert.dismissButton
                )
            }
    }
}

// MARK: PREVIEWS
struct ScanQRCodeImageSheetView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ScanQRCodeFromImageSheetView(QRCodeImage: Binding.constant(UIImage(named: "QRCodeError")!),
                                         isPresentedQRCodeImageSheet: Binding.constant(false))
                .preferredColorScheme(.dark)
            
            ScanQRCodeFromImageSheetView(QRCodeImage: Binding.constant(UIImage(named: "QRCodeError")!),
                                         isPresentedQRCodeImageSheet: Binding.constant(false))
        }
        .environmentObject(QRCodeViewModel())
        .environmentObject(PublicProfileInfoViewModel())
    }
}
