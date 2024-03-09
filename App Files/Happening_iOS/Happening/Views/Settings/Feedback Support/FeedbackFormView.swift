//
//  FeedbackFormView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-01-06.
//

import SwiftUI

struct FeedbackFormView: View {
    
    // MARK: PROPERTIES
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var feedbackSupportViewModel: FeedbackSupportViewModel
    
    let feedbackType: FeedbackTypes
    
    // MARK: BODY
    var body: some View {
        ZStack {
            List {
                // screenshotImagePreview
                ScreenshotImagePreviewSection()
                
                // uploadButton
                UploadButtonSection()
                
                // textEditor
                TextEditorSection()
                
                // contactMeAtMyEmailAddress
                ContactMeSection()
            }
            .listStyle(.grouped)
            .onChange(of: colorScheme) {
                feedbackSupportViewModel.onChangeOfFeedbackColorScheme(colorScheme: $0)
            }
            .onDisappear {
                feedbackSupportViewModel.resetFeedbackFormView()
            }
            .onAppear {
                feedbackSupportViewModel.resetFeedbackFormView()
                feedbackSupportViewModel.feedbackData.feedbackType = self.feedbackType.rawValue
            }
            .toolbar(content: {
                ToolbarItem(placement: .confirmationAction) { SendButtonToolbarItem() }
                ToolbarItem(placement: .keyboard) {  HideKeyboardPlacementView() }
            })
            .disabled(feedbackSupportViewModel.isPresentedLinearProgressForFeedbackSubmission)
            .navigationBarBackButtonHidden(feedbackSupportViewModel.isPresentedLinearProgressForFeedbackSubmission)
            
            if(feedbackSupportViewModel.isPresentedLinearProgressForFeedbackSubmission) {
                CustomProgressView2(
                    text: "Submitting...",
                    uploadAmount: feedbackSupportViewModel.uploadAmount
                ) {
                    feedbackSupportViewModel.isPresentedLinearProgressForFeedbackSubmission = false
                    feedbackSupportViewModel.uploadTask?.cancel()
                }
            }
        }
    }
}

// MARK: PREVIEWS
struct FeedbackFormView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                FeedbackFormView(feedbackType: .like)
                    .preferredColorScheme(.dark)
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationTitle(Text(FeedbackTypes.like.rawValue))
            }
            
            NavigationView {
                FeedbackFormView(feedbackType: .suggestion)
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationTitle(Text(FeedbackTypes.suggestion.rawValue))
            }
        }
        .environmentObject(FeedbackSupportViewModel())
    }
}
