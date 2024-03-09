//
//  NotificationTypesPickerView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-04-11.
//

import SwiftUI

struct NotificationTypesPickerView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var notificationsVM: NotificationsViewModel
    
    // MARK: BODY
    var body: some View {
        Picker("", selection: $notificationsVM.notificationTypeSelection) {
            ForEach(NotificationsViewModel.NotificationTypes.allCases, id: \.self) {
                Text($0.rawValue)
                    .tag($0)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
    }
}


// MARK: PREVIEWS
struct NotificationTypesPickerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NotificationTypesPickerView()
                .preferredColorScheme(.dark)
            
            NotificationTypesPickerView()
        }
        .environmentObject(NotificationsViewModel())
    }
}
