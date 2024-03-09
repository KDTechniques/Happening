//
//  UploadButtonSection.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-01-06.
//

import SwiftUI

struct UploadButtonSection: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var feedbackSupportViewModel: FeedbackSupportViewModel
    
    // MARK: BODY
    var body: some View {
        Section {
            HStack {
                Spacer()
                Button("Upload A Screenshot") {
                    feedbackSupportViewModel.isPresentedFeedbackImagePhotoPicker = true
                }
                Spacer()
            }
            .sheet(isPresented: $feedbackSupportViewModel.isPresentedFeedbackImagePhotoPicker, content: {
                PhotoPicker(image: $feedbackSupportViewModel.feedbackData.screenshotImage,
                            imageErrorAlert: $feedbackSupportViewModel.isPresentedAlertForFeedbackImage,
                            isAddedSucess: $feedbackSupportViewModel.isFeedbackImageAddedSucess)
                    .dynamicTypeSize(.large)
            })
        }
    }
}

// MARK: PREVIEWS
struct UploadButtonSection_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                List {
                    UploadButtonSection()
                        .preferredColorScheme(.dark)
                }
                .listStyle(.grouped)
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(Text(FeedbackTypes.like.rawValue))
            }
            
            NavigationView {
                List {
                    UploadButtonSection()
                }
                .listStyle(.grouped)
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(Text(FeedbackTypes.suggestion.rawValue))
            }
        }
        .environmentObject(FeedbackSupportViewModel())
    }
}
