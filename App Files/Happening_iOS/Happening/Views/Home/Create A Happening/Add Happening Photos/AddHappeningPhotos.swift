//
//  AddHappeningPhotos.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-03-07.
//

import SwiftUI

struct AddHappeningPhotos: View {
    
    @EnvironmentObject var color: ColorTheme
    @EnvironmentObject var createAHappeningVM: CreateAHappeningViewModel
    
    var body: some View {
        Section {
            VStack(spacing: 0) {
                if(createAHappeningVM.happeningPhotosArray.isEmpty) {
                    HStack {
                        Spacer()
                        TakeAHappeningPhotoVectorImageView()
                            .frame(height: 200)
                            .padding(.vertical)
                        Spacer()
                    }
                } else {
                    TabView(selection: $createAHappeningVM.selectedImage) {
                        ForEach(createAHappeningVM.happeningPhotosArray.indices, id: \.self){ index in
                            Image(uiImage: createAHappeningVM.happeningPhotosArray[index])
                                .resizable()
                                .aspectRatio(
                                    contentMode:checkImageAspectRatio(image: createAHappeningVM.happeningPhotosArray[index])
                                    ? .fill : .fit
                                )
                                .frame(width: UIScreen.main.bounds.size.width)
                                .clipped()
                                .tag(index)
                        }
                    }
                    .frame(height: 250)
                    .overlay(
                        VStack {
                            HStack {
                                Spacer()
                                Text("\(createAHappeningVM.selectedImage+1)/\(createAHappeningVM.happeningPhotosArray.count)")
                                    .font(.subheadline)
                                    .foregroundColor(Color.white)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 3)
                                    .background(Color.black)
                                    .cornerRadius(5)
                            }
                            Spacer()
                        }
                            .padding()
                    )
                    .listRowInsets(EdgeInsets())
                    .tabViewStyle(PageTabViewStyle())
                }
                
                Divider()
                
                Text(createAHappeningVM.happeningPhotosArray.count < 1 ? "Add a Photo" : "Add, Re-Order and Edit Photos")
                    .foregroundColor(color.accentColor)
                    .frame(maxWidth: .infinity)
                    .background(NavigationLink("", destination: { HappeningPhotosList() }).opacity(0))
                    .padding(.vertical, 12)
            }
            .listRowInsets(EdgeInsets())
        } header: {
            Text("Photos")
                .font(.footnote)
        } footer: {
            Text("*add at least one photo (max. 5).")
                .font(.footnote)
        }
        
    }
}

struct AddHappeningPhotos_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CreateAHappeningView()
            
            CreateAHappeningView()
                .preferredColorScheme(.dark)
        }
        .listStyle(.grouped)
        .environmentObject(CreateAHappeningViewModel())
        .environmentObject(ColorTheme())
    }
}
