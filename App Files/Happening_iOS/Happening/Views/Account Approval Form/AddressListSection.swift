//
//  AddressListSection.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-12-23.
//

import SwiftUI

struct AddressListSection: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var color: ColorTheme
    @EnvironmentObject var approvalFormViewModel: ApprovalFormViewModel
    
    // control the focus state of address fields
    @FocusState.Binding var fieldInFocus: ApprovalFormViewModel.FieldType?
    
    // MARK: BODY
    var body: some View {
        NavigationLink {
            List {
                // street 1
                HStack {
                    Text("Street")
                        .frame(width:100, alignment: .leading)
                    TextField("required", text: $approvalFormViewModel.formData.street1)
                        .focused($fieldInFocus, equals: .street1)
                        .onChange(of: approvalFormViewModel.formData.street1) { _ in
                            approvalFormViewModel.removeLast(variable: $approvalFormViewModel.formData.street1, characterType: .address)
                            approvalFormViewModel.addressValidation()
                        }
                        .submitLabel(.next)
                        .onSubmit {
                            self.fieldInFocus = .street2
                        }
                }
                .onAppear(perform: {
                    DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.6) {
                        if(approvalFormViewModel.formData.street1.isEmpty) {
                            self.fieldInFocus = .street1
                        }
                    }
                })
                
                // street 2
                HStack {
                    Text("Street")
                        .frame(width:100, alignment: .leading)
                    TextField("optional", text: $approvalFormViewModel.formData.street2)
                        .focused($fieldInFocus, equals: .street2)
                        .onChange(of: approvalFormViewModel.formData.street2) { _ in
                            approvalFormViewModel.removeLast(variable: $approvalFormViewModel.formData.street2, characterType: .address)
                            approvalFormViewModel.addressValidation()
                        }
                        .submitLabel(.next)
                        .onSubmit {
                            self.fieldInFocus = .city
                        }
                }
                
                // city
                HStack {
                    Text("City")
                        .frame(width:100, alignment: .leading)
                    TextField("required", text: $approvalFormViewModel.formData.city)
                        .focused($fieldInFocus, equals: .city)
                        .onChange(of: approvalFormViewModel.formData.city) { _ in
                            approvalFormViewModel.removeLast(variable: $approvalFormViewModel.formData.city, characterType: .alphabetical)
                            approvalFormViewModel.addressValidation()
                        }
                        .submitLabel(.next)
                        .onSubmit {
                            self.fieldInFocus = .postcode
                        }
                }
                
                // post code
                HStack {
                    Text("Postcode")
                        .frame(width:100, alignment: .leading)
                    TextField("required", text: $approvalFormViewModel.formData.postCode)
                        .focused($fieldInFocus, equals: .postcode)
                        .keyboardType(.asciiCapableNumberPad)
                        .onChange(of: approvalFormViewModel.formData.postCode) { _ in
                            approvalFormViewModel.addressValidation()
                        }
                }
            }
            .keyboardType(.alphabet)
            .toolbar(content: {
                ToolbarItem(placement: .principal) { Text("Permanent Address").fontWeight(.semibold) }
                ToolbarItem(placement: .keyboard) { HideKeyboardPlacementView() }
            })
        } label: {
            Text(approvalFormViewModel.formData.address)
                .foregroundColor(approvalFormViewModel.isChangedAccentColorAddressField ? .primary : color.accentColor)
                .lineLimit(1)
        }
        .alert(item: $approvalFormViewModel.alertItemForAddressListSection) { alert -> Alert in
            Alert(
                title: Text(alert.title),
                message: Text(alert.message)
            )
        }
    }
}

// MARK: PREVIEW
struct AddressListSection_Previews: PreviewProvider {
    
    @FocusState static var fieldInFocus: ApprovalFormViewModel.FieldType?
    
    static var previews: some View {
        Group {
            NavigationView {
                Form {
                    Section{
                        AddressListSection(fieldInFocus: $fieldInFocus)
                            .preferredColorScheme(.dark)
                    }
                }
            }
            NavigationView {
                Form {
                    Section{
                        AddressListSection(fieldInFocus: $fieldInFocus)
                    }
                }
            }
        }
        .environmentObject(ApprovalFormViewModel())
        .environmentObject(ColorTheme())
    }
}
