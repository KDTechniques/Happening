//
//  FeedbackSupportModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-01-05.
//

import Foundation
import UIKit

struct FeedbackSupportModel {
    var feedbackType: FeedbackTypes.RawValue
    var screenshotImage: UIImage?
    var feedbackText: String
    var contactUser: Bool
}

// feedback types
enum FeedbackTypes: String {
    case like = "😍 I Like Something"
    case dontLike = "🥴 I Don't Like Something"
    case suggestion = "😎 I Have A Suggestion"
}
