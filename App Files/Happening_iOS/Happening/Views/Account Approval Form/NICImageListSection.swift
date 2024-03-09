//
//  NICImageListSection.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-12-24.
//

import SwiftUI

struct NICImageListSection: View {
    
    //MARK: PROPERTIES
    @EnvironmentObject var approvalFormViewModel: ApprovalFormViewModel
    
    // MARK: BODY
    var body: some View {
        NavigationLink {
            List {
                // front side section
                Section {
                    NICImageView(image: $approvalFormViewModel.formData.nicFrontImage,
                                 isAlertPresented: $approvalFormViewModel.isPresentedNICImageAlert,
                                 isPresentedPhotoLibrary: $approvalFormViewModel.isPresentedPhotoLibrary,
                                 isAddedSuccessful: $approvalFormViewModel.isAddedFrontImage,
                                 isPresenetedCameraSheet: $approvalFormViewModel.isPresenetedCameraSheet,
                                 showImagePicker: $approvalFormViewModel.showImagePicker1
                    )
                } header: {
                    Text("Front Side")
                        .font(.footnote)
                }
                // back side section
                Section {
                    NICImageView(image: $approvalFormViewModel.formData.nicBackImage,
                                 isAlertPresented: $approvalFormViewModel.isPresentedNICImageAlert,
                                 isPresentedPhotoLibrary: $approvalFormViewModel.isPresentedPhotoLibrary,
                                 isAddedSuccessful: $approvalFormViewModel.isAddedBackImage,
                                 isPresenetedCameraSheet: $approvalFormViewModel.isPresenetedCameraSheet,
                                 showImagePicker: $approvalFormViewModel.showImagePicker2
                    )
                } header: {
                    Text("Back Side")
                        .font(.footnote)
                }
            }
            .toolbar(content: {
                ToolbarItem(placement: .principal) { Text("National Identity Card Photo").fontWeight(.semibold) }
            })
        } label: {
            HStack {
                Text("Upload National Identity Card Photo")
                    .foregroundColor(approvalFormViewModel.isAddedFrontImage && approvalFormViewModel.isAddedBackImage ? .primary : Color.accentColor)
                Spacer()
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(approvalFormViewModel.isAddedFrontImage && approvalFormViewModel.isAddedBackImage ? .green : Color(UIColor.systemGray3))
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: PREVIEW
struct NICImageListSection_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                Form {
                    Section{
                        NICImageListSection()
                            .preferredColorScheme(.dark)
                    } header: {
                        Text("Authenticity Verification")
                            .font(.footnote)
                    } footer: {
                        Text("*required")
                            .font(.footnote)
                    }
                }
            }
            
            NavigationView {
                Form {
                    Section{
                        NICImageListSection()
                    } header: {
                        Text("Authenticity Verification")
                            .font(.footnote)
                    } footer: {
                        Text("*required")
                            .font(.footnote)
                    }
                }
            }
        }
        .environmentObject(ApprovalFormViewModel())
    }
}

// MARK: SUBVIEW
struct NICImageView: View {
    
    //MARK: PROPERTIES
    @Binding var image: UIImage?
    @Binding var isAlertPresented: Bool
    @Binding var isPresentedPhotoLibrary: Bool
    @Binding var isAddedSuccessful: Bool
    @Binding var isPresenetedCameraSheet: Bool
    @Binding var showImagePicker: Bool
    
    // MARK: BODY
    var body: some View {
        VStack {
            Image(uiImage: image!)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .padding(.top)
                .overlay {
                    Text("SAMPLE")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .kerning(1)
                        .foregroundColor(Color.black.opacity(0.5))
                        .opacity(isAddedSuccessful ? 0 : 1)
                        .padding(.top)
                }
            
            Button("Upload Photo") {
                self.showImagePicker = true
            }
            .padding()
            .font(.body.weight(.semibold))
            .frame(maxWidth: .infinity)
        }
        .fullScreenCover(isPresented: $showImagePicker) {
            ZStack {
                ImagePicker(image: $image,
                            imageErrorAlert: $isAlertPresented,
                            isPresentedPhotoLibrary: $isPresentedPhotoLibrary,
                            isAddedSuccessful: $isAddedSuccessful,
                            isPresentedCameraSheet: $isPresenetedCameraSheet)
                
                HStack {
                    if(!isPresentedPhotoLibrary) { // camera
                        Button(action: {
                            showImagePicker = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                isPresentedPhotoLibrary = true
                                showImagePicker = true
                            }
                        }, label: {
                            Image(systemName: "photo.circle.fill")
                                .font(.system(size: 40))
                                .foregroundColor(Color.white)
                                .background(Circle().fill(.ultraThinMaterial).opacity(0.5))
                        })
                    }
                    
                    Spacer()
                }
                .padding(.leading, 12)
            }
            .dynamicTypeSize(.large)
            .edgesIgnoringSafeArea(.all)
        }
    }
}
