//
//  QRCodeShareCardView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-01-04.
//

import SwiftUI

struct QRCodeShareCardView: View {
    
    // MARK: PROPERTIES
    
    // MARK: BODY
    var body: some View {
        ZStack {
            // background color will be always the app color to make the image more authentic & identifiable
            Color("AppColor")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                QRCodeCardView(backgroundColorType: Binding.constant(.staticColor))
                
                Text("Scan or upload this QR code using the Happening camera to follow me on Happening")
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .padding(.top, 50)
                    .foregroundColor(Color.white)
            }
            .padding(.horizontal, 35)
            .padding(.top, 55)
        }
    }
}

// MARK: PREVIEWS
struct QRCodeShareCardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            QRCodeShareCardView()
                .preferredColorScheme(.dark)
            
            QRCodeShareCardView()
        }
        .environmentObject(QRCodeViewModel())
    }
}
