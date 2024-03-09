//
//  GenderSelection.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-12-23.
//

import SwiftUI

struct GenderSelection: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var approvalFormViewModel: ApprovalFormViewModel
    
    // MARK: BODY
    var body: some View {
        Picker(selection: $approvalFormViewModel.formData.gender) {
            ForEach(GenderType.allCases, id: \.self) { genderValue in
                Text(genderValue.rawValue).tag(genderValue)
            }
        } label: {
            Text("Gender")
        }
        .pickerStyle(.segmented)
    }
}

// MARK: PREVIEW
struct GenderSelection_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                Form {
                    Section{
                        GenderSelection()
                            .preferredColorScheme(.dark)
                    }
                }
            }
            NavigationView {
                Form {
                    Section{
                        GenderSelection()
                    }
                }
            }
        }
        .environmentObject(ApprovalFormViewModel())
    }
}
