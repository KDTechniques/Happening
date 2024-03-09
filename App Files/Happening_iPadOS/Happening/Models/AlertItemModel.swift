//
//  AlertItemModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-02-16.
//

import Foundation
import SwiftUI

struct AlertItemModel: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    var dismissButton: Alert.Button?
}

