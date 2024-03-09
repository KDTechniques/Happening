//
//  EditAboutView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-12-30.
//

import SwiftUI

struct EditAboutView: View {
    
    //MARK: PROPERTIES
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var color: ColorTheme
    @EnvironmentObject var editAboutViewModel: EditAboutViewModel
    @EnvironmentObject var networkManager: NetworkManger
    
    @State private var item: String = ""
    
    // reference to UserDefaults
    let defaults = UserDefaults.standard
    
    // MARK: BODY
    var body: some View {
        List {
            // currently set to section
            Section {
                Button {
                    editAboutViewModel.isPresentedAboutSheet = true
                } label: {
                    HStack{
                        Text(defaults.string(forKey: ProfileBasicInfoViewModel.ProfileBasicInfoUserDefaultsType.about.rawValue) ?? "...")
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(colorScheme == .light ? Color(UIColor.systemGray3) : Color(UIColor.systemGray2))
                            .font(.body.weight(.bold))
                            .scaleEffect(0.8)
                    }
                }
                
            } header: {
                Text("Currently Set To")
                    .font(.footnote)
            }
            
            // select your about section
            Section {
                ForEach(editAboutViewModel.aboutItemListArray, id: \.self) { aboutItem in
                    if(defaults.string(forKey: ProfileBasicInfoViewModel.ProfileBasicInfoUserDefaultsType.about.rawValue) ?? "" == aboutItem) {
                        HStack {
                            Text(aboutItem)
                            
                            Spacer()
                            
                            if(!editAboutViewModel.showProgressViewInEditAboutView) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(color.accentColor)
                            }
                        }
                    } else {
                        HStack {
                            Text(aboutItem)
                            
                            Spacer()
                            
                            if(editAboutViewModel.showProgressViewInEditAboutView) {
                                ProgressView()
                                    .tint(.secondary)
                                    .tag(aboutItem)
                                    .opacity((item == aboutItem ? 1 : 0))
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        .background(colorScheme == .light ? .white : Color(UIColor.secondarySystemBackground))
                        .onTapGesture {
                            if(networkManager.connectionStatus == .connected) {
                                item = aboutItem
                                editAboutViewModel.showProgressViewInEditAboutView = true
                                editAboutViewModel.updateAboutToFirestore(about: aboutItem)
                            } else {
                                editAboutViewModel.alertItemForEditAboutView = AlertItemModel(
                                    title: "Couldn't Update About",
                                    message: "Check your phone's connection and try again."
                                )
                            }
                        }
                    }
                }
                .onDelete(perform: editAboutViewModel.deleteAboutListItem)
                .onMove(perform: editAboutViewModel.moveAboutListItem)
            } header: {
                Text("Select Your About")
                    .font(.footnote)
            }
        }
        .listStyle(.grouped)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(Text("About"))
        .toolbar {
            if let _ = editAboutViewModel.aboutItemListArray {
                EditButton()
            }
        }
        .sheet(isPresented: $editAboutViewModel.isPresentedAboutSheet) {
            // code to be excecuted when dismiss
        } content: {
            VStack(spacing: 0) {
                Rectangle()
                    .fill(colorScheme == .light ? .white : Color(UIColor.systemGray5))
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .overlay(
                        HStack {
                            Button("Cancel") {
                                editAboutViewModel.isPresentedAboutSheet = false
                            }
                            .padding(.leading, 20)
                            
                            Spacer()
                            
                            Text("About(\(40 - editAboutViewModel.aboutTextFieldText.count))")
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Button(action: {
                                editAboutViewModel.updateAboutToFirestore(about: editAboutViewModel.aboutTextFieldText)
                                editAboutViewModel.isPresentedAboutSheet = false
                            }, label: {
                                Text("Save")
                                    .fontWeight(.semibold)
                            })
                                .padding(.trailing, 20)
                                .disabled(editAboutViewModel.isDisabledAboutSaveButton)
                        }
                    )
                
                Divider()
                Rectangle()
                    .fill(colorScheme == .light ? Color(UIColor.systemGray6) : Color(UIColor.systemGray6))
                    .frame(maxWidth: .infinity)
                    .frame(height: 17)
                Divider()
                
                TextField("", text: $editAboutViewModel.aboutTextFieldText)
                    .padding()
                    .onChange(of: editAboutViewModel.aboutTextFieldText) { _ in
                        if(editAboutViewModel.aboutTextFieldText.count > 40) {
                            editAboutViewModel.aboutTextFieldText.removeLast()
                        }
                        if(editAboutViewModel.aboutTextFieldText.isEmpty) {
                            editAboutViewModel.isDisabledAboutSaveButton = true
                        } else {
                            editAboutViewModel.isDisabledAboutSaveButton = false
                        }
                    }
                
                Spacer()
            }
            .edgesIgnoringSafeArea(.top)
            .onAppear {
                editAboutViewModel.aboutTextFieldText = defaults.string(forKey: ProfileBasicInfoViewModel.ProfileBasicInfoUserDefaultsType.about.rawValue) ?? "..."
            }
        }
        .onAppear {
            // store all the about list items from user defaults
            editAboutViewModel.aboutItemListArray = defaults.stringArray(forKey: editAboutViewModel.aboutListArrayItemsUserDefaultsKeyName) ?? []
        }
        .alert(item: $editAboutViewModel.alertItemForEditAboutView) { alert -> Alert in
            Alert(title: Text(alert.title), message: Text(alert.message))
        }
        
    }
}

// MARK: PREVIEWS
struct EditAboutView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                EditAboutView()
                    .preferredColorScheme(.dark)
            }
            
            NavigationView {
                EditAboutView()
            }
        }
        .environmentObject(ColorTheme())
        .environmentObject(EditAboutViewModel())
        .environmentObject(NetworkManger())
    }
}
