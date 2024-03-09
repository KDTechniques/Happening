//
//  HappeningAddress.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-03-07.
//

import SwiftUI

struct HappeningAddress: View {
    
    @EnvironmentObject var createAHappeningVM: CreateAHappeningViewModel
    
    var body: some View {
        Section {
            TextField("Address", text: $createAHappeningVM.happeningAddressTextFieldText)
                .onChange(of: createAHappeningVM.happeningAddressTextFieldText) { _ in
                    createAHappeningVM.createAHappeningValidation()
                }
        } header: {
            Text("Address of the Location")
                .font(.footnote)
        } footer: {
            VStack(alignment: .leading, spacing: 5) {
                Text("*must have at least 10 characters.")
                Text("You can edit the address if needed.")
            }
        }
    }
}

struct HappeningAddress_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            List {
                HappeningAddress()
            }
            
            List {
                HappeningAddress()
            }
            .preferredColorScheme(.dark)
        }
        .listStyle(.grouped)
        .environmentObject(CreateAHappeningViewModel())
    }
}
