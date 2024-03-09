//
//  FunctionTester.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-03-27.
//

import SwiftUI
import UIKit
import Firebase

struct FunctionTester: View {
    
    @EnvironmentObject var vm: MemoriesViewModel
    
    @State private var text1: String = ""
    @State private var text2: String = ""
    
    @State private var isContain: Bool = false
    
    var body: some View {
        VStack {
            TextField("jbdfsfkjbv", text: $text1)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .padding(.horizontal)
                .background(.red)
                
            
            TextField("jbdfsfkjbv", text: $text2)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .padding(.horizontal)
                .background(.blue)
            
            Text(isContain ?  "true" : "false")
            
            ButtonView(name: "Test") {
                if text1.contains(text2) {
                    isContain = true
                } else {
                    isContain = false
                }
            }
        }
        .padding()
    }
}

struct FunctionTester_Previews: PreviewProvider {
    static var previews: some View {
        FunctionTester()
            .environmentObject(MemoriesViewModel())
            .environmentObject(ColorTheme())
    }
}
