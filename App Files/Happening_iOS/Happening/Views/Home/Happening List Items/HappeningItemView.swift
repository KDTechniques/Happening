//
//  HappeningItemView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-03-26.
//

import SwiftUI
import SDWebImageSwiftUI

struct HappeningItemView: View {
    
    let item: HappeningItemModel
    
    var body: some View {
        VStack(spacing: 5) {
            HStack {
                WebImage(url: URL(string: item.profilePhotoURL))
                    .resizable()
                    .placeholder {
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .overlay(
                                Image(systemName: "person.crop.circle.fill")
                                    .foregroundColor(.gray)
                                    .background(.white)
                            )
                    }
                    .scaledToFill()
                    .frame(width: 15, height: 15)
                    .clipShape(Circle())
                    .frame(width: 50, alignment: .trailing)
                
                Text(item.userName)
                    .font(.caption)
                    .fontWeight(.light)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                Spacer()
                
                Text(item.spaceFee)
                    .font(.caption)
                    .fontWeight(.light)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            .frame(height: 15)
            .padding(.horizontal)
            
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
                    Text(item.title)
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    Text(item.followingStatus ? item.address : item.secureAddress)
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
            .padding(.bottom, 15)
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
        .padding(.top, 15)
    }
}

struct HappeningItemViewSpecial: View {
    
    let item: HappeningItemModel
    
    var body: some View {
        VStack(spacing: 5) {
            HStack {
                WebImage(url: URL(string: item.profilePhotoURL))
                    .resizable()
                    .placeholder {
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .overlay(
                                Image(systemName: "person.crop.circle.fill")
                                    .foregroundColor(.gray)
                                    .background(.white)
                            )
                    }
                    .scaledToFill()
                    .frame(width: 15, height: 15)
                    .clipShape(Circle())
                    .frame(width: 50, alignment: .trailing)
                
                Text(item.userName)
                    .font(.caption)
                    .fontWeight(.light)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                Spacer()
                
                Text(item.spaceFee)
                    .font(.caption)
                    .fontWeight(.light)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            .frame(height: 15)
            .padding(.horizontal)
            
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
                    Text(item.title)
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    Text(item.followingStatus ? item.address : item.secureAddress)
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
            .padding(.bottom, 15)
            .padding(.horizontal)
        }
        .padding(.top, 15)
    }
}
