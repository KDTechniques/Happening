//
//  MyHappeningItemView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-03-14.
//

import SwiftUI
import SDWebImageSwiftUI

struct MyHappeningItemView: View {
    
    // MARK: PROPERTIES
    let item: MyHappeningModel
    
    // MARK: BODY
    var body: some View {
        HStack {
            WebImage(url: URL(string: item.thumbnailPhotoURL))
                .resizable()
                .placeholder {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                }
                .indicator(.activity)
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 2)  {
                Text(item.spaceFee)
                    .font(.caption)
                    .fontWeight(.light)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                Text(item.title)
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Text(item.address)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                Text("\(item.startingDateTime) - \(item.endingDateTime)")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 15)
        .padding(.horizontal)
        .overlay(alignment: .bottom) {
            HStack {
                Spacer()
                VStack(alignment: .trailing, spacing: 0) {
                    Divider()
                        .frame(maxWidth: UIScreen.main.bounds.size.width - 75)
                }
            }
        }
    }
}

// MARK: PREVIEW
struct MyHappeningItemView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MyHappeningItemView(item: MyHappeningModel(data: ["":""], documentID: ""))
                .preferredColorScheme(.dark)
            
            MyHappeningItemView(item: MyHappeningModel(data: ["":""], documentID: ""))
        }
        .environmentObject(ColorTheme())
    }
}
