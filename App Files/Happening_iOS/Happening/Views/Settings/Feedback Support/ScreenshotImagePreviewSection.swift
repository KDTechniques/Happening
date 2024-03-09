//
//  ScreenshotImagePreviewSection.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-01-06.
//

import SwiftUI

struct ScreenshotImagePreviewSection: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @EnvironmentObject var feedbackSupportViewModel: FeedbackSupportViewModel
    
    // MARK: BODY
    var body: some View {
        Section {
            HStack {
                Spacer()
                Image(uiImage: feedbackSupportViewModel.feedbackData.screenshotImage!)
                    .resizable()
                    .scaledToFit()
                    .padding(.vertical)
                Spacer()
            }
            .alert(isPresented: $feedbackSupportViewModel.isPresentedAlertForFeedbackImage, content: {
                Alert(title: Text("Image Failed"), message: Text("An error occurred."), dismissButton: .cancel(Text("OK")))
            })
            
        } header: {
            Text("Screenshot")
                .font(.footnote)
        }
    }
}

// MARK: PREVIEWS
struct ScreenshotImagePreviewSection_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                List {
                    ScreenshotImagePreviewSection()
                        .preferredColorScheme(.dark)
                }
                .listStyle(.grouped)
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(Text(FeedbackTypes.like.rawValue))
            }
            
            NavigationView {
                List {
                    ScreenshotImagePreviewSection()
                }
                .listStyle(.grouped)
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(Text(FeedbackTypes.suggestion.rawValue))
            }
        }
        .environmentObject(FeedbackSupportViewModel())
    }
}
