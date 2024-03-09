//
//  HappeningPhotosList.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-03-07.
//

import SwiftUI

struct HappeningPhotosList: View {
    
    @EnvironmentObject var createAHappeningVM: CreateAHappeningViewModel
    
    var body: some View {
        List {
            if(!createAHappeningVM.happeningPhotosArray.isEmpty) {
                Section {
                    ForEach(createAHappeningVM.happeningPhotosArray, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 70, height: 50)
                            .clipped()
                            .border(.white, width: 2)
                            .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 0)
                            .overlay(alignment: .leading) {
                                if(createAHappeningVM.happeningPhotosArray[0] == image) {
                                    Text("Main Image")
                                        .font(.footnote)
                                        .fixedSize(horizontal: true, vertical: false)
                                        .offset(x: 80, y: 0)
                                }
                            }
                    }
                    .onDelete(perform: createAHappeningVM.deleteHappeningPhotoListItem)
                    .onMove(perform: createAHappeningVM.moveHappeningPhotoListItem)
                } header: {
                    Text(createAHappeningVM.happeningPhotosArray.isEmpty ? "Add a Photo" : "Add, re-order and delete photos")
                        .font(.footnote)
                }
            }
            
            Section {
                Button {
                    createAHappeningVM.isPresentedAddaPhotoConfirmationDialog = true
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        
                        Text("Add a Photo")
                        
                        Spacer()
                    }
                }
                .disabled(createAHappeningVM.isDisabledAddaPhotoButton)
            } footer: {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Tips:")
                        .font(.footnote.weight(.semibold))
                    
                    Text("Images must be JPG or PNG format (max. 5MB).")
                    
                    Text("The first photo will be your main image. You can drag and drop photos to rearrange the order.")
                    
                    Text("You can download and upload images from the internet if needed.")
                }
                .font(.footnote)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if(!createAHappeningVM.happeningPhotosArray.isEmpty) {
                EditButton()
            }
        }
        .alert(item: $createAHappeningVM.alertItemForHappeningPhotoList, content: { alert -> Alert in
            Alert(title: Text(alert.title), message: Text(alert.message))
        })
        .fullScreenCover(isPresented: $createAHappeningVM.isPresentedAddaPhotoFullCoverSheet) {
            ImagePicker(
                image: $createAHappeningVM.selectedOrTakenPhoto,
                imageErrorAlert: $createAHappeningVM.isPresentedAlertForImageError,
                isPresentedPhotoLibrary: $createAHappeningVM.isPresentedPhotoLibrary,
                isAddedSuccessful: $createAHappeningVM.isImageAddedSuccessful,
                isPresentedCameraSheet: $createAHappeningVM.isPresentedCameraSheet
            )
                .ignoresSafeArea()
        }
        .listStyle(.grouped)
        .confirmationDialog(Text(""), isPresented: $createAHappeningVM.isPresentedAddaPhotoConfirmationDialog) {
            Button("Take Photo") {
                createAHappeningVM.openPhotoOrCameraPicker(selction: .camera)
            }
            
            Button("Choose Photo") {
                createAHappeningVM.openPhotoOrCameraPicker(selction: .photo)
            }
        }
    }
}

struct HappeningPhotosList_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                HappeningPhotosList()
            }
            
            NavigationView {
                HappeningPhotosList()
                    .preferredColorScheme(.dark)
            }
        }
        .environmentObject(CreateAHappeningViewModel())
    }
}
