//
//  MemoriesView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-11-26.
//

import SwiftUI

struct MemoriesView: View {
    
    // MARK: PROPERTIES
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var color: ColorTheme
    @EnvironmentObject var memoriesVM: MemoriesViewModel
    @EnvironmentObject var imageBasedMemoryVM: ImageBasedMemoryViewModel
    @EnvironmentObject var textBasedMemoryVM: TextBasedMemoryViewModel
    @EnvironmentObject var networkManager: NetworkManger
    
    // MARK: BODY
    var body: some View {
        NavigationView {
            VStack (spacing: 0) {
                MemoriesSearchBarView()
                
                List {
                    ForEach(memoriesVM.failedNSucceededMyMemoriesDataArray) { item in
                        if item.id == memoriesVM.failedNSucceededMyMemoriesDataArray[memoriesVM.failedNSucceededMyMemoriesDataArray.count-1].id {
                            MyMemoriesMainListItemView(item: item)
                                .background(NavigationLink("", destination: {
                                    if !memoriesVM.failedNSucceededMyMemoriesDataArray.isEmpty {
                                        MyMemoriesListItemsView(item: $memoriesVM.failedNSucceededMyMemoriesDataArray)
                                    }
                                }).opacity(0))
                        }
                    }
                    
                    if memoriesVM.failedNSucceededMyMemoriesDataArray.isEmpty {
                        ZeroMyMemoriesMainListItemView()
                    }
                    
                    if memoriesVM.followingsMemoriesDataArray.isEmpty {
                        Section {
                            Text("No recent updates to show right now.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity)
                        }
                    } else {
                        //recent updates
                        Section {
                            ForEach(memoriesVM.filteredFollowingsMemoriesDataArray, id: \.self) { aFollowingUserMemoriesDataArray in
                                FollowingsMemoriesListItemView(item: aFollowingUserMemoriesDataArray)
                            }
                        } header: {
                            Text("Recent Updates")
                                .font(.footnote)
                        }
                    }
                }
                .listStyle(.grouped)
                .sheet(isPresented: $memoriesVM.isPresentedMyFollowingsMemoriesSheet) {
                    MyFollowingsMemoriesSheetContentView(
                        memoriesData: $memoriesVM.selectedFollowingUserMemoriesDataArrayItem,
                        showSheet: $memoriesVM.isPresentedMyFollowingsMemoriesSheet
                    )
                        .onAppear {
                            memoriesVM.pauseMemoryUploadDTCalculatorTimer()
                        }
                        .onDisappear {
                            memoriesVM.resumeMemoryUploadDTCalculatorTimer()
                        }
                }
            }
            .onReceive(memoriesVM.memoriesUploadStateCheckingTimer) { _ in
                DispatchQueue.main.async {
                    memoriesVM.sendingCount = 0
                }
                for item in memoriesVM.failedNSucceededMyMemoriesDataArray {
                    if item.uploadStatus == .pending || item.uploadStatus == .failed {
                        DispatchQueue.main.async {
                            memoriesVM.sendingCount += 1
                        }
                    }
                }
                
                if !memoriesVM.isDeletionInProgress {
                    memoriesVM.getMyMemoriesDataFromUserDefaults()
                }
                
                memoriesVM.getMyFollowingsMemoriesDataFromUserDefaults()
            }
            .onReceive(memoriesVM.myMemoriesReuploadingNRedeletingNFollowingMemoriesReflaggingTimer) { _ in
                if networkManager.connectionStatus == .connected {
                    
                    memoriesVM.redeletionMyMemoryListItemFromUserDefaultsNFirestore()
                    
                    imageBasedMemoryVM.pendingNFailedImageBasedMyMemoriesReuploader()
                    
                    textBasedMemoryVM.pendingNFailedTextBasedMyMemoriesReuploader()
                    
                    memoriesVM.reuploadFailedFollowingsMemorySeenFlagInFirestoreNStoreInUserDefaults()
                }
            }
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) { NavigationBarLeadingItemsView() }
                
                ToolbarItem(placement: .navigationBarTrailing) { NavigationBarTrailingItemsView() }
                
                ToolbarItem(placement: .keyboard) { HideKeyboardPlacementView() }
            })
            .navigationTitle("Memories 🇱🇰")
            .navigationViewStyle(.stack)
        }
        .onAppear {
            memoriesVM.resumeMemoryUploadDTCalculatorTimer()
        }
        .onDisappear {
            memoriesVM.pauseMemoryUploadDTCalculatorTimer()
        }
    }
}

// MARK: PREVIEWS
struct MemoriesView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MemoriesView().preferredColorScheme(.dark)
            MemoriesView()
        }
        .environmentObject(ColorTheme())
        .environmentObject(MemoriesViewModel())
        .environmentObject(TextBasedMemoryViewModel())
        .environmentObject(ImageBasedMemoryViewModel())
        .environmentObject(ProfileBasicInfoViewModel())
        .environmentObject(NetworkManger())
    }
}
