//
//  ImageBasedMemoryOverlappingActionButtonsView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-01-07.
//

import SwiftUI

struct ImageBasedMemoryOverlappingActionButtonsView: View {
    
    // MARK: PROPERTIES
    @Environment(\.undoManager) var undoManager
    @EnvironmentObject var imageBasedMemoryVM: ImageBasedMemoryViewModel
    
    // MARK: BODY
    var body: some View {
        HStack {
            Button {
                if(imageBasedMemoryVM.canvasView.drawing.bounds.isEmpty) {
                    imageBasedMemoryVM.resetCameraSheet()
                } else {
                    imageBasedMemoryVM.isPresentedDrawingClearAlert = true
                }
            } label: {
                Image(systemName: "xmark")
                    .font(.body.weight(.semibold))
                    .foregroundColor(Color.white)
                    .padding(.leading)
                    .padding(.top)
            }
            
            Spacer()
            
            HStack(spacing: 12) {
                // Undo button
                Button {
                    self.undoManager?.undo()
                } label: {
                    Image(systemName: "arrowshape.turn.up.left")
                        .frame(width: 40, height: 40)
                }
                
                // Drawing Button
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        imageBasedMemoryVM.colorPickerHeight = (imageBasedMemoryVM.drawingButtonOpacity ? 0 : 180)
                        imageBasedMemoryVM.drawingButtonOpacity.toggle()
                    }
                } label: {
                    ZStack {
                        Image(systemName: "pencil.and.outline")
                            .opacity(imageBasedMemoryVM.isTouching ? 0 : 1)
                        
                        Circle()
                            .strokeBorder(Color.black,lineWidth: 0.1)
                            .background(Circle().foregroundColor(Color.white))
                            .opacity(imageBasedMemoryVM.isTouching ? 1 : 0)
                            .frame(width: (imageBasedMemoryVM.dragOffset.width * -1) / 28 > 1
                                   ? (imageBasedMemoryVM.dragOffset.width * -1) / 28
                                   : 2
                            )
                    }
                    .frame(width: 40, height: 40)
                    .background(Circle().fill(imageBasedMemoryVM.currentColor).opacity(imageBasedMemoryVM.drawingButtonOpacity ? 1 : 0))
                }
                .overlay(alignment: .top) {
                    VerticalColorPickerView(chosenColor: $imageBasedMemoryVM.currentColor,
                                            dragOffset: $imageBasedMemoryVM.dragOffset,
                                            linearGradientHeight: $imageBasedMemoryVM.colorPickerHeight,
                                            isTouching: $imageBasedMemoryVM.isTouching)
                        .offset(x: 0, y: 55)
                }
                
            }
            .padding(.trailing)
            .font(.body.weight(.semibold))
            .foregroundColor(Color.white)
        }
    }
}

// MARK: PREVIEWS
struct ImageBasedMemoryOverlappingActionButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ImageBasedMemoryOverlappingActionButtonsView()
                .preferredColorScheme(.dark)
            Spacer()
        }
        .environmentObject(MemoriesViewModel())
        .environmentObject(ImageBasedMemoryViewModel())
    }
}
