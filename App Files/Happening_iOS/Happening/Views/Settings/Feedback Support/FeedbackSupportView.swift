//
//  FeedbackSupportView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-11-17.
//

import SwiftUI

struct FeedbackSupportView: View {
    
    // MARK: PROPERTIES
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @EnvironmentObject var feedbackSupportViewModel: FeedbackSupportViewModel
    
    // MARK: BODY
    var body: some View {
        NavigationLink {
            List {
                Section {
                    // i like something
                    NavigationLink {
                        FeedbackFormView(feedbackType: FeedbackTypes.like)
                            .toolbar {
                                ToolbarItem(placement: .principal) {Text("I Like Something").fontWeight(.semibold)}
                            }
                    } label: {
                        Text(FeedbackTypes.like.rawValue)
                    }
                    .alert(item: $feedbackSupportViewModel.alertItem1ForFeedbackSupportView) { alert -> Alert in
                        Alert(
                            title: Text(alert.title),
                            message: Text(alert.message),
                            primaryButton: alert.primaryButton ?? .default(Text("OK")),
                            secondaryButton: alert.dismissButton ?? .cancel()
                        )
                    }
                    
                    // i don't like something
                    NavigationLink {
                        FeedbackFormView(feedbackType: FeedbackTypes.dontLike)
                            .toolbar {
                                ToolbarItem(placement: .principal) {Text("I Don't Like Something").fontWeight(.semibold)}
                            }
                    } label: {
                        Text(FeedbackTypes.dontLike.rawValue)
                    }
                    .alert(item: $feedbackSupportViewModel.alertItem2ForFeedbackSupportView) { alert -> Alert in
                        Alert(
                            title: Text(alert.title),
                            message: Text(alert.message)
                        )
                    }
                    
                    // i have a suggestion
                    NavigationLink {
                        FeedbackFormView(feedbackType: FeedbackTypes.suggestion)
                            .toolbar {
                                ToolbarItem(placement: .principal) {Text("I Have A Suggestion").fontWeight(.semibold)}
                            }
                    } label: {
                        Text(FeedbackTypes.suggestion.rawValue)
                    }
                } footer: {
                    Text("You can send feedback to the Happening Developer Team to improve this application.")
                        .font(.footnote)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
            }
            .listStyle(.grouped)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {Text("Send Feedback").fontWeight(.semibold)}
            }
            // dynamically initialize the sample screenshot image for the feedback
            .onAppear {
                if(colorScheme == .light){
                    feedbackSupportViewModel.feedbackData.screenshotImage = UIImage(named: "SampleScreenshotDark")!
                } else {
                    feedbackSupportViewModel.feedbackData.screenshotImage = UIImage(named: "SampleScreenshotLight")!
                }
            }
            
        } label: {
            Text("Send Feedback")
        }
    }
}

// MARK: PREVIEWS
struct FeedbackSupportView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            NavigationView{
                FeedbackSupportView().preferredColorScheme(.dark)
            }
            NavigationView{
                FeedbackSupportView()
            }
        }
        .environmentObject(FeedbackSupportViewModel())
    }
}

