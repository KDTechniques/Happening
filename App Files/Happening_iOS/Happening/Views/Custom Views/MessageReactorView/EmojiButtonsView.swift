//
//  EmojiButtonsView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-05-26.
//

import SwiftUI

struct EmojiButtonsView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var messageSheetVM: MessageSheetViewModel
    
    @State var selectedEmoji: ReactorEmojiTypes {
        didSet {
            
            // call the function  in message sheet view model to update the reaction locally and in firestore for both sender and reciever
            messageSheetVM.updateMessageReactionInUserDefaults(
                reaction: selectedEmoji,
                item: item) { _ in }
            
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    messageSheetVM.startAnimation = false
                }
            }
        }
    }
    
    let profilePhotoThumbnailURL: String
    let msgText: String
    let sentTime: String
    let item: MessageSheetContentModel
    
    @State private var emojiButtonsFrameWidth: CGFloat = 0
    
    @State private var emojiButton1ScaleEffect: CGFloat = 0.01
    @State private var emojiButton2ScaleEffect: CGFloat = 0.01
    @State private var emojiButton3ScaleEffect: CGFloat = 0.01
    @State private var emojiButton4ScaleEffect: CGFloat = 0.01
    @State private var emojiButton5ScaleEffect: CGFloat = 0.01
    @State private var emojiButton6ScaleEffect: CGFloat = 0.01
    
    // MARK: BODY
    /// we need to add blur effect using .background(.ultraThinMaterial) on the bottom view.
    /// on top of the bottom view, emojies reactor view will be placed.
    var body: some View {
        VStack {
            HStack(spacing: -6) {
                EmojiButtonView(
                    emoji: "👍",
                    selectedEmoji: selectedEmoji) {
                        if selectedEmoji == .okay {
                            selectedEmoji = .none
                        } else {
                            selectedEmoji = .okay
                        }
                    }
                    .scaleEffect(emojiButton1ScaleEffect)
                
                EmojiButtonView(
                    emoji: "❤️",
                    selectedEmoji: selectedEmoji) {
                        if selectedEmoji == .heart {
                            selectedEmoji = .none
                        } else {
                            selectedEmoji = .heart
                        }
                    }
                    .scaleEffect(emojiButton2ScaleEffect)
                
                EmojiButtonView(
                    emoji: "😂",
                    selectedEmoji: selectedEmoji) {
                        if selectedEmoji == .haha {
                            selectedEmoji = .none
                        } else {
                            selectedEmoji = .haha
                        }
                    }
                    .scaleEffect(emojiButton3ScaleEffect)
                
                EmojiButtonView(
                    emoji: "😮",
                    selectedEmoji: selectedEmoji) {
                        if selectedEmoji == .wow {
                            selectedEmoji = .none
                        } else {
                            selectedEmoji = .wow
                        }
                    }
                    .scaleEffect(emojiButton4ScaleEffect)
                
                EmojiButtonView(
                    emoji: "😢",
                    selectedEmoji: selectedEmoji) {
                        if selectedEmoji == .sad {
                            selectedEmoji = .none
                        } else {
                            selectedEmoji = .sad
                        }
                    }
                    .scaleEffect(emojiButton5ScaleEffect)
                
                EmojiButtonView(
                    emoji: "🙏",
                    selectedEmoji: selectedEmoji) {
                        if selectedEmoji == .please {
                            selectedEmoji = .none
                        } else {
                            selectedEmoji = .please
                        }
                    }
                    .scaleEffect(emojiButton6ScaleEffect)
            }
            .padding(5)
            .background(
                RoundedRectangle(cornerRadius: .infinity)
                    .fill(Color(UIColor.tertiarySystemBackground))
                    .frame(maxWidth: emojiButtonsFrameWidth, maxHeight: emojiButtonsFrameWidth)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .shadow(color: .black.opacity(0.1), radius: 1)
            )
            .frame(maxWidth: .infinity, alignment: .leading)
            .onAppear {
                /// all duration goes with 0.3 seconds
                withAnimation(.easeInOut(duration: 0.2)) {
                    emojiButtonsFrameWidth = 50+(5*2)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now()+0.15) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        emojiButtonsFrameWidth = .infinity
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                    withAnimation(.easeInOut(duration: 0.2/6)) {
                        emojiButton1ScaleEffect = 1
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now()+0.2+0.1/2) {
                    withAnimation(.easeInOut(duration: 0.2/6)) {
                        emojiButton2ScaleEffect = 1
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now()+0.2+0.1/2*2) {
                    withAnimation(.easeInOut(duration: 0.2/6)) {
                        emojiButton3ScaleEffect = 1
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now()+0.2+0.1/2*3) {
                    withAnimation(.easeInOut(duration: 0.2/6)) {
                        emojiButton4ScaleEffect = 1
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now()+0.2+0.1/2*4) {
                    withAnimation(.easeInOut(duration: 0.2/6)) {
                        emojiButton5ScaleEffect = 1
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now()+0.2+0.1/2*5) {
                    withAnimation(.easeInOut(duration: 0.2/6)) {
                        emojiButton6ScaleEffect = 1
                    }
                }
            }
            
            MessageBoxView(
                profilePhotoThumURL: profilePhotoThumbnailURL,
                msgText: msgText,
                sentTime: sentTime
            )
        }
        .padding()
    }
}

// MARK: PREVIEWS
struct EmojiButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ZStack {
                ButtonView(name: "check 123", action: {})
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
                    .overlay(
                        Color.clear
                            .background(.ultraThinMaterial)
                    )
                
                EmojiButtonsView(
                    selectedEmoji: .wow,
                    profilePhotoThumbnailURL: "https://storage.googleapis.com/happening-8133c.appspot.com/Profile%20Data/Profile%20Pictures/dgoP2Pxr5uY7gTlAb9TeIyZWiSE3/30984312-81C4-469A-A425-1D78B4B710D8_THUMB?GoogleAccessId=firebase-adminsdk-apv26%40happening-8133c.iam.gserviceaccount.com&Expires=3029529600&Signature=sFOQyWYCVFytW%2F2NOxRD6jFnDDzyO7zzdDVsAJF5jKyL1Cs9jqfwpHjyOKQ6NjcT4QCCy41%2F4r9jyQW8iPDlMbsLT039CD0g3%2F70O%2BCpFlgb2onwfXn5hvIwLvKmg9VQkuyIER%2FWOUDzguOlPzsClDhxBk0Pvoj3qCvGHEHHYdpN6dhIrP2EEL6U83trcZyamib%2BeP0adzkzPUVobelrLmYq0zcmAUIrYIuD2dEX%2FhPPg8h6k15YN03FN065F30wlh62cBb42HU0Y64ks28i0Tkz2XiPaUM5Ski8cxBWmTmKTAV8MPve8ukO5F5%2FWkc4JHppLsTwQSnTxTHvkyvFug%3D%3D",
                    msgText: "Hello there...",
                    sentTime: "4:55 PM",
                    item: MessageSheetContentModel(data: [:])
                )
            }
            .preferredColorScheme(.dark)
            
            ZStack {
                ButtonView(name: "check 123", action: {})
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
                    .overlay(
                        Color.clear
                            .background(.ultraThinMaterial)
                    )
                
                EmojiButtonsView(
                    selectedEmoji: .none,
                    profilePhotoThumbnailURL: "https://storage.googleapis.com/happening-8133c.appspot.com/Profile%20Data/Profile%20Pictures/dgoP2Pxr5uY7gTlAb9TeIyZWiSE3/30984312-81C4-469A-A425-1D78B4B710D8_THUMB?GoogleAccessId=firebase-adminsdk-apv26%40happening-8133c.iam.gserviceaccount.com&Expires=3029529600&Signature=sFOQyWYCVFytW%2F2NOxRD6jFnDDzyO7zzdDVsAJF5jKyL1Cs9jqfwpHjyOKQ6NjcT4QCCy41%2F4r9jyQW8iPDlMbsLT039CD0g3%2F70O%2BCpFlgb2onwfXn5hvIwLvKmg9VQkuyIER%2FWOUDzguOlPzsClDhxBk0Pvoj3qCvGHEHHYdpN6dhIrP2EEL6U83trcZyamib%2BeP0adzkzPUVobelrLmYq0zcmAUIrYIuD2dEX%2FhPPg8h6k15YN03FN065F30wlh62cBb42HU0Y64ks28i0Tkz2XiPaUM5Ski8cxBWmTmKTAV8MPve8ukO5F5%2FWkc4JHppLsTwQSnTxTHvkyvFug%3D%3D",
                    msgText: "Hello there...",
                    sentTime: "4:55 PM",
                    item: MessageSheetContentModel(data: [:])
                )
            }
        }
        .environmentObject(ColorTheme())
        .environmentObject(MessageSheetViewModel())
    }
}
