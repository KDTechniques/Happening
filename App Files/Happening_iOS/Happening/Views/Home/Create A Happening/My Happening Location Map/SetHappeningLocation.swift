//
//  SetHappeningLocation.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-03-07.
//

import SwiftUI

struct SetHappeningLocation: View {
    
    @EnvironmentObject var color: ColorTheme
    @EnvironmentObject var createAHappeningVM: CreateAHappeningViewModel
    
    var body: some View {
        Section {
            HStack {
                Button("Set Location") {
                    createAHappeningVM.isPresentedSheetForMapView = true
                }
                .accentColor(color.accentColor)
                
                Spacer()
                
                HStack {
                    Text(createAHappeningVM.setLocationStatus.rawValue)
                    
                    Image(systemName: "checkmark.circle.fill")
                }
                .foregroundColor(createAHappeningVM.setLocationStatus == .notSet ? .secondary : .green)
            }
        } header: {
            Text("Set Location On Maps")
        } footer: {
            Text("*required")
        }
    }
}

struct SetHappeningLocation_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            List {
                SetHappeningLocation()
            }
            
            List {
                SetHappeningLocation()
                    .preferredColorScheme(.dark)
            }
        }
        .listStyle(.grouped)
        .environmentObject(CreateAHappeningViewModel())
        .environmentObject(ColorTheme())
    }
}
