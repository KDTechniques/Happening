//
//  ClearBackgroundView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-03-30.
//

import Foundation
import SwiftUI

struct BackgroundClearView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) { }
}
