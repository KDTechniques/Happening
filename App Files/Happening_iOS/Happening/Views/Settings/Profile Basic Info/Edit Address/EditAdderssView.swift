//
//  EditAdderssView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-12-31.
//

import SwiftUI

struct EditAdderssView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var color:ColorTheme
    @EnvironmentObject var editAddressViewModel: EditAddressViewModel
    @EnvironmentObject var networkManager: NetworkManger
    
    // enum model for focusable address text fields
    enum AddressFieldTypes: Hashable {
        case street1
        case street2
        case city
        case postCode
    }
    
    // conrols the current focus field of address
    @FocusState private var fieldInFocus: AddressFieldTypes?
    
    // MARK: BODY
    var body: some View {
        List {
            Section {
                // street 1
                HStack {
                    Text("Street")
                        .frame(width:100, alignment: .leading)
                    TextField("required", text: $editAddressViewModel.addressData.street1)
                        .focused($fieldInFocus, equals: .street1)
                        .keyboardType(.alphabet)
                        .onChange(of: editAddressViewModel.addressData.street1) { _ in
                            editAddressViewModel.removeLastAndCapitalizedAddress(variable: $editAddressViewModel.addressData.street1)
                        }
                        .submitLabel(.next)
                        .onSubmit {
                            fieldInFocus = .street2
                        }
                }
                //
                // street 2
                HStack {
                    Text("Street")
                        .frame(width:100, alignment: .leading)
                    TextField("Optional", text: $editAddressViewModel.addressData.street2)
                        .focused($fieldInFocus, equals: .street2)
                        .keyboardType(.alphabet)
                        .onChange(of: editAddressViewModel.addressData.street2) { newValue in
                            editAddressViewModel.removeLastAndCapitalizedAddress(variable: $editAddressViewModel.addressData.street2)
                        }
                        .submitLabel(.next)
                        .onSubmit {
                            fieldInFocus = .city
                        }
                }
                
                // city
                HStack {
                    Text("City")
                        .frame(width:100, alignment: .leading)
                    TextField("required", text: $editAddressViewModel.addressData.city)
                        .focused($fieldInFocus, equals: .city)
                        .keyboardType(.alphabet)
                        .onChange(of: editAddressViewModel.addressData.city) { newValue in
                            editAddressViewModel.removeLastAndCapitalizedAddress(variable: $editAddressViewModel.addressData.city)
                        }
                        .submitLabel(.next)
                        .onSubmit {
                            fieldInFocus = .postCode
                        }
                }
                
                // postcode
                HStack {
                    Text("Post Code")
                        .frame(width:100, alignment: .leading)
                    TextField("required", text: $editAddressViewModel.addressData.postCode)
                        .focused($fieldInFocus, equals: .postCode)
                        .keyboardType(.asciiCapableNumberPad)
                }
            } header: {
                Text("Edit Your Address")
                    .font(.footnote)
            }
            
            // clear all button
            Section {
                HStack {
                    Spacer()
                    
                    Button("Clear All") {
                        editAddressViewModel.clearAllAddressFields()
                        fieldInFocus = .street1
                    }
                    
                    Spacer()
                }
            }
            
            // save changes button
            Section {
                HStack {
                    Spacer()
                    
                    Button("Save Changes") {
                        editAddressViewModel.isPresentedUpdatingProgress = true
                        fieldInFocus = .none
                        if(networkManager.connectionStatus == .connected) {
                            editAddressViewModel.updateAddressInFirestore()
                        } else {
                            editAddressViewModel.alertItemForEditAddressView = AlertItemModel(title: "Couldn't Update Address", message: "Check your phone's connection and try again.")
                        }
                    }
                    
                    Spacer()
                }
            }
        }
        .listStyle(.grouped)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            editAddressViewModel.getAddressFromUserDefaults()
            
            editAddressViewModel.getAddressDataFromFirestore()
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                if(editAddressViewModel.isPresentedUpdatingProgress) {
                    CustomProgressView1(text: Binding.constant("Updating..."))
                } else {
                    
                    Text("Address")
                        .fontWeight(.semibold)
                }
            }
        }
        .alert(item: $editAddressViewModel.alertItemForEditAddressView, content: { alert -> Alert in
            Alert(
                title: Text(alert.title),
                message: Text(alert.message)
            )
        })
        .toolbar {
            ToolbarItem(placement: .keyboard, content: { HideKeyboardPlacementView() })
        }
    }
}

// MARK: PREVIEWS
struct EditAdderssView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                EditAdderssView()
                    .preferredColorScheme(.dark)
            }
            
            NavigationView {
                EditAdderssView()
            }
        }
        .environmentObject(SettingsViewModel())
        .environmentObject(ColorTheme())
        .environmentObject(EditAddressViewModel())
    }
}
