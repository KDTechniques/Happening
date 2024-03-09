//
//  MyMemoriesSheetContentView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-01-09.
//

import SwiftUI
import SDWebImageSwiftUI

struct MyMemoriesSheetContentView: View {
    
    // MARK:  PROPERTIES
    @EnvironmentObject var memoriesVM: MemoriesViewModel
    @EnvironmentObject var profileBasicInfoViewModel: ProfileBasicInfoViewModel
    
    @Binding var memoriesData: [MyMemoriesModel]
    
    private let screenWidth: CGFloat = UIScreen.main.bounds.size.width
    private let screenHeight: CGFloat = UIScreen.main.bounds.size.height
    
    @Binding var showSheet: Bool
    
    @State private var count: Int = 0
    
    @State private var shallPause: Bool = false
    
    @State private var isPresentedViewersSheet: Bool = false
    
    // MARK: BODY
    var body: some View {
        ZStack {
            if memoriesData[memoriesVM.selectedMyMemoryIndex].memoryType == .imageBased {
                ImageBasedMyMemoryImageView(
                    memoriesData: memoriesData
                )
            } else { // text based
                /// this view will present when there's an text based memory that conforms to uiimage type
                TextBasedMyMemoryImageView(
                    memoriesData: memoriesData
                )
            }
            
            VStack {
                /// this view controls the progress of every memory that is displaying
                MyMemoriesProgressBarsView(
                    memoriesData: memoriesData,
                    showSheet: $showSheet,
                    count: $count
                )
                
                /// this view shows the user profile photo, uploaded date & time and back button to close the sheet
                BasicMemoryInfoView(
                    memoriesData: memoriesData,
                    showSheet: $showSheet,
                    isPresentedViewersSheet: $isPresentedViewersSheet
                )
                
                /// this view helps to navigate through memory items when tap on left or right and pauses the current memory
                MyMemoriesNavigatorBackgroundSectionsView(
                    isPresentedViewersSheet: $isPresentedViewersSheet,
                    count: $count,
                    shallPause: $shallPause,
                    showSheet: $showSheet,
                    memoriesData: memoriesData
                )
                
                /// this view shows the caption of the memory if it's a image based memory and open up a sheet that has viewers details
                CaptionNViewersButtonView(
                    memoriesData: memoriesData,
                    isPresentedViewersSheet: $isPresentedViewersSheet
                )
            }
            .padding(.top,
                     bioMetricIdentifier() == BioMetricType.faceID.rawValue
                     ? 50 : 25
            )
            .padding(.bottom,
                     bioMetricIdentifier() == BioMetricType.faceID.rawValue
                     ? 50 : 30
            )
            
            /// this sheet view contains all the viewers details related to a purticular memory
            ViewersSheetContentView(
                item: memoriesData[memoriesVM.selectedMyMemoryIndex].seenersData,
                showSheet: $isPresentedViewersSheet
            )
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            memoriesVM.memoryProgressBartimer2 = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
            memoriesVM.connectedTimer2 = memoriesVM.memoryProgressBartimer2.upstream.connect()
        }
        .onDisappear {
            memoriesVM.connectedTimer2?.cancel()
        }
    }
}
