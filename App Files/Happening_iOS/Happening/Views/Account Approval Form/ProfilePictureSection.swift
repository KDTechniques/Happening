//
//  ProfilePictureSection.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-12-25.
//

import SwiftUI

struct ProfilePictureSection: View {
    
    //MARK: PROPERTIES
    @EnvironmentObject var approvalFormViewModel: ApprovalFormViewModel
    
    let rect = CGRect(x: 0,
                      y: 0,
                      width: UIScreen.main.bounds.size.width - 100,
                      height: UIScreen.main.bounds.size.width - 100
    )
    let screenWidth:CGFloat = UIScreen.main.bounds.size.width - 100
    
    // MARK: BODY
    var body: some View {
        NavigationLink {
            List {
                Section {
                    VStack {
                        if let image = approvalFormViewModel.formData.profileImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: rect.width, height: rect.height)
                                .clipped()
                                .overlay(
                                    Rectangle()
                                        .fill(.black.opacity(0.6))
                                        .frame(width: rect.width, height: rect.height)
                                        .mask(HoleShapeMask(in: rect).fill(style: FillStyle(eoFill: true)))
                                )
                                .padding(.top)
                        }
                        
                        Button("Upload Photo") {
                            approvalFormViewModel.showImagePicker3 = true
                        }
                        .padding()
                        .font(.body.weight(.semibold))
                        .frame(maxWidth: .infinity)
                    }
                    .fullScreenCover(isPresented: $approvalFormViewModel.showImagePicker3) {
                        ZStack {
                            ImagePicker(image: $approvalFormViewModel.formData.profileImage,
                                        imageErrorAlert: $approvalFormViewModel.isPresentedProfilePictureAlert,
                                        isPresentedPhotoLibrary: $approvalFormViewModel.isPresentedPhotoLibrary,
                                        isAddedSuccessful: $approvalFormViewModel.isAddedProfileImage,
                                        isPresentedCameraSheet: $approvalFormViewModel.isPresenetedCameraSheet
                            )
                            
                            HStack {
                                if(!approvalFormViewModel.isPresentedPhotoLibrary) {
                                    Button(action: {
                                        approvalFormViewModel.showImagePicker3 = false
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                            approvalFormViewModel.isPresentedPhotoLibrary = true
                                            approvalFormViewModel.showImagePicker3 = true
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
                } footer: {
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Note:")
                                .fontWeight(.semibold)
                            
                            Text("This photo will be used as the profile photo for your account.")
                                .padding(.top, 5)
                            
                            Text("The Happening will compare this photo with your NIC photo for authenticity and security reasons.")
                            
                            Text("You will need the Happening approval to update your profile photo in the future.")
                        }
                        .foregroundColor(.secondary)
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Do's:")
                                .fontWeight(.semibold)
                            
                            Text("Must provide an authentic photo of yourself. It may speed up your account approval process.")
                                .padding(.top, 5)
                            
                            Text("Your face must be seen in the photo properly.")
                        }
                        .foregroundColor(.primary)
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Don'ts:")
                                .fontWeight(.semibold)
                            
                            Text("Group photos are not allowed.")
                                .padding(.top, 5)
                            
                            Text("Full body photo poses are allowed but can't cover your face with any type of object or body part except spectacle glasses.")
                            
                            Text("Any sexual or improper photo may ban your account.")
                        }
                        .foregroundColor(.red)
                    }
                }
                .font(.footnote)
                .fixedSize(horizontal: false, vertical: true)
            }
            .toolbar(content: {
                ToolbarItem(placement: .principal) { Text("Profile Photo").fontWeight(.semibold) }
            })
        } label: {
            HStack {
                Text("Upload Profile Photo")
                    .foregroundColor(approvalFormViewModel.isAddedProfileImage ? .primary : Color.accentColor)
                Spacer()
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(approvalFormViewModel.isAddedProfileImage ? .green : Color(UIColor.systemGray3))
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}


// MARK: PREVIEW
struct ProfilePictureSection_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                Form {
                    Section{
                        ProfilePictureSection()
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
                        ProfilePictureSection()
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
