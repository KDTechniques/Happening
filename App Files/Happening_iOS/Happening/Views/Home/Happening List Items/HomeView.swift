//
//  HomeView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-11-11.
//

import SwiftUI

struct HomeView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var color: ColorTheme
    @EnvironmentObject var happeningsVM: HappeningsViewModel
    @EnvironmentObject var networkManager: NetworkManger
    
    // MARK: BODY
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                SearchBarView(searchText: $happeningsVM.searchText, isSearching: $happeningsVM.isSearching)
                
                if networkManager.connectionStatus == .connected {
                    List(happeningsVM.filteredHappeningsDataArray) { item in
                        HappeningItemView(item: item)
                            .background(NavigationLink("", destination: { HappeningInformationView(item: item) }).opacity(0))
                            .listRowInsets(EdgeInsets())
                            .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                    .overlay(alignment: .top) {
                        ZStack {
                            ProgressView()
                                .tint(.secondary)
                                .opacity(happeningsVM.isPresentedProgressView ? 1 : 0)
                            
                            Text(happeningsVM.happeningsDataArray.isEmpty ? "No results found." : "")
                                .opacity(happeningsVM.isPresentedErrorText && !happeningsVM.isPresentedProgressView ? 1 : 0)
                        }
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 50)
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                    }
                } else {
                    VStack {
                        Text("Please check your phone's connection and try again.")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity)
                            .padding(.top, 50)
                        
                        Spacer()
                    }
                }
            }
            .navigationTitle("Home 🇱🇰")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: CreateAHappeningView(), label: {
                        Image(systemName: "square.and.pencil")
                            .font(Font.callout.weight(.medium))
                    })
                }
                
                ToolbarItem(placement: .principal) {
                    Picker("", selection: $happeningsVM.followingsOnlyStatus) {
                        Text("Followings On")
                            .tag(HappeningsViewModel.followingsOnlyStatusTypes.on)
                        
                        Text("Followings Off")
                            .tag(HappeningsViewModel.followingsOnlyStatusTypes.off)
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 210)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Filter") {
                        happeningsVM.isPresentedFilterOptionsSheet = true
                    }
                }
            }
            .sheet(isPresented: $happeningsVM.isPresentedFilterOptionsSheet, content: {
                HappeningFilterOptionsView()
            })
            .onAppear {
                CreateAHappeningViewModel.shared.resetHappeningData()
            }
            .alert(item: $happeningsVM.alertItemForHomeView) { alert -> Alert in
                Alert(title: Text(alert.title), message: Text(alert.message), dismissButton: alert.dismissButton)
            }
        }
        .refreshable {
            happeningsVM.isPresentedErrorText = false
            
            happeningsVM.getCustomHappenings {
                if !$0 {
                    happeningsVM.isPresentedErrorText  = true
                } else {
                    if !happeningsVM.happeningsDataArray.isEmpty {
                        happeningsVM.isPresentedErrorText = false
                    } else {
                        happeningsVM.isPresentedErrorText = true
                    }
                }
            }
        }
    }
}


// MARK: PREVIEW
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeView().preferredColorScheme(.dark)
            HomeView()
        }
        .environmentObject(ColorTheme())
        .environmentObject(MyHappeningLocationMapViewModel())
        .environmentObject(LocationSearchService())
        .environmentObject(HappeningsViewModel())
        .environmentObject(NetworkManger())
    }
}
