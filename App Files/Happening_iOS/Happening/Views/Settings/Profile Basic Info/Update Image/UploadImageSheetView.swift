//
//  UploadImageSheetView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-12-29.
//

import SwiftUI

struct UploadImageSheetView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var color: ColorTheme
    @EnvironmentObject var updateProfilePhotoViewModel: UpdateProfilePhotoViewModel
    @EnvironmentObject var networkManager: NetworkManger
    
    let rect = CGRect(x: 0,
                      y: 0,
                      width: UIScreen.main.bounds.size.width,
                      height: UIScreen.main.bounds.size.width
    )
    
    let screenWidth: CGFloat = UIScreen.main.bounds.size.width
    
    // MARK: BODY
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: .infinity)
                .fill(Color.primary.opacity(0.5))
                .frame(width: 80, height: 4)
                .padding(.top, 10)
                .alert(item: $updateProfilePhotoViewModel.alertItem1ForuploadImageSheetView) { alert -> Alert in
                    Alert(
                        title: Text(alert.title),
                        message: Text(alert.message),
                        primaryButton: alert.primaryButton ?? .default(Text("OK")),
                        secondaryButton: alert.dismissButton ?? .cancel(Text("Cancel"))
                    )
                }
            
            Text("New Profile Photo")
                .font(.headline)
                .fontWeight(.semibold)
                .padding()
                .alert(item: $updateProfilePhotoViewModel.alertItem2ForuploadImageSheetView) { alert -> Alert in
                    Alert(
                        title: Text(alert.title),
                        message: Text(alert.message),
                        dismissButton: alert.dismissButton
                    )
                }
            
            Spacer()
            
            if(updateProfilePhotoViewModel.theImageThatNeedsToBeApproved != nil) {
                Image(uiImage: updateProfilePhotoViewModel.theImageThatNeedsToBeApproved!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: screenWidth, height: screenWidth)
                    .clipped()
                    .overlay(
                        Rectangle()
                            .fill(.black.opacity(0.6))
                            .frame(width: rect.width, height: rect.height)
                            .mask(HoleShapeMask(in: rect).fill(style: FillStyle(eoFill: true)))
                    )
            }
            
            Spacer()
            
            ZStack {
                if(updateProfilePhotoViewModel.showUploadButton) {
                    ButtonView(name: "Upload") {
                        updateProfilePhotoViewModel.alertItem1ForuploadImageSheetView = AlertItemModel(
                            title: "Are You Sure?",
                            message: "The image needs to be approved by the Happening and will be updated later.",
                            dismissButton: .cancel(),
                            primaryButton: .default(Text("OK")) {
                                if(networkManager.connectionStatus == .connected) {
                                    updateProfilePhotoViewModel.uploadProfilePhotoToFirestore()
                                } else {
                                    updateProfilePhotoViewModel.alertItem2ForuploadImageSheetView = AlertItemModel(
                                        title: "Couldn't Upload Profile Photo",
                                        message: "Check your phone's connection and try again.",
                                        dismissButton: .cancel(Text("OK")) {
                                            updateProfilePhotoViewModel.isPresentedEditImageSheet = false
                                        }
                                    )
                                }
                            }
                        )
                    }
                    .disabled(!updateProfilePhotoViewModel.isAddedSuccessfulTemporaryImage)
                } else {
                    VStack {
                        if(updateProfilePhotoViewModel.isUploadedCompleted) {
                            HStack {
                                Text("Upload Completed")
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            }
                            .padding(.bottom)
                            
                            Text("We will update your profile photo for you as soon as it's approved.")
                                .multilineTextAlignment(.center)
                                .foregroundColor(.secondary)
                                .font(.footnote)
                            
                            Button("Close") {
                                updateProfilePhotoViewModel.resetUploadImageSheetView()
                            }
                            .padding(.top, 20)
                            .padding(.bottom)
                        } else {
                            ProgressView(value: updateProfilePhotoViewModel.uploadAmount, total: 100)
                            
                            Text("Uploading... \(updateProfilePhotoViewModel.uploadAmount.rounded(), specifier: "%.0f")%")
                                .foregroundColor(.secondary)
                                .font(.footnote)
                                .frame(width: 150, height: 25)
                            
                            Text(updateProfilePhotoViewModel.progressViewText.rawValue)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.secondary)
                                .font(.footnote)
                                .frame(height: 40 ,alignment: .top)
                        }
                    }
                    .padding(.horizontal, 50)
                }
            }
            .frame(height: 150)
            
            Spacer()
        }
    }
}

// MARK: PREVIEWS
struct UploadImageSheetView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            UploadImageSheetView()
                .preferredColorScheme(.dark)
            
            UploadImageSheetView()
        }
        .environmentObject(ColorTheme())
        .environmentObject(NetworkManger())
        .environmentObject(UpdateProfilePhotoViewModel())
    }
}
