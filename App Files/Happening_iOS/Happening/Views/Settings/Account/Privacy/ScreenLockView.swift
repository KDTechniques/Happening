//
//  ScreenLockView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-02-26.
//

import SwiftUI

struct ScreenLockView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var faceID: FaceIDAuthentication
    
    var body: some View {
        List {
            Section {
                Toggle("Require \(bioMetricIdentifier())", isOn: $faceID.isFaceIDAuthenticationEnabled)
                    .onChange(of: faceID.isFaceIDAuthenticationEnabled, perform: { value in
                        UserDefaults.standard.set(value, forKey: faceID.userDefaultsKeyName)
                    })
                    .tint(Color.green)
            } footer: {
                Text("When enabled, you will need to use \(bioMetricIdentifier()) to unlock Happening.")
            }
        }
        .listStyle(.grouped)
        .navigationTitle(Text("Screen Lock"))
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: PREVIEWS
struct ScreenLockView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                ScreenLockView()
                    .preferredColorScheme(.dark)
            }
            
            NavigationView {
                ScreenLockView()
            }
        }
        .environmentObject(FaceIDAuthentication())
    }
}
