//
//  TakeAHappeningPhotoVectorImageView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-03-07.
//

import SwiftUI

struct TakeAHappeningPhotoVectorImageView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var color: ColorTheme
    
    var body: some View {
        ZStack {
            TakeAPhotoVectorImage(imageName: "TakeAHappeningPhotoLayer1")
                .foregroundColor(colorScheme == .light ? .black : .white)
            
            TakeAPhotoVectorImage(imageName: "TakeAHappeningPhotoLayer2")
                .foregroundColor(color.accentColor)
            
            TakeAPhotoVectorImage(imageName: "TakeAHappeningPhotoLayer3")
                .foregroundColor(colorScheme == .light ? .white : .black)
            
            Image("TakeAHappeningPhotoLayer4")
                .resizable()
                .scaledToFit()
        }
    }
}

struct TakeAHappeningPhotoVectorImageView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TakeAHappeningPhotoVectorImageView()
            
            TakeAHappeningPhotoVectorImageView()
                .preferredColorScheme(.dark)
        }
        .environmentObject(ColorTheme())
    }
}

struct TakeAPhotoVectorImage: View {
    
    let imageName: String
    
    var body: some View {
        Image(imageName)
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
    }
}
