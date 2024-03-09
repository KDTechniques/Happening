//
//  MessagesAsAPickerView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-04-11.
//

import SwiftUI

struct MessagesAsAPickerView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var notificationsVM: NotificationsViewModel
    
    // MARK: BODY
    var body: some View {
        HStack {
            HStack {
                Text("Messages\nas a")
                    .font(.caption2.weight(.medium))
                    .multilineTextAlignment(.leading)
                
                Picker("Messages as a", selection: $notificationsVM.participatorOrCreatorSelection) {
                    Text("Participator")
                        .tag(NotificationsViewModel.MessagesAsATypes.participator)
                    
                    Text("Creator")
                        .tag(NotificationsViewModel.MessagesAsATypes.creator)
                }
                .pickerStyle(.segmented)
                .frame(width: 210)
            }
            
            Spacer()
        }
        .padding(.bottom)
        .padding(.horizontal)
    }
}

// MARK: PREVIEWS
struct MessagesAsAPickerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MessagesAsAPickerView()
                .preferredColorScheme(.dark)
            
            MessagesAsAPickerView()
        }
        .environmentObject(NotificationsViewModel())
    }
}
