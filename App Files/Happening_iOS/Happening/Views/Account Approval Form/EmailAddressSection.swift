//
//  EmailAddressSection.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-12-23.
//

import SwiftUI

struct EmailAddressSection: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var approvalFormViewModel: ApprovalFormViewModel
    
    // controls the state of the email address field
    @FocusState.Binding var fieldInFocus: ApprovalFormViewModel.FieldType?
    
    // MARK: BODY
    var body: some View {
        TextField("Email Address", text: $approvalFormViewModel.formData.email)
            .keyboardType(.emailAddress)
            .focused($fieldInFocus, equals: .email)
            .onChange(of: approvalFormViewModel.formData.email, perform: { _ in
                approvalFormViewModel.enabelSubmitButton()
            })
            .onAppear(perform: {
                if(approvalFormViewModel.isChangedAccentColorAddressField && approvalFormViewModel.formData.email.isEmpty) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { self.fieldInFocus = .email }
                }
            })
            .alert(item: $approvalFormViewModel.alertItemForEmailAddressSection) { alert -> Alert in
                Alert(
                    title: Text(alert.title),
                    message: Text(alert.message),
                    dismissButton: .cancel(Text("OK")) {
                        self.fieldInFocus = .email
                    }
                )
            }
            .submitLabel(.next)
            .onSubmit {
                // new iphones can focus a text field faster(less than 0.1 sec.) but older iphones need 0.1 sec.
                self.fieldInFocus = .phoneNo
                // 0.1 sec delay help the older iphone to focus a text field properly
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.fieldInFocus = .phoneNo
                }
            }
    }
}

// MARK: PREVIEW
struct EmailAddressSection_Previews: PreviewProvider {
    
    @FocusState static var fieldInFocus: ApprovalFormViewModel.FieldType?
    
    static var previews: some View {
        Group {
            NavigationView {
                Form {
                    Section{
                        EmailAddressSection(fieldInFocus: $fieldInFocus)
                            .preferredColorScheme(.dark)
                    }
                }
            }
            NavigationView {
                Form {
                    Section{
                        EmailAddressSection(fieldInFocus: $fieldInFocus)
                    }
                }
            }
        }
        .environmentObject(ApprovalFormViewModel())
    }
}
