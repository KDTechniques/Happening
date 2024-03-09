//
//  HappeningApp.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-11-04.
//

import SwiftUI
import Firebase

@main
struct HappeningApp: App {
    
    @StateObject var faceID = FaceIDAuthentication.shared
    @StateObject var pendingApprovalViewModel = PendingApprovalViewModel.shared
    @StateObject var userDataViewModel = UserDataViewModel.shared
    @StateObject var networkManager = NetworkManger.shared
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            LaunchScreenView()
                .navigationViewStyle(StackNavigationViewStyle())
                .dynamicTypeSize(.large)
                .environmentObject(faceID)
                .environmentObject(pendingApprovalViewModel)
                .environmentObject(userDataViewModel)
                .environmentObject(networkManager)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) { }
}

