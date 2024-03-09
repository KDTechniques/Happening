//
//  MyHappeningsView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-11-11.
//

import SwiftUI

struct MyHappeningsView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var myHappeningsVM: MyHappeningsViewModel
    
    // MARK: BODY
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                SearchBarView(searchText: $myHappeningsVM.searchText, isSearching: $myHappeningsVM.isSearching)
                
                List {
                    Group {
                        Section {
                            if myHappeningsVM.myCurrentHappeningItemsArray.isEmpty {
                                Text("You have not created any Happenings yet.")
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                                    .frame(maxWidth: .infinity)
                            } else {
                                if !myHappeningsVM.orderedMyCurrentHappeningItemsArray.isEmpty {
                                    ForEach(myHappeningsVM.orderedMyCurrentHappeningItemsArray) { item in
                                        MyHappeningItemView(item: item)
                                            .background(NavigationLink("", destination: { MyHappeningInformationView(item: item) }).opacity(0))
                                    }
                                } else {
                                    Text("No results found.")
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                        .frame(maxWidth: .infinity)
                                }
                            }
                        } header: {
                            Text("Current")
                                .textCase(.uppercase)
                                .font(.footnote.weight(.medium))
                                .padding()
                        }
                        
                        if !myHappeningsVM.myEndedHappeningItemsArray.isEmpty {
                            Section {
                                if !myHappeningsVM.orderedMyEndedHappeningItemsArray.isEmpty {
                                    ForEach(myHappeningsVM.orderedMyEndedHappeningItemsArray) { item in
                                        MyHappeningItemView(item: item)
                                            .background(NavigationLink("", destination: { Text(item.title) }).opacity(0))
                                    }
                                } else {
                                    Text("No results found.")
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                        .frame(maxWidth: .infinity)
                                }
                            } header: {
                                Text("Ended")
                                    .textCase(.uppercase)
                                    .font(.footnote.weight(.medium))
                                    .padding()
                            }
                        }
                    }
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                }
                .listStyle(.plain)
                .navigationTitle("My Happenings 🇱🇰")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        HStack {
                            Text("Sort by\nhappening")
                                .font(.caption2.weight(.medium))
                            
                            Picker("Sort by date & time", selection: $myHappeningsVM.myCurrentHappeningSortingSelection) {
                                Text("Sooner")
                                    .tag(HappeningSortingTypes.sooner)
                                
                                Text("Later")
                                    .tag(HappeningSortingTypes.later)
                            }
                            .pickerStyle(.segmented)
                            .frame(width: 150)
                        }
                    }
                }
            }
        }
        .onAppear {
            myHappeningsVM.getMyCurrentHappeningsFromFirestore()
            myHappeningsVM.getMyEndedHappeningsFromFirestore()
        }
        .onReceive(myHappeningsVM.fiveMinTimer, perform: { _ in
            myHappeningsVM.endHappenings()
        })
        .alert(item: $myHappeningsVM.alertItemForMyHappeningsView) { alert -> Alert in
            Alert(title: Text(alert.title), message: Text(alert.message), dismissButton: alert.dismissButton)
        }
    }
}

// MARK: PREVIEW
struct MyHappeningsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MyHappeningsView()
                .preferredColorScheme(.dark)
            MyHappeningsView()
        }
        .environmentObject(ColorTheme())
        .environmentObject(MyHappeningsViewModel())
    }
}
