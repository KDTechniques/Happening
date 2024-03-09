//
//  NameListSection.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-12-23.
//

import SwiftUI

struct NameListSection: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var color: ColorTheme
    @EnvironmentObject var approvalFormViewModel: ApprovalFormViewModel
    
    // control the focus state of name fields
    @FocusState.Binding var fieldInFocus: ApprovalFormViewModel.FieldType?
    
    // MARK: BODY
    var body: some View {
        NavigationLink {
            List {
                // first name field
                HStack {
                    Text("First")
                        .frame(width:100, alignment: .leading)
                    TextField("required", text: $approvalFormViewModel.formData.firstName)
                        .focused($fieldInFocus, equals: .firstName)
                        .onChange(of: approvalFormViewModel.formData.firstName) { _ in
                            approvalFormViewModel.removeLast(variable: $approvalFormViewModel.formData.firstName, characterType: .alphabetical)
                            approvalFormViewModel.nameValidation()
                        }
                        .submitLabel(.next)
                        .onSubmit {
                            fieldInFocus = .middleName
                        }
                }
                .onAppear(perform: {
                    DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.6) {
                        if(approvalFormViewModel.formData.firstName.isEmpty) {
                            self.fieldInFocus = .firstName
                        }
                    }
                })
                
                // middle name field
                HStack {
                    Text("Middle")
                        .frame(width:100, alignment: .leading)
                    TextField("optional", text: $approvalFormViewModel.formData.middleName)
                        .focused($fieldInFocus, equals: .middleName)
                        .onChange(of: approvalFormViewModel.formData.middleName) { _ in
                            approvalFormViewModel.removeLast(variable: $approvalFormViewModel.formData.middleName, characterType: .alphabetical)
                            approvalFormViewModel.nameValidation()
                        }
                        .submitLabel(.next)
                        .onSubmit {
                            fieldInFocus = .lastName
                        }
                }
                
                // last name field
                HStack {
                    Text("Last")
                        .frame(width:100, alignment: .leading)
                    TextField("optional", text: $approvalFormViewModel.formData.lastName)
                        .focused($fieldInFocus, equals: .lastName)
                        .onChange(of: approvalFormViewModel.formData.lastName) { _ in
                            approvalFormViewModel.removeLast(variable: $approvalFormViewModel.formData.lastName, characterType: .alphabetical)
                            approvalFormViewModel.nameValidation()
                        }
                        .submitLabel(.next)
                        .onSubmit {
                            fieldInFocus = .SurName
                        }
                }
                
                // sur name field
                HStack {
                    Text("Surname")
                        .frame(width:100, alignment: .leading)
                    TextField("required", text: $approvalFormViewModel.formData.surName)
                        .focused($fieldInFocus, equals: .SurName)
                        .onChange(of: approvalFormViewModel.formData.surName) { _ in
                            approvalFormViewModel.removeLast(variable: $approvalFormViewModel.formData.surName, characterType: .alphabetical)
                            approvalFormViewModel.nameValidation()
                        }
                        .submitLabel(.done)
                }
            }
            .keyboardType(.alphabet)
            .toolbar(content: {
                ToolbarItem(placement: .principal) { Text("Name").fontWeight(.semibold) }
                ToolbarItem(placement: .keyboard) { HideKeyboardPlacementView() }
            })
        } label: {
            Text(approvalFormViewModel.formData.fullName)
                .foregroundColor(approvalFormViewModel.isChangedAccentColorNameField ? .primary : color.accentColor)
        }
        .alert(item: $approvalFormViewModel.alertItemForNameListSection) { alert -> Alert in
            Alert(
                title: Text(alert.title),
                message: Text(alert.message)
            )
        }
    }
}

// MARK: PREVIEW
struct NameListSection_Previews: PreviewProvider {
    
    @FocusState static var fieldInFocus: ApprovalFormViewModel.FieldType?
    
    static var previews: some View {
        Group {
            NavigationView {
                Form {
                    Section{
                        NameListSection(fieldInFocus: $fieldInFocus)
                            .preferredColorScheme(.dark)
                    }
                }
            }
            NavigationView {
                Form {
                    Section{
                        NameListSection(fieldInFocus: $fieldInFocus)
                    }
                }
            }
        }
        .environmentObject(ApprovalFormViewModel())
        .environmentObject(ColorTheme())
    }
}
