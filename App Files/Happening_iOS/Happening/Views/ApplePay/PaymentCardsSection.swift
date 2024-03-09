//
//  PaymentCardsSection.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-02-08.
//

import SwiftUI
import AVFoundation

struct PaymentCardsSection: View {
    
    @EnvironmentObject var biometricAuthenticationAnimationViewModel: BiometricAuthenticationAnimationViewModel
    
    @State private var isSelectedCard1: Bool = false
    @State private var isSelectedCard2: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Button {
                    biometricAuthenticationAnimationViewModel.isPresentedPaymentsCardsSheet = false
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
                Text("Payment Method")
                    .foregroundColor(.primary)
                    .font(.headline.weight(.semibold))
            )
            
            List {
                Section {
                    PaymentCardDetails(cardType: .combank, isSelected: $isSelectedCard1)
                        .onTapGesture {
                            if(isSelectedCard2) {
                                isSelectedCard1 = true
                                isSelectedCard2 = false
                            }
                            biometricAuthenticationAnimationViewModel.applePaySheetData?.cardType = .combank
                        }
                    
                    PaymentCardDetails(cardType: .hsbc, isSelected: $isSelectedCard2)
                        .onTapGesture {
                            if(isSelectedCard1) {
                                isSelectedCard2 = true
                                isSelectedCard1 = false
                            }
                            biometricAuthenticationAnimationViewModel.applePaySheetData?.cardType = .hsbc
                        }
                } header: {
                    Text("SELECT HOW YOU WANT TO PAY")
                        .foregroundColor(.secondary)
                }
            }
            .refreshable { }
        }
        .padding(.top)
        .background(Color(UIColor.systemGray6))
        .edgesIgnoringSafeArea(.bottom)
        .onAppear {
            if let cardType = biometricAuthenticationAnimationViewModel.applePaySheetData?.cardType {
                if(cardType == .combank) {
                    isSelectedCard1 = true
                } else {
                    isSelectedCard2 = true
                }
            }
        }
    }
}

struct PaymentCardsSection_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PaymentCardsSection()
            PaymentCardsSection().preferredColorScheme(.dark)
        }
        .environmentObject(ColorTheme())
        .environmentObject(BiometricAuthenticationAnimationViewModel())
    }
}

struct PaymentCardDetails: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var color: ColorTheme
    
    let cardType: BiometricAuthenticationAnimationViewModel.CardTypes
    var cardImageName: String {
        if(cardType == .combank) {
            return "ComBankVisaDebitCard"
        }  else {
            return "HSBCVisaDebitCard"
        }
    }
    var cardName: String {
        if(cardType == .combank) {
            return "COMBANK VISA DEBIT CARD"
        }  else {
            return "HSBC VISA DEBIT CARD"
        }
    }
    var cardNumber: String {
        if(cardType == .combank) {
            return "7284"
        }  else {
            return "8253"
        }
    }
    
    @Binding var isSelected: Bool
    
    var body: some View {
        HStack {
            Image(cardImageName)
                .resizable()
                .scaledToFit()
                .frame(height: 40)
            
            VStack(alignment: .leading) {
                Text(cardName)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                HStack(spacing: 3) {
                    Text("....")
                        .fontWeight(.black)
                        .offset(y: -3)
                    
                    Text(cardNumber)
                }
                .font(.subheadline)
                .foregroundColor(.gray)
            }
            
            Spacer()
            
            Image(systemName: "checkmark")
                .font(.body.weight(.medium))
                .foregroundColor(color.accentColor)
                .opacity(isSelected ? 1 : 0)
        }
        .padding(.vertical)
        .background(colorScheme == .light ? .white : Color(UIColor.secondarySystemBackground))
    }
}
