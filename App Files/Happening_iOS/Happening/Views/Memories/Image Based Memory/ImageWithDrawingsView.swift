//
//  ImageWithDrawingsView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-01-06.
//

import SwiftUI

struct ImageWithDrawingsView: View {
    
    // MARK: PROPERTIES
    @State var imageBasedMemoryVM = ImageBasedMemoryViewModel.shared
    
    @FocusState.Binding var isTextEditorFocused: Bool
    
    @GestureState private var pinchMagnification: CGFloat = 1
    
    // MARK: BODY
    var body: some View {
        ZStack {
            if(imageBasedMemoryVM.image != nil) {
                Image(uiImage: imageBasedMemoryVM.image!)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .offset(x: imageBasedMemoryVM.imagedragOffset.width + imageBasedMemoryVM.imagePosition.width, y: imageBasedMemoryVM.imagedragOffset.height + imageBasedMemoryVM.imagePosition.height)
                    .onTapGesture {
                        self.isTextEditorFocused = false
                    }
                    .scaleEffect(imageBasedMemoryVM.currentMagnification * self.pinchMagnification)
                    .gesture(
                        MagnificationGesture()
                            .updating($pinchMagnification, body: { (value, state, _) in
                                state = value
                            })
                            .onEnded {
                                imageBasedMemoryVM.imageMagnificationGestureOnEnded(value: $0)
                            }
                    )
                    .simultaneousGesture(
                        DragGesture()
                            .onChanged {
                                if(!imageBasedMemoryVM.drawingButtonOpacity) {
                                    imageBasedMemoryVM.imagedragOffset = $0.translation
                                }
                            }
                            .onEnded {
                                if(!imageBasedMemoryVM.drawingButtonOpacity) {
                                    imageBasedMemoryVM.imagePosition.width += $0.translation.width
                                    imageBasedMemoryVM.imagePosition.height += $0.translation.height
                                    imageBasedMemoryVM.imagedragOffset = .zero
                                }
                            }
                    )
                    .alert(isPresented: $imageBasedMemoryVM.isAlertPresented) {
                        Alert(title: Text("Image Failed"), message: Text("An error occurred."), dismissButton: .cancel(Text("OK")))
                    }
            }
            
            DrawingCanvasView(canvasView: $imageBasedMemoryVM.canvasView,
                              dragOffset: $imageBasedMemoryVM.dragOffset,
                              lineColor: $imageBasedMemoryVM.currentColor)
                .offset(x: imageBasedMemoryVM.imagedragOffset.width + imageBasedMemoryVM.imagePosition.width, y: imageBasedMemoryVM.imagedragOffset.height + imageBasedMemoryVM.imagePosition.height)
                .onTapGesture {
                    self.isTextEditorFocused = false
                }
                .scaleEffect(imageBasedMemoryVM.currentMagnification * self.pinchMagnification)
                .gesture(
                    MagnificationGesture()
                        .updating($pinchMagnification, body: { (value, state, _) in
                            state = value
                        })
                        .onEnded {
                            imageBasedMemoryVM.DrawingCanvasViewMagnificationGestureOnEnded(value: $0)
                        }
                )
                .disabled(!imageBasedMemoryVM.drawingButtonOpacity)
                .alert(isPresented: $imageBasedMemoryVM.isPresentedDrawingClearAlert) {
                    Alert(title: Text("Discard photo?"),
                          message: Text("If you discard now, you'll lose your photo and edits."),
                          primaryButton: .default(Text("Keep")),
                          secondaryButton: .destructive(Text("Discard")) {imageBasedMemoryVM.resetCameraSheet()})
                }
        }
        .edgesIgnoringSafeArea(.all)
        .background(Color.black)
    }
}

// MARK: PREVIEWS
struct ImageWithDrawingsView_Previews: PreviewProvider {
    
    @FocusState static var fieldInFocus: Bool
    
    static var previews: some View {
        ImageWithDrawingsView(isTextEditorFocused: $fieldInFocus)
            .environmentObject(ImageBasedMemoryViewModel())
    }
}
