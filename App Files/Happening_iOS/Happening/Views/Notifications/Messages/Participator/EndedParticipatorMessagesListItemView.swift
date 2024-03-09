//
//  EndedParticipatorMessagesListItemView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-04-11.
//

import SwiftUI

struct EndedParticipatorMessagesListItemView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var notificationsVM: NotificationsViewModel
    @EnvironmentObject var participatorMessagesVM: ParticipatorMessagesViewModel
    
    // MARK: BODY
    var body: some View {
        Section {
            ForEach(participatorMessagesVM.filteredParticipatorChatDataArray) {
                if $0.happeningDataWithProfileData.dueFlag.contains("ended")
                    &&
                    $0.happeningDataWithProfileData.spaceFlag.contains("closed") {
                    ParticipatorMessageItemView(item: $0)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button {
                                //delete action goes here...
                                
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
                
                Text("No ended messages available at the moment.")
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
            Text("Ended")
                .textCase(.uppercase)
                .font(.footnote.weight(.medium))
                .padding()
        }
    }
}

// MARK: PREVIEWS
struct EndedParticipatorMessagesListItemView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EndedParticipatorMessagesListItemView()
                .preferredColorScheme(.dark)
            
            EndedParticipatorMessagesListItemView()
        }
        .environmentObject(NotificationsViewModel())
        .environmentObject(ParticipatorMessagesViewModel())
    }
}
