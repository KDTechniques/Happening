//
//  EditUserNameView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-12-29.
//

import SwiftUI

struct EditUserNameView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var editUserNameViewModel: EditUserNameViewModel
    @EnvironmentObject var networkManager: NetworkManger
    
    // MARK: BODY
    var body: some View {
        List {
            // MARK: actual user name
            Section {
                Text("\(editUserNameViewModel.selectionName1) \(editUserNameViewModel.selectionName2)")
            } header: {
                Text("Actual User Name")
                    .font(.footnote)
            } footer: {
                Text("This user name is temporary until you save changes.")
                    .font(.footnote)
            }
            
            Section {
                // MARK: name 1
                HStack {
                    Text("Name 1")
                        .frame(width:100, alignment: .leading)
                    
                    Picker(selection: $editUserNameViewModel.selectionName1) {
                        ForEach(editUserNameViewModel.arrayOfNames, id: \.self) { name in
                            if(!name.isEmpty) {
                                Text(name)
                                    .tag(name)
                            }
                        }
                    } label: {
                        Text("Name 1")
                    }
                    .onChange(of: editUserNameViewModel.selectionName1) { newValue in
                        
                        if(newValue == editUserNameViewModel.selectionName2) {
                            
                            editUserNameViewModel.alertItemForEditUserNameView = AlertItemModel(title: "Name1 & Name2 Should not be Equal", message: "")
                            
                            for index in editUserNameViewModel.arrayOfNames.indices {
                                
                                if(editUserNameViewModel.arrayOfNames[index] != editUserNameViewModel.selectionName2) {
                                    editUserNameViewModel.selectionName1 = editUserNameViewModel.arrayOfNames[index]
                                }
                            }
                        }
                    }
                }
                
                // MARK: name 2
                HStack {
                    Text("Name 2")
                        .frame(width:100, alignment: .leading)
                    
                    Picker(selection: $editUserNameViewModel.selectionName2) {
                        ForEach(editUserNameViewModel.arrayOfNames, id: \.self) { name in
                            if(!name.isEmpty) {
                                Text(name)
                                    .tag(name)
                            }
                        }
                    } label: {
                        Text("Name 2")
                    }
                    .onChange(of: editUserNameViewModel.selectionName2) { newValue in
                        
                        if(newValue == editUserNameViewModel.selectionName1) {
                            
                            editUserNameViewModel.alertItemForEditUserNameView = AlertItemModel(title: "Name1 & Name2 Should not be Equal", message: "")
                            
                            for index in editUserNameViewModel.arrayOfNames.indices {
                                
                                if(editUserNameViewModel.arrayOfNames[index] != editUserNameViewModel.selectionName1) {
                                    editUserNameViewModel.selectionName2 = editUserNameViewModel.arrayOfNames[index]
                                }
                            }
                        }
                    }
                }
            } header: {
                Text("Edit User Name")
                    .font(.footnote)
            } footer: {
                Text("The user name only consists of two names from your actual full name.")
                    .font(.footnote)
            }
            
            // MARK: save changes
            Section {
                HStack {
                    Spacer()
                    
                    Button("Save Changes") {
                        editUserNameViewModel.isPresentedUpdatingProgress = true
                        if(networkManager.connectionStatus == .connected) {
                            editUserNameViewModel.saveUserNameToFirestore()
                        } else {
                            editUserNameViewModel.alertItemForEditUserNameView = AlertItemModel(
                                title: "Couldn't Update User Name",
                                message: "Check your phone's connection and try again."
                            )
                        }
                    }
                    
                    Spacer()
                }
            }
        }
        .pickerStyle(.segmented)
        .listStyle(.grouped)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            editUserNameViewModel.getUserNameAndFullNameDataFromFirestore { status, names, userName in
                if(status){
                    editUserNameViewModel.selectionName1 = getFirstName(fullName: userName)
                    editUserNameViewModel.selectionName2 = getLastName(fullName: userName)
                    
                    editUserNameViewModel.arrayOfNames.removeAll()
                    editUserNameViewModel.arrayOfNames.append(contentsOf: names)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                if(editUserNameViewModel.isPresentedUpdatingProgress) {
                    CustomProgressView1(text: Binding.constant("Updating..."))
                } else {
                    
                    Text("User Name")
                        .fontWeight(.semibold)
                }
            }
        }
        .alert(item: $editUserNameViewModel.alertItemForEditUserNameView) { alert -> Alert in
            Alert(
                title: Text(alert.title),
                message: Text(alert.message)
            )
        }
    }
}

// MARK: PREVIEWS
struct EditUserNameView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                EditUserNameView()
                    .preferredColorScheme(.dark)
            }
            
            NavigationView {
                EditUserNameView()
            }
        }
        .environmentObject(EditUserNameViewModel())
        .environmentObject(NetworkManger())
    }
}
