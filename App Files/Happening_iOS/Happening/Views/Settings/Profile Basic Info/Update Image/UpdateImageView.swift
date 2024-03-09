//
//  UpdateImageView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-12-29.
//

import SwiftUI

struct UpdateImageView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var color: ColorTheme
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @EnvironmentObject var profileBasicInfoViewModel: ProfileBasicInfoViewModel
    @EnvironmentObject var updateProfilePhotoViewModel: UpdateProfilePhotoViewModel
    
    let defaults = UserDefaults.standard
    
    
    // MARK: BODY
    var body: some View {
        ScrollView(showsIndicators: false) {
            if let data = defaults.data(forKey: profileBasicInfoViewModel.profilePhotoUserDefaultsKeyName) {
                Image(uiImage: UIImage(data: data)!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width)
                    .clipped()
                    .padding(.vertical)
                    .padding(.top)
            } else {
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width)
                    .overlay(
                        ProgressView()
                            .tint(.secondary)
                    )
                    .padding(.vertical)
                    .padding(.top)
            }
            
            UploadGuidlinesView()
        }
        .navigationTitle(Text("Profile Photo"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    // code here
                    updateProfilePhotoViewModel.isPresentedEditImageConfirmationDialog = true
                } label: {
                    Text("Edit")
                        .font(.body.weight(.semibold))
                }
                .sheet(isPresented: $updateProfilePhotoViewModel.isPresentedEditImageSheet) {
                    updateProfilePhotoViewModel.resetUploadImageSheetView()
                } content: { UploadImageSheetView() }
            }
        }
        .fullScreenCover(isPresented: $updateProfilePhotoViewModel.isPresentedEditImageFullCoverSheet) {
            ZStack {
                ImagePicker(image: $updateProfilePhotoViewModel.theImageThatNeedsToBeApproved,
                            imageErrorAlert: $updateProfilePhotoViewModel.isPresentedErrorAlert,
                            isPresentedPhotoLibrary: $updateProfilePhotoViewModel.isPresentedPhotoLibrary,
                            isAddedSuccessful: $updateProfilePhotoViewModel.isAddedSuccessfulTemporaryImage,
                            isPresentedCameraSheet: $updateProfilePhotoViewModel.isPresentedCameraSheet
                )
            }
            .dynamicTypeSize(.large)
            .edgesIgnoringSafeArea(.all)
        }
        .confirmationDialog(Text(""), isPresented: $updateProfilePhotoViewModel.isPresentedEditImageConfirmationDialog) {
            Button("Take Photo") {
                updateProfilePhotoViewModel.openPhotoOrCameraPicker(selction: .camera)
            }
            
            Button("Choose Photo") {
                updateProfilePhotoViewModel.openPhotoOrCameraPicker(selction: .photo)
            }
            
            Button("Save Photo") {
                updateProfilePhotoViewModel.savePhotoToPhotoLibrary()
            }
        }
        
    }
}

// MARK: PREVIEWS
struct UpdateImageView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                UpdateImageView()
                    .preferredColorScheme(.dark)
            }
            
            NavigationView {
                UpdateImageView()
            }
        }
        .environmentObject(ColorTheme())
        .environmentObject(SettingsViewModel())
        .environmentObject(ProfileBasicInfoViewModel())
        .environmentObject(UpdateProfilePhotoViewModel())
    }
}
