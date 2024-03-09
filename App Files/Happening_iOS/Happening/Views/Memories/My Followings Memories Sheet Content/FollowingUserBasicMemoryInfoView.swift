//
//  FollowingUserBasicMemoryInfoView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-05-09.
//

import SwiftUI
import SDWebImageSwiftUI

struct FollowingUserBasicMemoryInfoView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var memoriesVM: MemoriesViewModel
    @EnvironmentObject var profileBasicInfoViewModel: ProfileBasicInfoViewModel
    
    @Binding var memoriesData: [FollowingsMemoriesModel]
    
    @Binding var showSheet: Bool
    @Binding var isPresentedViewersSheet: Bool
    
    // MARK: BODY
    var body: some View {
        HStack {
            Button {
                withAnimation(.spring()) {
                    showSheet = false
                    isPresentedViewersSheet = false
                    
                    memoriesVM.pauseMemoryProgressBar()
                }
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title2.weight(.bold))
            }
            
            WebImage(url: URL(string: memoriesData[0].profilePhotoThumbnailURL))
                .resizable()
                .placeholder {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                }
                .indicator(.activity)
                .scaledToFill()
                .frame(width: 35, height: 35)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 0) {
                Text(memoriesData[memoriesVM.selectedFollowingsMemoryIndex].userName)
                    .fontWeight(.semibold)
                
                let dt = memoriesVM.memoriesUploadedDateOrTimeCalculator( fullUploadedDT: memoriesData[memoriesVM.selectedFollowingsMemoryIndex].fullUploadedDT, date: memoriesData[memoriesVM.selectedFollowingsMemoryIndex].uploadedDate, time: memoriesData[memoriesVM.selectedFollowingsMemoryIndex].uploadedTime)
                
                let time = memoriesData[memoriesVM.selectedFollowingsMemoryIndex].uploadedTime
                
                if dt.contains("just now") || dt.contains("ago") || dt.contains("today") {
                    Text(time)
                } else {
                    if dt.contains("AM") || dt.contains("PM") {
                        Text(dt)
                    } else {
                        Text("\(dt), \(time)")
                    }
                }
            }
            
            Spacer()
        }
        .foregroundColor(.white)
        .padding(.horizontal)
        .font(.footnote)
    }
}
