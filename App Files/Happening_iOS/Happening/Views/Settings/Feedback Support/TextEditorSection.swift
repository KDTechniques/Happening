//
//  TextEditorSection.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-01-06.
//

import SwiftUI

struct TextEditorSection: View {
    
    // MARK: PROPERTIES
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var feedbackSupportViewModel: FeedbackSupportViewModel
    
    // MARK: BODY
    var body: some View {
        Section {
            TextEditor(text: $feedbackSupportViewModel.feedbackData.feedbackText)
                .frame(height: 100)
                .padding(.horizontal)
                .frame(height: 120)
                .background(colorScheme == .light ? Color.black.opacity(0.05) : Color.black.opacity(0.5))
                .cornerRadius(10)
                .padding(.vertical)
                .overlay(
                    Text("\(feedbackSupportViewModel.feedbackData.feedbackText.count)/\(feedbackSupportViewModel.feedbackTextLimit)")
                        .foregroundColor(feedbackSupportViewModel.feedbackTextLimitNoColor)
                        .font(.system(size: 10))
                        .offset(x: 0, y: 1)
                        .onChange(of: feedbackSupportViewModel.feedbackData.feedbackText) { _ in
                            feedbackSupportViewModel.limitFeedbackText(limit: feedbackSupportViewModel.feedbackTextLimit)
                            
                            if(feedbackSupportViewModel.feedbackData.feedbackText.count == feedbackSupportViewModel.feedbackTextLimit) {
                                feedbackSupportViewModel.feedbackTextLimitNoColor = .red
                            }
                            else{
                                feedbackSupportViewModel.feedbackTextLimitNoColor = .primary
                            }
                        }
                    , alignment: .bottomTrailing
                )
            
        } header: {
            Text("Write Something")
                .font(.footnote)
        }
    }
}

struct TextEditorSection_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                List {
                    TextEditorSection()
                        .preferredColorScheme(.dark)
                }
                .listStyle(.grouped)
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(Text(FeedbackTypes.like.rawValue))
            }
            
            NavigationView {
                List {
                    TextEditorSection()
                }
                .listStyle(.grouped)
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(Text(FeedbackTypes.suggestion.rawValue))
            }
        }
        .environmentObject(FeedbackSupportViewModel())
    }
}
