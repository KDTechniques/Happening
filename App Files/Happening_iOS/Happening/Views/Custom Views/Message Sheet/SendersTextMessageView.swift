//
//  SendersTextMessageView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-04-04.
//

import SwiftUI

struct SendersTextMessageView: View {
    
    // MARK: PROPERTIES
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var color: ColorTheme
    
    let msgText: String
    let time: String
    let isSent: Bool
    let isDelivered: Bool
    let isRead: Bool
    let reaction: ReactorEmojiTypes
    
    enum MessageIconTypes: String {
        case pending = "msgPending"
        case sent = "msgSent"
        case delivered = "msgDelivered"
        case read = "msgRead"
    }
    
    let messageIconSelection: MessageIconTypes
    
    init(msgText:String, time: String, isSent: Bool, isDelivered: Bool, isRead: Bool, reaction: ReactorEmojiTypes) {
        self.msgText = msgText
        self.time = time
        self.isSent = isSent
        self.isDelivered = isDelivered
        self.isRead = isRead
        self.reaction = reaction
        
        if isSent && !isDelivered && !isRead {
            messageIconSelection = .sent
        } else if isSent && isDelivered && isRead {
            messageIconSelection = .read
        } else if isSent && isDelivered && !isRead {
            messageIconSelection = .delivered
        } else {
            messageIconSelection = .pending
        }
    }
    
    // MARK: BODY
    var body: some View {
        VStack(alignment: .trailing, spacing: 5) {
            Text(msgText)
            
            HStack {
                Text(time)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                Image(messageIconSelection.rawValue)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(
                        (messageIconSelection == .pending || messageIconSelection == .sent || messageIconSelection == .delivered)
                        ? .secondary
                        : color.accentColor
                    )
            }
            .frame(height: 10)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(Color("MessageSender"))
        .cornerRadius(8)
        .overlay(alignment: .bottomLeading) {
            Text(reaction.rawValue)
                .font(.footnote)
                .background(
                    RoundedRectangle(cornerRadius: .infinity)
                        .fill(Color("MessageSender"))
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
        .frame(width: UIScreen.main.bounds.size.width - 100, alignment: .trailing)
        //        .background(.red)
        .frame(maxWidth: .infinity, alignment: .trailing)
        //        .background(.green)
        .listRowSeparator(.hidden)
    }
}

// MARK: PREVIEWS
struct SendersTextMessageView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SendersTextMessageView(
                msgText: "#GoHomeGota2022",
                time: "5:54 PM",
                isSent: true,
                isDelivered: false,
                isRead: false,
                reaction: .heart
            )
                .preferredColorScheme(.dark)
            
            SendersTextMessageView(
                msgText: "#GoHomeGota2022",
                time: "5:54 PM",
                isSent: true,
                isDelivered: false,
                isRead: false,
                reaction: .wow
            )
        }
        .environmentObject(ColorTheme())
    }
}
