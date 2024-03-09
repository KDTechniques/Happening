//
//  ParticipatedHappeningsListItemsView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-04-11.
//

import SwiftUI

struct ParticipatedHappeningsListItemsView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var participatedHVM: ParticipatedHViewModel
    
    // MARK: BODY
    var body: some View {
        VStack(spacing: 0) {
            SearchBarView(searchText: $participatedHVM.searchTextParticipatedH, isSearching: $participatedHVM.isSearchingParticipatedH)
            
            List {
                
            }
            .listStyle(.plain)
        }
        .padding(.top)
    }
}

// MARK: PREVIEWS
struct ParticipatedHappeningsListItemsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ParticipatedHappeningsListItemsView()
                .preferredColorScheme(.dark)
            
            ParticipatedHappeningsListItemsView()
        }
        .environmentObject(ParticipatedHViewModel())
        .environmentObject(NotificationsViewModel())
    }
}
