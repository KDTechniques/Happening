//
//  TotalPaymentNavigationSection.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-02-07.
//

import SwiftUI

struct TotalPaymentNavigationSection: View {
    
    @EnvironmentObject var biometricAuthenticationAnimationViewModel: BiometricAuthenticationAnimationViewModel
    
    let fee: String
    
    var body: some View {
        Button(action: {
            biometricAuthenticationAnimationViewModel.isPresentedTotalPaymentSheet = true
        }, label: {
            HStack {
                VStack(alignment: .leading) {
                    Text("Pay Total")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text(fee)
                        .font(.title.weight(.semibold))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundColor(Color(UIColor.systemGray2))
                    .padding(.horizontal)
            }
            .foregroundColor(.black)
        })
            .padding(.horizontal)
    }
}

struct TotalPaymentNavigationSection_Previews: PreviewProvider {
    static var previews: some View {
        TotalPaymentNavigationSection(fee: "1000LKR")
            .previewLayout(.sizeThatFits)
            .environmentObject(BiometricAuthenticationAnimationViewModel())
            .environmentObject(ColorTheme())
    }
}
