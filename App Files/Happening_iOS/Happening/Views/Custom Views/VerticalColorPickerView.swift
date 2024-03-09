//
//  VerticalColorPickerView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-12-09.
//

import SwiftUI

struct VerticalColorPickerView: View {
    @Binding var chosenColor: Color
    @State private var startLocation: CGFloat = .zero
    @Binding var dragOffset: CGSize
    @Binding var linearGradientHeight: CGFloat
    @Binding var isTouching: Bool
    
    init(chosenColor: Binding<Color>,
         dragOffset: Binding<CGSize>,
         linearGradientHeight: Binding<CGFloat>,
         isTouching: Binding<Bool>
    ) {
        _chosenColor = chosenColor
        _dragOffset = dragOffset
        _linearGradientHeight = linearGradientHeight
        _isTouching = isTouching
    }
    
    private var colors: [Color] = {
        let hueValues = Array(0...359)
        return hueValues.map {
            Color(UIColor(hue: CGFloat($0) / 359.0 ,
                          saturation: 1.0,
                          brightness: 1.0,
                          alpha: 1.0))
        }
    }()
    
    private var currentColor: Color {
        Color(UIColor.init(hue: self.normalizeGesture() / linearGradientHeight, saturation: 1.0, brightness: 1.0, alpha: 1.0))
    }
    
    private func normalizeGesture() -> CGFloat {
        let offset = startLocation + dragOffset.height // Using our starting point, see how far we've dragged +- from there
        let maxY = max(0, offset) // We want to always be greater than 0, even if their finger goes outside our view
        let minY = min(maxY, linearGradientHeight) // We want to always max at 200 even if the finger is outside the view.
        
        return minY
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: colors),
                           startPoint: .top,
                           endPoint: .bottom)
                .frame(width: 14, height: linearGradientHeight)
                .cornerRadius(.infinity)
                .overlay(
                    RoundedRectangle(cornerRadius: .infinity).stroke(Color.white, lineWidth: 2.0)
                )
                .gesture(
                    DragGesture().onChanged({ (value) in
                        self.dragOffset = value.translation
                        self.startLocation = value.startLocation.y
                        self.chosenColor = self.currentColor
                        isTouching = true
                    })
                        .onEnded({ _ in
                            isTouching = false
                        })
                )
        }
    }
}

struct VerticalColorPickerView_Previews: PreviewProvider {
    static var previews: some View {
        VerticalColorPickerView(chosenColor: Binding.constant(Color.white), dragOffset: Binding.constant(.zero), linearGradientHeight: Binding.constant(180),isTouching: Binding.constant(false))
    }
}
