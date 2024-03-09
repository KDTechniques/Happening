//
//  MyHappeningPhotoSliderView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-06-01.
//

import SwiftUI
import SDWebImageSwiftUI

struct MyHappeningPhotoSliderView: View {
    
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
struct MyHappeningPhotoSliderView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            List {
                HappeningPhotoSliderVew(
                    imagesURLsArray: [
                        "https://www.onegalleface.com/wp-content/themes/ogf/img/intro-image.jpg",
                        "https://www.onegalleface.com/wp-content/themes/ogf/img/intro-image.jpg",
                        "https://www.onegalleface.com/wp-content/themes/ogf/img/intro-image.jpg"
                    ],
                    title: "Shopping @ One Galle Face M. 🏢"
                )
            }
            .listStyle(.plain)
            .navigationTitle("Shopping @ One Galle Face M. 🏢")
            .preferredColorScheme(.dark)
            
            List {
                HappeningPhotoSliderVew(
                    imagesURLsArray: [
                        "https://www.onegalleface.com/wp-content/themes/ogf/img/intro-image.jpg",
                        "https://www.onegalleface.com/wp-content/themes/ogf/img/intro-image.jpg",
                        "https://www.onegalleface.com/wp-content/themes/ogf/img/intro-image.jpg"
                    ],
                    title: "Shopping @ One Galle Face M. 🏢"
                )
            }
            .listStyle(.plain)
        }
    }
}
