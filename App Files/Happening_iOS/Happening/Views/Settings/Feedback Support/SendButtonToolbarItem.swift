//
//  SendButtonToolbarItem.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-01-06.
//

import SwiftUI

struct SendButtonToolbarItem: View {
    
    // MARK: PROPERTIES
    @Environment(\.dismiss) var presentationMode
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @EnvironmentObject var feedbackSupportViewModel: FeedbackSupportViewModel
    
    // MARK: BODY
    var body: some View {
        Button("Send") {
            hideKeyboard()
            feedbackSupportViewModel.alertItem1ForFeedbackSupportView = AlertItemModel(
                title: "",
                message: "By tapping Agree, your feedback will be used to improve Happening product and services.",
                dismissButton: .cancel(),
                primaryButton: .default(Text("Agree")) {
                    feedbackSupportViewModel.isPresentedLinearProgressForFeedbackSubmission = true
                    
                    feedbackSupportViewModel.submitFeedbackToFirestore { status in
                        if(status) {
                            feedbackSupportViewModel.isPresentedLinearProgressForFeedbackSubmission = false
                            presentationMode.callAsFunction()
                        }
                    }
                }
            )
        }
        .disabled(!(feedbackSupportViewModel.isFeedbackImageAddedSucess && feedbackSupportViewModel.feedbackData.feedbackText.count > 5))
    }
}

// MARK: PREVIEWS
struct SendButtonToolbarItem_Previews: PreviewProvider {
    static var previews: some View {
        SendButtonToolbarItem()
            .environmentObject(FeedbackSupportViewModel())
    }
}
