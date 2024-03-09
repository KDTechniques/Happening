//
//  DrawingCanvasView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-12-09.
//

import SwiftUI
import PencilKit

struct DrawingCanvasView: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView
    @Binding var dragOffset: CGSize
    @Binding var lineColor: Color
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.drawingPolicy = .anyInput
        canvasView.backgroundColor = .clear
        return canvasView
    }
    
    func updateUIView(_ canvasView: PKCanvasView, context: Context) {
        canvasView.tool = PKInkingTool(.pen, color: UIColor(lineColor), width: dragOffset.width < 0 ? (dragOffset.width * -1) / 7 : 8)
    }
}

