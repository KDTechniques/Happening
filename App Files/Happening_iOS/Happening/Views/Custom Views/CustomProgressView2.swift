//
//  CustomProgressView2.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-02-26.
//

import SwiftUI

struct CustomProgressView2: View {
    
    @EnvironmentObject var color: ColorTheme
    @EnvironmentObject var feedbackSupportViewModel: FeedbackSupportViewModel
    
    let text: String
    let uploadAmount: Double
    let cancelButtonAction: () -> ()
    
    var body: some View {
        VStack {
            Text(text)
                .font(.headline.weight(.semibold))
                .padding(.vertical, 20)
                .lineLimit(1)
            
            ProgressView(value: uploadAmount, total: 100)
                .progressViewStyle(.linear)
                .padding(.horizontal, 10)
            
            Divider()
                .padding(.top)
            
            Button {
                cancelButtonAction()
            } label: {
                Text("Cancel")
                    .fontWeight(.semibold)
                    .foregroundColor(color.accentColor)
            }
            .padding(.top, 4)
            .padding(.bottom, 12)
            
        }
        .background(.ultraThinMaterial)
        .cornerRadius(10)
        .padding(.horizontal, 74)
    }
}

struct CustomProgressView2_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CustomProgressView2(text: "Sending 1 of 1...", uploadAmount: 30, cancelButtonAction: {})
                .preferredColorScheme(.dark)
            
            CustomProgressView2(text: "Sending 1 of 1...", uploadAmount: 70, cancelButtonAction: {})
        }
        .environmentObject(ColorTheme())
        .environmentObject(FeedbackSupportViewModel())
    }
}
