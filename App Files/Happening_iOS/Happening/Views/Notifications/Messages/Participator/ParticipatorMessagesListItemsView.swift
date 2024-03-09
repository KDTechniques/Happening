//
//  ParticipatorMessagesListItemsView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-04-11.
//

import SwiftUI

struct ParticipatorMessagesListItemsView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var participatorMessagesVM: ParticipatorMessagesViewModel
    @EnvironmentObject var networkManger: NetworkManger
    
    // MARK: BODY
    var body: some View {
        
        VStack(spacing: 0) {
            SearchBarView(searchText: $participatorMessagesVM.searchTextParticipatorMessages, isSearching: $participatorMessagesVM.isSearchingParticipatorMessages)
            
            List {
                if networkManger.connectionStatus == .connected {
                    Group {
                        // current happening messages
                        CurrentHappeningMessagesListItemView()
                        
                        // ended happening messages
                        EndedParticipatorMessagesListItemView()
                    }
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                } else {
                    Text("Please check your phone's connection and try again.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 50)
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
        }
        .alert(item: $participatorMessagesVM.alertItemForParticipatorMessageItemView) { alert -> Alert in
            Alert(title: Text(alert.title), message: Text(alert.message), dismissButton: alert.dismissButton)
        }
    }
}

// MARK: PREVIEWS
struct ParticipatorMessagesListItemsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ParticipatorMessagesListItemsView()
                .preferredColorScheme(.dark)
            
            ParticipatorMessagesListItemsView()
        }
        .environmentObject(ParticipatorMessagesViewModel())
        .environmentObject(NetworkManger())
        .environmentObject(NotificationsViewModel())
    }
}
