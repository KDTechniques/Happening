//
//  UploadGuidlinesView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-02-21.
//

import SwiftUI

struct UploadGuidlinesView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Note:")
                    .fontWeight(.semibold)
                    .padding(.bottom, 5)
                    .padding(.top)
                
                Text("You will need the Happening approval to update your profile photo.")
            }
            .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Do's:")
                    .fontWeight(.semibold)
                    .padding(.bottom, 5)
                
                Text("Must provide an authentic photo of yourself. It may speed up your profile photo approval process.")
                
                Text("Your face must be seen in the photo properly.")
            }
            .foregroundColor(.primary)
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Don'ts:")
                    .fontWeight(.semibold)
                    .padding(.bottom, 5)
                
                Text("Group photos are not allowed.")
                
                Text("Full body photo poses are allowed but can't cover your face with any type of object or body part except spectacle glasses.")
                
                Text("Any sexual or improper photo may ban your account.")
            }
            .foregroundColor(.red)
        }
        .font(.footnote)
        .padding(.bottom)
        .padding(.horizontal)
    }
}

struct UploadGuidlinesView_Previews: PreviewProvider {
    static var previews: some View {
        UploadGuidlinesView()
    }
}
