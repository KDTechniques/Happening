//
//  ApplePayPaymentModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-02-07.


import Foundation

struct ApplePaySheetModel {
    var cardType: BiometricAuthenticationAnimationViewModel.CardTypes
    var cardImage: String {
        if(cardType == .combank) {
            return "ComBankVisaDebitCard"
        } else {
            return "HSBCVisaDebitCard"
        }
    }
    var cardName: String {
        if(cardType == .combank) {
            return "COMBANK VISA DEBIT CARD"
        } else {
            return "HSBC VISA DEBIT CARD"
        }
    }
    var cardNumber: String {
        if(cardType == .combank) {
            return "7284"
        } else {
            return "8253"
        }
    }
}
