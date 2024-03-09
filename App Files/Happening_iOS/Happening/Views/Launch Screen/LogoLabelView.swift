//
//  LogoLabelView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-02-09.
//

import SwiftUI

struct LogoLabelView: View {
    
    // MARK: PROPERTIES
    @Binding var frame1: CGFloat
    @Binding var opacity1: CGFloat
    @Binding var offset1: CGFloat
    
    // MARK: BODY
    var body: some View {
        Image("LogoIcon")
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .foregroundColor(Color.primary)
            .frame(width: frame1)
            .opacity(opacity1)
            .offset(x: offset1)
    }
}

// MARK: PREVIEWS
struct LogoLabelView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LogoLabelView(frame1: Binding.constant(50), opacity1: Binding.constant(1), offset1: Binding.constant(.zero))
            LogoLabelView(frame1: Binding.constant(50), opacity1: Binding.constant(1), offset1: Binding.constant(.zero)).preferredColorScheme(.dark)
        }
    }
}
