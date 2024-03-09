//
//  CurrentHappeningMessagesListItemView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-04-11.
//

import SwiftUI

struct CurrentHappeningMessagesListItemView: View {
    
    // MARK: PROPERTIES
    @Environment(\.dismiss) var presentationMode
    @EnvironmentObject var participatorMessagesVM: ParticipatorMessagesViewModel
    
    @State private var myUserUID: String?
    @State private var filteredParticipatorChatDataArray = [MessageAsAParticipatorModel]()
    @State private var count: Int = 0
    @State private var isFilteredParticipatorChatDataArrayListAppeared: Bool = true
    
    // MARK: BODY
    var body: some View {
        Section {
            ForEach(filteredParticipatorChatDataArray) { item in
                if item.happeningDataWithProfileData.dueFlag.contains("live") {
                    ParticipatorMessageItemView(item: item)
                        .background(NavigationLink("", destination: {
                            if let myUserUID = myUserUID {
                                if item.happeningDataWithProfileData.participators.contains(myUserUID) {
                                    // if participators array contains my user uid, that means i reserved the happening
                                    ReservedHappeningInfoView(item: item.happeningDataWithProfileData)
                                } else {
                                    // if participators array doesn't contains my user uid, that means i have not reserved the happening
                                    HappeningInformationView(item: item.happeningDataWithProfileData)
                                }
                            }
                            
                        }).opacity(0))
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button {
                                participatorMessagesVM.deleteAChatThread(happeningDocID: item.happeningDataWithProfileData.id)
                            } label: {
                                VStack {
                                    Image(systemName: "trash.slash.fill")
                                    Text("Delete")
                                }
                            }
                            .tint(.red)
                        }
                }
            }
            
            ZStack {
                ProgressView()
                    .tint(.secondary)
                    .opacity(participatorMessagesVM.showProgressViewForParticipatorMessages ? 1 : 0)
                
                Text("No current messages available at the moment.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .opacity(participatorMessagesVM.showNoMessagesForParticipatorMessages ? 1 : 0)
                
                Text("No results found.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .opacity(participatorMessagesVM.showNoResultsFoundForParticipatorMessages ? 1 : 0)
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 50)
            .listRowInsets(EdgeInsets())
            .listRowSeparator(.hidden)
        } header: {
            Text("Current")
                .textCase(.uppercase)
                .font(.footnote.weight(.medium))
                .padding()
        }
        .onAppear {
            if let myuserUID = CurrentUser.shared.currentUserUID {
                self.myUserUID = myuserUID
            } else {
                print("my user uid nil.")
                presentationMode.callAsFunction()
            }
            
            filteredParticipatorChatDataArray = participatorMessagesVM.filteredParticipatorChatDataArray
            isFilteredParticipatorChatDataArrayListAppeared = true
        }
        .onDisappear {
            isFilteredParticipatorChatDataArrayListAppeared = false
        }
        .onChange(of: participatorMessagesVM.filteredParticipatorChatDataArray) { _ in
            if count == 0 || isFilteredParticipatorChatDataArrayListAppeared {
                filteredParticipatorChatDataArray = participatorMessagesVM.filteredParticipatorChatDataArray
            }
            count += 1
        }
    }
}

// MARK: PREVIEWS
struct CurrentHappeningMessagesListItemView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CurrentHappeningMessagesListItemView()
                .preferredColorScheme(.dark)
            
            CurrentHappeningMessagesListItemView()
        }
        .environmentObject(ParticipatorMessagesViewModel())
        .environmentObject(CurrentUser())
    }
}
