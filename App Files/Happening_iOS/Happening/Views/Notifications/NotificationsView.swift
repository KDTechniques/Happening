//
//  NotificationsView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-04-01.
//

import SwiftUI

struct NotificationsView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var color: ColorTheme
    @EnvironmentObject var notificationsVM: NotificationsViewModel
    
    // MARK: BODY
    var body: some View {
        NavigationView {
            VStack {
                NotificationTypesPickerView()
                
                switch notificationsVM.notificationTypeSelection {
                    
                case .reservedHappenings:
                    ReservedHListItemsView()
                    
                case .messagses:
                    VStack(spacing: 0) {
                        MessagesAsAPickerView()
                        
                        if notificationsVM.participatorOrCreatorSelection  == .participator {
                            ParticipatorMessagesListItemsView()
                        }  else { // creator
                            CreatorMessagesListItemsView()
                        }
                    }
                    .padding(.top)
                    
                case .participatedHappening:
                    ParticipatedHappeningsListItemsView()
                }
            }
            .navigationTitle("Notifications 🇱🇰")
        }
    }
}

// MARK: PREVIEWS
struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NotificationsView()
                .preferredColorScheme(.dark)
            
            NotificationsView()
        }
        .environmentObject(NotificationsViewModel())
        .environmentObject(ColorTheme())
        .environmentObject(NetworkManger())
        .environmentObject(ContentViewModel())
        .environmentObject(NotificationManager())
        .environmentObject(MessageSheetViewModel())
        .environmentObject(ReservedHViewModel())
        .environmentObject(ParticipatorMessagesViewModel())
        .environmentObject(CreatorMessagesViewModel())
        .environmentObject(ParticipatedHViewModel())
    }
}
