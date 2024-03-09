//
//  ParticipantItemView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-06-01.
//

import SwiftUI
import SDWebImageSwiftUI

struct ParticipantItemView: View {
    
    // MARK: PROPERTIES
    @Environment(\.colorScheme) var colorScheme
    
    let profilePhotoThumnailURL: String
    let userName: String
    let profession: String
    let ratings: Double
    
    let screeWidth: CGFloat = UIScreen.main.bounds.size.width
    
    // MARK: BODY
    var body: some View {
        VStack(spacing: 1) {
            WebImage(url: URL(string: profilePhotoThumnailURL))
                .resizable()
                .placeholder {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                }
                .indicator(.activity)
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            
            Text(userName)
                .font(.caption2.weight(.medium))
                .padding(.top, 5)
            
            Text(profession)
                .font(.system(size: 10))
                .foregroundColor(.secondary)
            
            HStack(spacing: 3) {
                ForEach(1...Int(ratings), id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .resizable()
                        .scaledToFit()
                }
                
                if (4.6 - floor(ratings) > 0.000001) {
                    Image(systemName: "star.leadinghalf.filled")
                        .resizable()
                        .scaledToFit()
                }
            }
            .frame(height: 7)
            .foregroundColor(.yellow)
        }
        .lineLimit(1)
        .frame(width: screeWidth/3)
        .padding()
        .background(colorScheme == .dark ? Color(UIColor.secondarySystemBackground) : .white)
        .cornerRadius(10)
    }
}
