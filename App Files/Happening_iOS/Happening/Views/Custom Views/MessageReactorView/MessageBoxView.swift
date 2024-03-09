//
//  MessageBoxView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-05-30.
//

import SwiftUI

struct MessageBoxView: View {
    
    let profilePhotoThumURL: String
    let msgText: String
    let sentTime: String
    
    var body: some View {
        RecieversTextMessageView(
            profilePhotoThumbnailURL: profilePhotoThumURL,
            msgText: msgText,
            time: sentTime,
            reaction: .none
        )
    }
}

struct MessageBoxView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MessageBoxView(
                profilePhotoThumURL: "https://storage.googleapis.com/happening-8133c.appspot.com/Profile%20Data/Profile%20Pictures/dgoP2Pxr5uY7gTlAb9TeIyZWiSE3/30984312-81C4-469A-A425-1D78B4B710D8_THUMB?GoogleAccessId=firebase-adminsdk-apv26%40happening-8133c.iam.gserviceaccount.com&Expires=3029529600&Signature=sFOQyWYCVFytW%2F2NOxRD6jFnDDzyO7zzdDVsAJF5jKyL1Cs9jqfwpHjyOKQ6NjcT4QCCy41%2F4r9jyQW8iPDlMbsLT039CD0g3%2F70O%2BCpFlgb2onwfXn5hvIwLvKmg9VQkuyIER%2FWOUDzguOlPzsClDhxBk0Pvoj3qCvGHEHHYdpN6dhIrP2EEL6U83trcZyamib%2BeP0adzkzPUVobelrLmYq0zcmAUIrYIuD2dEX%2FhPPg8h6k15YN03FN065F30wlh62cBb42HU0Y64ks28i0Tkz2XiPaUM5Ski8cxBWmTmKTAV8MPve8ukO5F5%2FWkc4JHppLsTwQSnTxTHvkyvFug%3D%3D",
                msgText: "Hello there...",
                sentTime: "4:55 PM"
            )
                .preferredColorScheme(.dark)
            
            MessageBoxView(
                profilePhotoThumURL: "https://storage.googleapis.com/happening-8133c.appspot.com/Profile%20Data/Profile%20Pictures/dgoP2Pxr5uY7gTlAb9TeIyZWiSE3/30984312-81C4-469A-A425-1D78B4B710D8_THUMB?GoogleAccessId=firebase-adminsdk-apv26%40happening-8133c.iam.gserviceaccount.com&Expires=3029529600&Signature=sFOQyWYCVFytW%2F2NOxRD6jFnDDzyO7zzdDVsAJF5jKyL1Cs9jqfwpHjyOKQ6NjcT4QCCy41%2F4r9jyQW8iPDlMbsLT039CD0g3%2F70O%2BCpFlgb2onwfXn5hvIwLvKmg9VQkuyIER%2FWOUDzguOlPzsClDhxBk0Pvoj3qCvGHEHHYdpN6dhIrP2EEL6U83trcZyamib%2BeP0adzkzPUVobelrLmYq0zcmAUIrYIuD2dEX%2FhPPg8h6k15YN03FN065F30wlh62cBb42HU0Y64ks28i0Tkz2XiPaUM5Ski8cxBWmTmKTAV8MPve8ukO5F5%2FWkc4JHppLsTwQSnTxTHvkyvFug%3D%3D",
                msgText: "Hello there...",
                sentTime: "4:55 PM"
            )
        }
        .padding(.leading)
    }
}
