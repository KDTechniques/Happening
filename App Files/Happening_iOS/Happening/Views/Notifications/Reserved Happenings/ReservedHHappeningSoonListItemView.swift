//
//  ReservedHHappeningSoonListItemView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-04-11.
//

import SwiftUI

struct ReservedHHappeningSoonListItemView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var reservedHVM: ReservedHViewModel
    @EnvironmentObject var networkManger: NetworkManger
    @EnvironmentObject var color: ColorTheme
    
    // MARK: BODY
    var body: some View {
        if networkManger.connectionStatus == .connected {
            if !reservedHVM.showNoHappeningsForReservedH {
                Section {
                    if !reservedHVM.reservedHappeningsItemArray.isEmpty {
                        HappeningItemViewSpecial(item: reservedHVM.reservedHappeningsItemArray[0])
                            .frame(maxWidth: .infinity)
                            .background(color.accentColor.opacity(reservedHVM.happeningSoonListItemViewOpacity))
                            .cornerRadius(15)
                            .sheet(isPresented: $reservedHVM.isPresentedHappeningSoonItemSheet) {
                                ReservedHappeningSoonInfoView(item: reservedHVM.reservedHappeningsItemArray[0])
                            }
                            .onAppear { reservedHVM.onAppearActions() }
                            .onTapGesture { reservedHVM.onTapGestureActions() }
                            .padding()
                    } else {
                        ProgressView()
                            .tint(.secondary)
                            .padding()
                            .opacity(reservedHVM.showProgressViewForReservedH ? 1 : 0)
                    }
                } header: {
                    if !reservedHVM.reservedHappeningsItemArray.isEmpty {
                        Text("Happening Soon")
                            .textCase(.uppercase)
                            .font(.footnote)
                            .foregroundColor(.green)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 20)
                    }
                }
            }
        }
    }
}

// MARK: PREVIEWS
struct ReservedHHappeningSoonListItemView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ReservedHHappeningSoonListItemView()
                .preferredColorScheme(.dark)
            
            ReservedHHappeningSoonListItemView()
        }
        .environmentObject(ReservedHViewModel())
        .environmentObject(NetworkManger())
        .environmentObject(ColorTheme())
    }
}
