//
//  TapPositionTester.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-05-30.
//

import SwiftUI

struct TapPositionTester: View {
    
    let screenHeight: CGFloat = UIScreen.main.bounds.size.height
    let screenWidth: CGFloat = UIScreen.main.bounds.size.width
    
    @State private var contentHeight1: CGFloat = 0
    @State private var contentHeight2: CGFloat = 0
    
    @State private var showSheet: Bool = false
    
    var body: some View {
        ButtonView(name: "Open Sheet") {
            showSheet.toggle()
        }
        .sheet(isPresented: $showSheet) {
            VStack {
                    Rectangle()
                        .fill(.green)
                        .frame(width: screenWidth, height: 200)
                
                GeometryReader { proxy in
                    VStack(spacing: 5) {
                        ForEach(0...5, id: \.self) { _ in
                            Rectangle()
                                .fill(.green)
                                .frame(width: screenWidth, height: 100)
                                .onTapGesture {
                                    contentHeight2 = proxy.size.height
                                    print("Scroll  View Reader Height2: \(contentHeight2)")
                                }
                        }
                    }
                }
            }
        }
    }
}

struct TapPositionTester_Previews: PreviewProvider {
    static var previews: some View {
        TapPositionTester()
    }
}


/*
 
 VStack {
 Rectangle()
 .fill(.cyan)
 .onLongPressGesture(minimumDuration: 0.3) {
 vibrate(type: .success)
 print("Long Pressed.")
 }
 .gesture(DragGesture(minimumDistance: 0).onEnded({ (value) in
 print("Tap Height: \(value.location.y)") // Location of the tap, as a CGPoint.
 }))
 }
 
 */



/*
 
 struct OnTap: ViewModifier {
     let response: (CGPoint) -> Void
     
     @State private var location: CGPoint = .zero
     func body(content: Content) -> some View {
         content
             .onTapGesture {
                 response(location)
             }
             .simultaneousGesture(
                 DragGesture(minimumDistance: 0)
                     .onEnded { location = $0.location }
             )
     }
 }

 extension View {
     func onTapGesture(_ handler: @escaping (CGPoint) -> Void) -> some View {
         self.modifier(OnTap(response: handler))
     }
 }

 
 */
