//
//  HappeningDescription.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-03-07.
//

import SwiftUI

struct HappeningDescription: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var createAHappeningVM: CreateAHappeningViewModel
    
    var body: some View {
        Section {
            TextEditor(text: $createAHappeningVM.happeningDescriptionTextEditorText)
                .frame(height: 100)
                .padding(.horizontal)
                .frame(height: 120)
                .background(colorScheme == .light ? Color.black.opacity(0.05) : Color.black.opacity(0.5))
                .cornerRadius(10)
                .padding(.vertical)
                .overlay(
                    Text("\(createAHappeningVM.happeningDescriptionTextEditorText.count)/\(createAHappeningVM.happeningDescriptionTextEditorTextLimit)")
                        .foregroundColor(createAHappeningVM.happeningDescriptionTextEditorTextLimitColor)
                        .font(.system(size: 10))
                        .offset(x: 0, y: 1)
                        .onChange(of: createAHappeningVM.happeningDescriptionTextEditorText) { _ in
                            createAHappeningVM.limitHappeningDescriptionText()
                            createAHappeningVM.createAHappeningValidation()
                        }
                    , alignment: .bottomTrailing
                )
        } header: {
            Text("Description")
                .font(.footnote)
        } footer: {
            Text("*must have at least 10 characters.")
                .font(.footnote)
        }
    }
}

struct HappeningDescription_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            List {
                HappeningDescription()
            }
            
            List {
                HappeningDescription()
            }
            .preferredColorScheme(.dark)
        }
        .listStyle(.grouped)
        .environmentObject(CreateAHappeningViewModel())
    }
}
