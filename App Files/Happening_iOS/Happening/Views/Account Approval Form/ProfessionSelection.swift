//
//  ProfessionSelection.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-12-30.
//

import SwiftUI

struct ProfessionSelection: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var approvalFormViewModel: ApprovalFormViewModel
    
    // MARK: BODY
    var body: some View {
        HStack {
            Text("Profession")
            
            Spacer()
            
            Picker(selection: $approvalFormViewModel.formData.profession) {
                ForEach(ProfessionType.allCases, id: \.self) { professionValue in
                    Text(professionValue.rawValue)
                        .tag(professionValue)
                }
            } label: {
                Text("Profession")
            }
            .pickerStyle(.menu)
        }
    }
}

// MARK: PREVIEWS
struct ProfessionSelection_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                Form {
                    Section{
                        ProfessionSelection()
                            .preferredColorScheme(.dark)
                    }
                }
            }
            NavigationView {
                Form {
                    Section{
                        ProfessionSelection()
                    }
                }
            }
        }
        .environmentObject(ApprovalFormViewModel())
    }
}
