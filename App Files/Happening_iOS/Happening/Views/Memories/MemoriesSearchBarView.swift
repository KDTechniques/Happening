//
//  MemoriesSearchBarView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-01-06.
//

import SwiftUI

struct MemoriesSearchBarView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var statusViewModel: MemoriesViewModel
    
    // MARK: BODY
    var body: some View {
        SearchBarView(searchText: $statusViewModel.searchText, isSearching: $statusViewModel.isSearching)
            .listRowInsets(EdgeInsets())
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
    }
}

// MARK: PREVIEWS
struct MemoriesSearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SearchBarView(searchText: Binding.constant(""), isSearching: Binding.constant(false))
                .preferredColorScheme(.dark)
            
            SearchBarView(searchText: Binding.constant("Deepashika"), isSearching: Binding.constant(true))
        }
        .environmentObject(MemoriesViewModel())
    }
}
