//
//  HappeningNoOfSpaces.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-03-07.
//

import SwiftUI

struct HappeningNoOfSpaces: View {
    
    @EnvironmentObject var createAHappeningVM: CreateAHappeningViewModel
    
    var body: some View {
        Section {
            Picker("Number of Spaces", selection: $createAHappeningVM.noOfSpaces) {
                ForEach((1...10), id: \.self) {
                    Text("\($0)")
                        .tag($0)
                }
            }
            .pickerStyle(.segmented)
        } header: {
            Text("Number Of Spaces")
        } footer: {
            Text("It means the number of followers you're inviting through Happening to the above location.")
        }
    }
}

struct HappeningNoOfSpaces_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            List {
                HappeningNoOfSpaces()
            }
            
            List {
                HappeningNoOfSpaces()
                    .preferredColorScheme(.dark)
            }
        }
        .listStyle(.grouped)
        .environmentObject(CreateAHappeningViewModel())
    }
}
