//
//  ZeroMyMemoriesMainListItemView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-05-03.
//

import SwiftUI

struct ZeroMyMemoriesMainListItemView: View {
    // MARK: PROPERTIES
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var color: ColorTheme
    @EnvironmentObject var profileBasicInfoVM: ProfileBasicInfoViewModel
    @EnvironmentObject var imageBasedMemoryVM: ImageBasedMemoryViewModel
    
    let imageFrameSize: CGFloat = 58
    
    let defaults = UserDefaults.standard
    
    // MARK: BODY
    var body: some View {
        Button {
            imageBasedMemoryVM.isPresentedPhotoLibrary = false
            imageBasedMemoryVM.isPresentedImagePickerSheet = true
            imageBasedMemoryVM.isPresenetedCameraSheet = true
        } label: {
            HStack(spacing: 14) {
                ZStack {
                    if let data = defaults.data(forKey: profileBasicInfoVM.profilePhotoUserDefaultsKeyName) {
                        Image(uiImage: UIImage(data: data)!)
                            .resizable()
                            .scaledToFill()
                            .frame(width: imageFrameSize, height: imageFrameSize)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person.circle.fill")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFill()
                            .frame(width: imageFrameSize, height: imageFrameSize)
                            .foregroundColor(Color(UIColor.systemGray5))
                            .clipShape(Circle())
                    }
                }
                .overlay(alignment: .bottomTrailing) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22, height: 22)
                        .foregroundColor(color.accentColor)
                        .background(.white)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 0)
                }
                
                VStack(alignment: .leading, spacing: 3) {
                    Text("My Memories")
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text("Add to my memories")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .listRowBackground(colorScheme == .dark ? Color(UIColor.secondarySystemBackground) : .white)
        }
        .listRowInsets(EdgeInsets())
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 75)
        .padding(.leading)
    }
}

// MARK: PREVIEWS
struct ZeroMyMemoriesMainListItemView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            List {
                ZeroMyMemoriesMainListItemView()
            }
            .preferredColorScheme(.dark)
            
            List {
                ZeroMyMemoriesMainListItemView()
            }
        }
        .listStyle(.grouped)
        .environmentObject(ColorTheme())
        .environmentObject(ProfileBasicInfoViewModel())
        .environmentObject(ImageBasedMemoryViewModel())
    }
}
