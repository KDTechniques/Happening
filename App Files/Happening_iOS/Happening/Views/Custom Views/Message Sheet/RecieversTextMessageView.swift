//
//  RecieversTextMessageView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-04-04.
//

import SwiftUI
import SDWebImageSwiftUI

struct RecieversTextMessageView: View {
    
    // MARK: PROPERTIES
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var color: ColorTheme
    
    let profilePhotoThumbnailURL: String
    let msgText: String
    let time: String
    let reaction: ReactorEmojiTypes
    
    // MARK: BODY
    var body: some View {
        HStack(alignment: .top) {
            WebImage(url: URL(string: profilePhotoThumbnailURL))
                .resizable()
                .placeholder {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                }
                .indicator(.activity)
                .scaledToFill()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            
            VStack(alignment: .trailing, spacing: 5) {
                Text(msgText)
                
                Text(time)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(Color("MessageReceiver"))
            .cornerRadius(8)
            .overlay(alignment: .bottomLeading) {
                Text(reaction.rawValue)
                    .font(.footnote)
                    .background(
                        RoundedRectangle(cornerRadius: .infinity)
                            .fill(Color("MessageReceiver"))
                            .frame(width: 35, height: 24)
                            .shadow(color: .black.opacity(0.1), radius: 1)
                            .overlay(
                                RoundedRectangle(cornerRadius: .infinity)
                                    .stroke(colorScheme == .dark ? Color(UIColor.systemGray5) : .white, lineWidth: 0.8)
                                    .frame(width: 35, height: 24)
                            )
                    )
                    .padding(.leading)
                    .offset(y: 15)
                    .opacity(reaction == .none ? 0 : 1)
            }
            .padding(.bottom, reaction == .none ? 0 : 16)
        }
        .frame(width: UIScreen.main.bounds.size.width - 100, alignment: .leading)
        //        .background(.red)
        .frame(maxWidth: .infinity, alignment: .leading)
        //        .background(.green)
        .listRowSeparator(.hidden)
    }
}

// MARK: PREVIEWS
struct RecieversTextMessageView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RecieversTextMessageView(
                profilePhotoThumbnailURL: "https://nokiatech.github.io/heif/content/images/ski_jump_1440x960.heic",
                msgText: "This is a sample message #GoHomeGota2022",
                time: "5:15 PM",
                reaction: .heart
            )
                .preferredColorScheme(.dark)
            
            RecieversTextMessageView(
                profilePhotoThumbnailURL: "https://nokiatech.github.io/heif/content/images/ski_jump_1440x960.heic",
                msgText: "This is a sample message #GoHomeGota2022",
                time: "5:15 PM",
                reaction: .please
            )
        }
        .padding()
        .environmentObject(ColorTheme())
    }
}
