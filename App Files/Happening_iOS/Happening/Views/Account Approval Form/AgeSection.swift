//
//  AgeSection.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-12-23.
//

import SwiftUI

struct AgeSection: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var approvalFormViewModel: ApprovalFormViewModel
    
    // MARK: BODY
    var body: some View {
        TextField("Age", text: $approvalFormViewModel.formData.age)
            .disabled(true)
    }
}

// MARK: PREVIEW
struct AgeSection_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                Form {
                    Section{
                        AgeSection()
                            .preferredColorScheme(.dark)
                    }
                }
            }
            NavigationView {
                Form {
                    Section{
                        AgeSection()
                    }
                }
            }
        }
        .environmentObject(ApprovalFormViewModel())
    }
}
