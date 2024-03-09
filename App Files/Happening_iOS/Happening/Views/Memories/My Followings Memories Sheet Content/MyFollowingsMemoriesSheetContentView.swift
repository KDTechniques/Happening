//
//  MyFollowingsMemoriesSheetContentView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-05-09.
//

import SwiftUI
import SDWebImageSwiftUI

struct MyFollowingsMemoriesSheetContentView: View {
    
    // MARK:  PROPERTIES
    @EnvironmentObject var memoriesVM: MemoriesViewModel
    @EnvironmentObject var profileBasicInfoViewModel: ProfileBasicInfoViewModel
    
    @Binding var memoriesData: [FollowingsMemoriesModel]
    
    private let screenWidth: CGFloat = UIScreen.main.bounds.size.width
    private let screenHeight: CGFloat = UIScreen.main.bounds.size.height
    
    @Binding var showSheet: Bool
    
    @State private var count: Int = 0
    
    @State private var shallPause: Bool = false
    
    @State private var isPresentedViewersSheet: Bool = false
    
    // MARK: BODY
    var body: some View {
        ZStack {
            ZStack {
                if memoriesData[memoriesVM.selectedFollowingsMemoryIndex].memoryType == .imageBased {
                    ImageBasedMyFollowingsMemoryImageView(memoriesData: $memoriesData)
                } else { // text based
                    /// this view will present when there's an text based memory that conforms to uiimage type
                    TextBasedMyFollowingsMemoryImageView(memoriesData: $memoriesData)
                }
            }
            
            VStack {
                /// this view controls the progress of every memory that is displaying
                MyFollowingsMemoriesProgressBarsView(
                    memoriesData: $memoriesData,
                    showSheet: $showSheet,
                    count: $count
                )
                
                /// this view shows the user profile photo, uploaded date & time and back button to close the sheet
                FollowingUserBasicMemoryInfoView(
                    memoriesData: $memoriesData,
                    showSheet: $showSheet,
                    isPresentedViewersSheet: $isPresentedViewersSheet
                )
                
                /// this view helps to navigate through memory items when tap on left or right and pauses the current memory
                MyFollowingsMemoriesNavigatorBackgroundSectionsView(
                    isPresentedViewersSheet: $isPresentedViewersSheet,
                    count: $count,
                    shallPause: $shallPause,
                    showSheet: $showSheet,
                    memoriesData: $memoriesData
                )
                
                /// this view shows the caption of the memory if it's a image based memory and open up a sheet that has viewers details
                CaptionView(
                    memoriesData: $memoriesData,
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
