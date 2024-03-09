//
//  CustomProgressView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-02-26.
//

import SwiftUI

struct CustomProgressView1: View {
    
    @Binding var text: String
    
    var body: some View {
        HStack {
            ProgressView()
                .tint(.secondary)
            
            Text(text)
                .font(.system(size: 14))
                .padding(.leading, 6)
        }
    }
}

struct CustomProgressView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CustomProgressView1(text: Binding.constant("Updating..."))
                .preferredColorScheme(.dark)
            
            CustomProgressView1(text: Binding.constant("Restting..."))
        }
        .previewLayout(.sizeThatFits)
    }
}
