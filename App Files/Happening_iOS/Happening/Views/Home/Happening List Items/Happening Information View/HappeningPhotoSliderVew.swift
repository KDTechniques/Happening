//
//  HappeningPhotoSliderVew.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-03-30.
//

import SwiftUI
import SDWebImageSwiftUI

struct HappeningPhotoSliderVew: View {
    
    // MARK: PROPERTIES
    
    @State private var selectedImage: Int = 0
    @State private var contentMode: [Bool] = [true, true, true, true, true]
    
    let imagesURLsArray: [String]
    let title: String
    
    // MARK: BODY
    var body: some View {
        Section {
            TabView(selection: $selectedImage){
                ForEach(imagesURLsArray.indices, id: \.self) { index in
                    WebImage(url: URL(string: imagesURLsArray[index]))
                        .onSuccess(perform: { image, _, _ in
                            contentMode[index] = checkImageAspectRatio(image: image)
                        })
                        .resizable()
                        .placeholder {
                            Rectangle()
                                .fill(.ultraThinMaterial)
                        }
                        .indicator(.activity)
                        .aspectRatio(contentMode: contentMode[index] ? .fill : .fit)
                        .frame(maxWidth: .infinity)
                        .clipped()
                        .tag(index)
                }
            }
            .frame(height: 250)
            .overlay(
                VStack {
                    HStack {
                        Spacer()
                        Text("\(selectedImage+1)/\(imagesURLsArray.count)")
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
            .tabViewStyle(PageTabViewStyle())
            .listRowInsets(EdgeInsets())
        } header: {
            Text(title)
                .font(.footnote)
        }
    }
}

// MARK: PREVIEWS
//struct HappeningPhotoSliderVew_Previews: PreviewProvider {
//    static var previews: some View {
//        HappeningPhotoSliderVew()
//    }
//}
