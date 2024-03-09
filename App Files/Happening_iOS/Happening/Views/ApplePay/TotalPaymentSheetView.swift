//
//  TotalPaymentSheetView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-02-08.
//

import SwiftUI

struct TotalPaymentSheetView: View {
    
    @EnvironmentObject var biometricAuthenticationAnimationViewModel: BiometricAuthenticationAnimationViewModel
    
    let fee: String
    let activity: String
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Button {
                    biometricAuthenticationAnimationViewModel.isPresentedTotalPaymentSheet = false
                } label: {
                    Circle().fill(Color(UIColor.systemGray5))
                        .frame(width:30, height: 30)
                        .clipShape(Circle())
                        .overlay(
                            Image(systemName: "xmark")
                                .font(.subheadline.weight(.bold))
                                .foregroundColor(.gray)
                        )
                }
                .padding(.trailing)
            }
            .overlay(
                Text("Summary")
                    .foregroundColor(.primary)
                    .font(.headline.weight(.semibold))
            )
            
            Spacer()
            
            List {
                Section {
                    HStack {
                        Text(activity)
                            .lineLimit(1)
                        Spacer()
                        Text(fee)
                    }
                    .foregroundColor(.primary)
                } header: {
                    Text("Summary")
                        .foregroundColor(.secondary)
                }
                
                Section {
                    HStack {
                        Text("Total")
                            .font(.headline)
                        
                        Spacer()
                        
                        Text(fee)
                            .font(.system(size: 30, weight: .semibold, design: .rounded))
                    }
                    .padding(.vertical, 8)
                    .foregroundColor(.primary)
                }
            }
            .refreshable { }
        }
        .padding(.top)
        .background(Color(UIColor.systemGray6))
    }
}

struct TotalPaymentSheetView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TotalPaymentSheetView(fee: "LKR1000", activity: "Assembling a Gaming PC 💻")
                .preferredColorScheme(.dark)
            
            TotalPaymentSheetView(fee: "LKR1000", activity: "Assembling a Gaming PC 💻")
        }
        .environmentObject(BiometricAuthenticationAnimationViewModel())
        .environmentObject(ColorTheme())
    }
}
