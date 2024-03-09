//
//  ReservedHListItemsView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-04-11.
//

import SwiftUI

struct ReservedHListItemsView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var reservedHVM: ReservedHViewModel
    
    // MARK: BODY
    var body: some View {
        VStack(spacing: 0) {
            ReservedHHappeningSoonListItemView()
            
            SearchBarView(searchText: $reservedHVM.searchTextReservedH, isSearching: $reservedHVM.isSearchingReservedH)
            
            ReservedHListItemView()
        }
        .padding(.top)
    }
}

// MARK: PREVIEWS
struct ReservedHListItemsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ReservedHListItemsView()
                .preferredColorScheme(.dark)
            
            ReservedHListItemsView()
        }
        .environmentObject(NotificationsViewModel())
        .environmentObject(NetworkManger())
        .environmentObject(ReservedHViewModel())
        .environmentObject(ColorTheme())
    }
}
