//
//  MyMemoriesListItemsView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-04-30.
//

import SwiftUI

struct MyMemoriesListItemsView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var textBasedMemoryVM: TextBasedMemoryViewModel
    @EnvironmentObject var memoriesVM: MemoriesViewModel
    
    @Binding var item: [MyMemoriesModel]
    
    @State private var isPresentedMyMemoriesSheet: Bool = false
    
    // MARK: BODY
    var body: some View {
        List {
            Section {
                ForEach(item) { dataItem in
                    MyMemoriesListItemView(item: dataItem)
                        .onTapGesture {
                            if let index = item.firstIndex(of: dataItem) {
                                memoriesVM.selectedMyMemoryIndex = index
                                isPresentedMyMemoriesSheet = true
                            }
                        }
                }
                .onDelete(perform: memoriesVM.deleteMyMemoryListItemFromUserDefaultsNFirestore)
            } footer: {
                Text("When deleting a memory update, it will also be deleted for everyone who received it.")
                    .font(.footnote)
            }
        }
        .listStyle(.grouped)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(Text("My Updates"))
        .sheet(isPresented: $isPresentedMyMemoriesSheet) {
            MyMemoriesSheetContentView(
                memoriesData: $item,
                showSheet: $isPresentedMyMemoriesSheet
            )
                .onAppear {
                    memoriesVM.pauseMemoryUploadDTCalculatorTimer()
                }
                .onDisappear {
                    memoriesVM.resumeMemoryUploadDTCalculatorTimer()
                }
        }
    }
}
