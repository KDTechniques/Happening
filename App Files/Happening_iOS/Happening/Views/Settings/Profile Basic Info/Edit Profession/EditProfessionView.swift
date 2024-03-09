//
//  EditProfessionView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-12-30.
//

import SwiftUI

struct EditProfessionView: View {
    
    // MARK: PROPERTIES
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var color: ColorTheme
    @EnvironmentObject var profileBasicInfoViewModel: ProfileBasicInfoViewModel
    @EnvironmentObject var updateProfessionViewModel: UpdateProfessionViewModel
    @EnvironmentObject var networkManager: NetworkManger
    
    // reference to UserDeaults
    let defaults = UserDefaults.standard
    
    // MARK: BODY
    var body: some View {
        List {
            // currently set to section
            Section {
                Text(defaults.string(forKey: ProfileBasicInfoViewModel.ProfileBasicInfoUserDefaultsType.profession.rawValue) ?? "...")
            } header: {
                Text("Currently Set To")
                    .font(.footnote)
            }
            
            // edit your profession section
            Section {
                ForEach(ProfessionType.allCases, id: \.self) { value in
                    if(defaults.string(forKey: ProfileBasicInfoViewModel.ProfileBasicInfoUserDefaultsType.profession.rawValue) == value.rawValue) {
                        HStack {
                            Text(value.rawValue)
                            
                            Spacer()
                            
                            if(updateProfessionViewModel.showProgressViewInEditProfessionView) {
                                ProgressView()
                                    .tint(.secondary)
                            } else {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(color.accentColor)
                            }
                        }
                    } else {
                        Text(value.rawValue)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                            .background(colorScheme == .light ? .white : Color(UIColor.secondarySystemBackground))
                            .onTapGesture {
                                if(networkManager.connectionStatus == .connected) {
                                    updateProfessionViewModel.showProgressViewInEditProfessionView = true
                                    updateProfessionViewModel.updateProfessionInFirebase(profession: value.rawValue)
                                } else {
                                    updateProfessionViewModel.alertItemForUpdateProfessionView = AlertItemModel(title: "Couldn't Update Profession", message: "Check your phone's connection and try again.")
                                }
                            }
                    }
                }
            } header: {
                Text("Select Your Profession")
                    .font(.footnote)
            } footer: {
                Text("Select the profession as 'None' If you do not want other people to see your profession.")
                    .font(.footnote)
            }
        }
        .listStyle(.grouped)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(Text("Profession"))
        .alert(item: $updateProfessionViewModel.alertItemForUpdateProfessionView) { alert -> Alert in
            Alert(
                title: Text(alert.title),
                message: Text(alert.message)
            )
        }
    }
}

// MARK: PREVIEWS
struct EditProfessionView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                EditProfessionView()
                    .preferredColorScheme(.dark)
            }
            
            NavigationView {
                EditProfessionView()
            }
        }
        .environmentObject(SettingsViewModel())
        .environmentObject(ColorTheme())
        .environmentObject(ProfileBasicInfoViewModel())
        .environmentObject(UpdateProfessionViewModel())
    }
}
