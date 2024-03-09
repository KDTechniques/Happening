//
//  Testing1.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-02-17.
//

import SwiftUI
import Network

struct Testing1: View {
    
    @EnvironmentObject var networkManager: NetworkManger
    
    var body: some View {
        VStack {
            Text(networkManager.connectionStatus == .connected ? "Connected to Internet 👨🏻‍💻" : "No Internet Connection 😕")
                .font(.largeTitle).fontWeight(.heavy)
                .padding()
        }
    }
}

struct Testing1_Previews: PreviewProvider {
    static var previews: some View {
        Testing1()
            .environmentObject(NetworkManger())
    }
}
