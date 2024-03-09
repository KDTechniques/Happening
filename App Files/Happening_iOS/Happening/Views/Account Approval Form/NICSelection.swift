//
//  NICSelection.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-12-23.
//

import SwiftUI

struct NICSelection: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var approvalFormViewModel: ApprovalFormViewModel
    
    // controls the focus state of the nic field
    @FocusState.Binding var fieldInFocus: ApprovalFormViewModel.FieldType?
    
    // MARK: BODY
    var body: some View {
        TextField("NIC No", text: $approvalFormViewModel.formData.nic)
            .keyboardType(.alphabet)
            .focused($fieldInFocus, equals: .nic)
            .onAppear(perform: {
                if(approvalFormViewModel.isChangedAccentColorNameField && approvalFormViewModel.formData.nic.isEmpty) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { self.fieldInFocus = .nic }
                }
            })
            .onChange(of: approvalFormViewModel.formData.nic) { _ in
                approvalFormViewModel.removeLast(variable: $approvalFormViewModel.formData.nic, characterType: .nic)
                approvalFormViewModel.nicNoValidation()
            }
            .alert(item: $approvalFormViewModel.alertItemForNICSection) { alert -> Alert in
                Alert(
                    title: Text(alert.title),
                    message: Text(alert.message)
                )
            }
            .submitLabel(.next)
            .onSubmit {
                if(!approvalFormViewModel.formData.nic.isEmpty) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.easeInOut(duration: 0.45)){
                            approvalFormViewModel.isPresentedDatePicker = true
                        }
                    }
                }
            }
    }
}

// MARK: PREVIEW
struct NICSelection_Previews: PreviewProvider {
    
    @FocusState static var fieldInFocus: ApprovalFormViewModel.FieldType?
    
    static var previews: some View {
        Group {
            NavigationView {
                Form {
                    Section{
                        NICSelection(fieldInFocus: $fieldInFocus)
                            .preferredColorScheme(.dark)
                    }
                }
            }
            NavigationView {
                Form {
                    Section{
                        NICSelection(fieldInFocus: $fieldInFocus)
                    }
                }
            }
        }
        .environmentObject(ApprovalFormViewModel())
    }
}
