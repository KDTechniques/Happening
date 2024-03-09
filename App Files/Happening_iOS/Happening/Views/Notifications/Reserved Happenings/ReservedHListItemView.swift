//
//  ReservedHListItemView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-04-11.
//

import SwiftUI

struct ReservedHListItemView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var reservedHVM: ReservedHViewModel
    @EnvironmentObject var networkManger: NetworkManger
    
    // MARK: BODY
    var body: some View {
        List {
            if networkManger.connectionStatus == .connected {
                if !reservedHVM.reservedHappeningsItemArray.isEmpty {
                    ForEach(reservedHVM.filteredReservedHappeningsItemArray) { item in
                        if reservedHVM.reservedHappeningsItemArray.firstIndex(of: item) != 0 {
                            HappeningItemView(item: item)
                                .background(NavigationLink("", destination: { ReservedHappeningInfoView(item: item) }).opacity(0))
                                .listRowInsets(EdgeInsets())
                                .listRowSeparator(.hidden)
                        }
                    }
                }
                
                ZStack {
                    ProgressView()
                        .tint(.secondary)
                        .opacity(reservedHVM.showProgressViewForReservedH ? 1 : 0)
                    
                    Text("No reserved happenings available at the moment.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .opacity(reservedHVM.showNoHappeningsForReservedH ? 1 : 0)
                    
                    Text("No results found.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .opacity(reservedHVM.showNoResultsFoundForReservedH ? 1 : 0)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 50)
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
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
}

// MARK: PREVIEWS
struct ReservedHListItemView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ReservedHListItemView()
                .preferredColorScheme(.dark)
            
            ReservedHListItemView()
        }
        .environmentObject(ReservedHViewModel())
        .environmentObject(NetworkManger())
    }
}
