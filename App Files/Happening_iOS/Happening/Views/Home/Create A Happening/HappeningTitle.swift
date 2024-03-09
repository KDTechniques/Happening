//
//  HappeningTitle.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-03-07.
//

import SwiftUI

struct HappeningTitle: View {
    
    @EnvironmentObject var createAHappeningVM: CreateAHappeningViewModel
    
    var body: some View {
        Section {
            TextField("Title", text: $createAHappeningVM.happeningTitleTextFieldText)
                .onChange(of: createAHappeningVM.happeningTitleTextFieldText, perform: { _ in
                    createAHappeningVM.limitHappeningTitleText()
                    createAHappeningVM.createAHappeningValidation()
                })
                .overlay(alignment: .trailing) {
                    Text("(\(createAHappeningVM.happeningTitleCharactersCount - createAHappeningVM.happeningTitleTextFieldText.count))")
                        .foregroundColor(.secondary)
                }
        } header: {
            Text("Title")
                .font(.footnote)
        } footer: {
            VStack(alignment: .leading, spacing: 5) {
                Text("*must have at least 10 characters.")
                Text("(ex: Going to Cinema with Friends🎬🍿)")
            }
            .font(.footnote)
        }
    }
}

struct HappeningTitle_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            List {
                HappeningTitle()
            }
            
            List {
                HappeningTitle()
                    .preferredColorScheme(.dark)
            }
        }
        .listStyle(.grouped)
        .environmentObject(CreateAHappeningViewModel())
    }
}
