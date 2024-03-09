//
//  SDWebImageChecker.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-03-19.
//

import SwiftUI
import SDWebImageSwiftUI

struct SDWebImageChecker: View {
    var body: some View {
        VStack {
            WebImage(url: URL(string: "https://nokiatech.github.io/heif/content/images/ski_jump_1440x960.heic"))
                .resizable()
                .placeholder {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                }
                .indicator(.activity)
                .scaledToFill()
                .frame(width: 30, height: 30)
                .clipShape(Circle())
        }
    }
}

struct SDWebImageChecker_Previews: PreviewProvider {
    static var previews: some View {
        SDWebImageChecker()
    }
}
