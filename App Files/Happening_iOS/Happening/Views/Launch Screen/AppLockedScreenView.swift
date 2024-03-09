//
//  AppLockedScreenView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-02-09.
//

import SwiftUI

struct AppLockedScreenView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var color: ColorTheme
    @EnvironmentObject var faceID: FaceIDAuthentication
    
    // MARK: BODY
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "lock.fill")
                .font(.system(size: 40))
            
            Text("Happening Locked")
                .font(.title.weight(.semibold))
                .padding(.top)
            
            Text("Unlock with \(bioMetricIdentifier()) to open Happening")
                .font(.subheadline)
            
            Button("Use \(bioMetricIdentifier())") {
                faceID.authenticate()
            }
            .font(.subheadline)
            .padding(.top, 30)
            .tint(color.accentColor)
        }
    }
}

// MARK: PREVIEWS
struct AppLockedScreenView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AppLockedScreenView()
            AppLockedScreenView().preferredColorScheme(.dark)
        }
        .environmentObject(FaceIDAuthentication())
        .environmentObject(ColorTheme())
    }
}
