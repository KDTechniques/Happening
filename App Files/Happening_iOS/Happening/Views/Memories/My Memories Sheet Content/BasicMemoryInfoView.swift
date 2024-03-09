//
//  BasicMemoryInfoView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-05-01.
//

import SwiftUI

struct BasicMemoryInfoView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var memoriesVM: MemoriesViewModel
    @EnvironmentObject var profileBasicInfoViewModel: ProfileBasicInfoViewModel
    
    let memoriesData: [MyMemoriesModel]
    
    @Binding var showSheet: Bool
    @Binding var isPresentedViewersSheet: Bool
    
    let defaults = UserDefaults.standard
    
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
            
            if let data = defaults.data(forKey: profileBasicInfoViewModel.profilePhotoUserDefaultsKeyName) {
                Image(uiImage: UIImage(data: data)!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 35, height: 35)
                    .clipShape(Circle())
            }
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Me")
                    .fontWeight(.semibold)
                
                if memoriesData[memoriesVM.selectedMyMemoryIndex].uploadStatus != .uploaded {
                    HStack(spacing: 5) {
                        Image("msgPending")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 10)
                        
                        Text("Sending...")
                    }
                } else {
                    let dt = memoriesVM.memoriesUploadedDateOrTimeCalculator( fullUploadedDT: memoriesData[memoriesVM.selectedMyMemoryIndex].fullUploadedDT, date: memoriesData[memoriesVM.selectedMyMemoryIndex].uploadedDate, time: memoriesData[memoriesVM.selectedMyMemoryIndex].uploadedTime)
                    
                    let time = memoriesData[memoriesVM.selectedMyMemoryIndex].uploadedTime
                    
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
            }
            
            Spacer()
        }
        .foregroundColor(.white)
        .padding(.horizontal)
        .font(.footnote)
    }
}
