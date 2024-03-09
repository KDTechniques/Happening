//
//  FeedbackSupportViewModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-02-15.
//

import Foundation
import SwiftUI
import Firebase

class FeedbackSupportViewModel: ObservableObject {
    
    // MARK: PROPERTIES
    @Environment(\.colorScheme) var colorScheme
    
    // singleton
    static let shared = FeedbackSupportViewModel()
    
    // reference to CutrentUser class
    let currentUser = CurrentUser.shared
    
    // reference to Firestore
    let db = Firestore.firestore()
    
    // controls the max text limit for a feedback text
    let feedbackTextLimit: Int = 300
    
    // controls the foreground color of the feedback limit text number while typing
    @Published var feedbackTextLimitNoColor: Color = .primary
    
    // manage the feedback data confirming to FeedbackSupportModel
    @Published var feedbackData: FeedbackSupportModel
    
    // present a photo picker to pick a feedback screen shot
    @Published var isPresentedFeedbackImagePhotoPicker = false
    
    // present an alert if something goes wrong when adding a feedback image
    @Published var isPresentedAlertForFeedbackImage: Bool = false
    
    // status whether the feedback image added successful or not
    @Published var isFeedbackImageAddedSucess: Bool = false
    
    // present an loading screen when sumbitting the feedback
    @Published var isPresentedLinearProgressForFeedbackSubmission: Bool = false
    
    // present alert item for AlertItemForFeedbackSupportView
    @Published var alertItem1ForFeedbackSupportView: AlertItemModel?
    
    // present alert item for AlertItemForFeedbackSupportView
    @Published var alertItem2ForFeedbackSupportView: AlertItemModel?
    
    // controls the progress amount of the upload progress bar
    @Published var uploadAmount: Double = .zero
    
    // controls the upload task of the feedback submission progress
    var uploadTask: StorageUploadTask?
    
    
    // MARK: INITIALIZERS
    init() {
        feedbackData = FeedbackSupportModel(feedbackType: FeedbackTypes.like.rawValue, screenshotImage: UIImage(named: "SampleScreenshotDark")!, feedbackText: "", contactUser: false)
    }
    
    // MARK: FUNCTIONS
    
    
    
    // MARK: limitText
    func limitFeedbackText(limit: Int) {
        if (feedbackData.feedbackText.count > limit) {
            feedbackData.feedbackText = String(self.feedbackData.feedbackText.prefix(limit))
        }
    }
    
    // MARK: onChangeOfFeedback
    func onChangeOfFeedbackColorScheme(colorScheme: ColorScheme) {
        if(!isFeedbackImageAddedSucess){
            if(colorScheme == .light){
                feedbackData.screenshotImage = UIImage(named: "SampleScreenshotDark")!
            } else {
                feedbackData.screenshotImage = UIImage(named: "SampleScreenshotLight")!
            }
        }
    }
    
    // MARK: onDiappearOfFeedbackFormView
    func resetFeedbackFormView() {
        feedbackData = FeedbackSupportModel(feedbackType: "",
                                            screenshotImage: colorScheme == .light ? UIImage(named: "SampleScreenshotLight")! : UIImage(named: "SampleScreenshotDark")!,
                                            feedbackText: "",
                                            contactUser: false)
    }
    
    // MARK: submitFeedback
    func submitFeedbackToFirestore(completionHandler: @escaping (_ status: Bool) -> ()) {
        
        var feedbackPhotoURL: String = ""
        
        guard let docID = currentUser.currentUserUID else {
            alertItem2ForFeedbackSupportView = AlertItemModel(title: "Unable To Submit Feedback", message: "Please try again in a moment.")
            return
        }
        
        guard let feedbackImageData = feedbackData.screenshotImage?.jpegData(compressionQuality: 0.1) else {
            alertItem2ForFeedbackSupportView = AlertItemModel(title: "Unable To Submit Feedback", message: "Please try again in a moment.")
            return
        }
        
        let feedbackImageReference = Storage.storage().reference()
            .child("Feedback Data/\(docID)")
            .child(UUID().uuidString)
        
        let randomNumber = Int.random(in: 91...99)
        
        uploadTask = feedbackImageReference.putData(feedbackImageData, metadata: nil) { [weak self] _, error in
            if let error = error {
                print(error.localizedDescription)
                self?.alertItem2ForFeedbackSupportView = AlertItemModel(
                    title: "Unable To Submit Feedback",
                    message: error.localizedDescription
                )
                completionHandler(false)
                return
            } else {
                feedbackImageReference.downloadURL { url, error in
                    if let error = error {
                        print(error.localizedDescription)
                        self?.alertItem2ForFeedbackSupportView = AlertItemModel(
                            title: "Unable To Submit Feedback",
                            message: error.localizedDescription
                        )
                        completionHandler(false)
                        return
                    } else {
                        guard let url = url else {
                            self?.alertItem2ForFeedbackSupportView = AlertItemModel(title: "Unable To Submit Feedback", message: "Please try again in a moment.")
                            completionHandler(false)
                            return
                        }
                        
                        feedbackPhotoURL = url.absoluteString
                        
                        let data: [String:Any] = [
                            "FeedbackType" : self?.feedbackData.feedbackType as Any,
                            "ScreenshotImageURL" : feedbackPhotoURL,
                            "Comment" : self?.feedbackData.feedbackText as Any,
                            "isContactable" : self?.feedbackData.contactUser as Any,
                            "TimeStamp" : FieldValue.serverTimestamp()
                        ]
                        
                        self?.db.collection("Users/\(docID)/FeedbackData")
                            .addDocument(data: data, completion: { error in
                                if let error = error {
                                    print(error.localizedDescription)
                                    self?.alertItem2ForFeedbackSupportView = AlertItemModel(
                                        title: "Unable To Submit Feedback",
                                        message: error.localizedDescription
                                    )
                                } else {
                                    self?.uploadAmount += Double(100 - randomNumber)
                                    print("Feedback has Been Uploaded Successfully. 👍🏻👍🏻👍🏻")
                                    completionHandler(true)
                                }
                            })
                    }
                }
            }
        }
        
        guard let uploadTask = uploadTask else {
            return
        }
        
        uploadTask.observe(.progress) { snapshot in
            self.uploadAmount = snapshot.progress!.fractionCompleted * Double(randomNumber)
            print("Upload Amount: \(self.uploadAmount.description)")
        }
    }
}
