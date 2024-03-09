//
//  UserDataView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-02-16.
//

import SwiftUI
import SDWebImageSwiftUI

struct UserDataView: View {
    
    // MARK: PROPERTIES
    
    @EnvironmentObject var userDataViewModel: UserDataViewModel
    @EnvironmentObject var pendingApprovalViewModel: PendingApprovalViewModel
    
    @Binding var item: String
    
    let imageWidth: CGFloat = UIScreen.main.bounds.size.height/3
    
    var body: some View {
        GeometryReader { geometry in
            List {
                // profile picture
                Section {
                    HStack {
                        Spacer()
                        
                        AsyncImage(url: URL(string: userDataViewModel.dataObject?.profilePhoto ?? "")) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: geometry.size.width/2, height: geometry.size.width/2)
                                
                            
                        } placeholder: {
                            ProgressView()
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 8)
                } header: {
                    Text("Profile Photo")
                }
                
                // nic photo
                Section {
                    HStack {
                        Spacer()
                        
                        AsyncImage(url: URL(string: userDataViewModel.dataObject?.nicPhotoFrontSide ?? "")) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: geometry.size.width/2.5)
                        } placeholder: {
                            ProgressView()
                        }
                        
                        Spacer()
                        
                        AsyncImage(url: URL(string: userDataViewModel.dataObject?.nicPhotoBackSide ?? "")) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: geometry.size.width/2.5)
                        } placeholder: {
                            ProgressView()
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 8)
                } header: {
                    Text("NIC Photo")
                }
                
                // name
                Section {
                    HStack {
                        Text("First")
                            .frame(width: 80, alignment: .leading)
                        Text(userDataViewModel.dataObject?.firstName ?? "...")
                    }
                    
                    HStack {
                        Text("Middle")
                            .frame(width: 80, alignment: .leading)
                        Text(userDataViewModel.dataObject?.middleName ?? "...")
                    }
                    
                    HStack {
                        Text("Last")
                            .frame(width: 80, alignment: .leading)
                        Text(userDataViewModel.dataObject?.lastName ?? "...")
                    }
                    
                    HStack {
                        Text("Sur")
                            .frame(width: 80, alignment: .leading)
                        Text(userDataViewModel.dataObject?.surName ?? "...")
                    }
                } header: {
                    Text("Name")
                }
                
                // nic no
                Section {
                    Text(userDataViewModel.dataObject?.nicNo ?? "...")
                } header: {
                    Text("NIC No")
                }
                
                Section {
                    Text(userDataViewModel.dataObject?.birthDate ?? "...")
                } header: {
                    Text("Date of Birth")
                }
                
                // gender
                Section {
                    Text(userDataViewModel.dataObject?.gender ?? "...")
                } header: {
                    Text("Gender")
                }
                
                // profession
                Section {
                    Text(userDataViewModel.dataObject?.profession ?? "...")
                } header: {
                    Text("Profession")
                }
                
                // address
                Section {
                    HStack {
                        Text("Street")
                            .frame(width: 80, alignment: .leading)
                        Text(userDataViewModel.dataObject?.street1 ?? "...")
                    }
                    
                    HStack {
                        Text("Street")
                            .frame(width: 80, alignment: .leading)
                        Text(userDataViewModel.dataObject?.street2 ?? "...")
                    }
                    
                    HStack {
                        Text("City")
                            .frame(width: 80, alignment: .leading)
                        Text(userDataViewModel.dataObject?.city ?? "...")
                    }
                    
                    HStack {
                        Text("Postcode")
                            .frame(width: 80, alignment: .leading)
                        Text(userDataViewModel.dataObject?.postcode ?? "...")
                    }
                } header: {
                    Text("Address")
                }
                
                // email address
                Section {
                    Text(userDataViewModel.dataObject?.emailAddress ?? "...")
                } header: {
                    Text("Email Address")
                }
                
                // phone no
                Section {
                    Text(userDataViewModel.dataObject?.phoneNo ?? "...")
                } header: {
                    Text("Phone No")
                }
            }
            .overlay(alignment: .center) {
                if(userDataViewModel.isPresentedApproveLoadingView) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.ultraThinMaterial)
                        .frame(width: 140, height: 140)
                        .overlay(
                            VStack {
                                ProgressView()
                                    .padding(.bottom, 5)
                                
                                Text("Approving...")
                                    .font(.subheadline.weight(.semibold))
                            }
                                .tint(.primary)
                        )
                }
            }
        }
        .navigationBarTitle(userDataViewModel.dataObject?.id ?? "...")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    userDataViewModel.isPresentedApproveLoadingView = true
                    
                    userDataViewModel.approveUser(dataObject: userDataViewModel.dataObject, data: userDataViewModel.data) { status in
                        userDataViewModel.isDisabledApproveButton = !status
                        pendingApprovalViewModel.getDocumentIDs { staus in
                            userDataViewModel.isPresentedApproveLoadingView = !status
                        }
                    }
                } label: {
                    Text("Approve")
                        .fontWeight(.semibold)
                }
                .disabled(userDataViewModel.isDisabledApproveButton)
                
            }
        }
        .onAppear {
            pendingApprovalViewModel.getDocumetsData(docID: item) { status in
                if(status) {
                    userDataViewModel.dataObject = pendingApprovalViewModel.documentsDataArray[0]
                }
            }
        }
    }
}

struct UserDataView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                NavigationLink("PiFmuNMTZBNvGAF2kKBIYlwRfDy1") {
                    UserDataView(item: Binding.constant("PiFmuNMTZBNvGAF2kKBIYlwRfDy1"))
                }
            }
        }
        .environmentObject(UserDataViewModel())
        .environmentObject(PendingApprovalViewModel())
        .previewInterfaceOrientation(.landscapeLeft)
    }
}
