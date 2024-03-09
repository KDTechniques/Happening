//
//  ContentView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-11-11.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: PROPERTIES
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var contentViewModel: ContentViewModel
    @EnvironmentObject var messageSheetVM: MessageSheetViewModel
    
    // MARK: BODY
    var body: some View {
        TabView(selection: $contentViewModel.selectedTab) {
            MemoriesView()
                .tabItem {
                    Image(colorScheme == .light
                          ? "\(contentViewModel.statusIconName.rawValue)Light"
                          : "\(contentViewModel.statusIconName.rawValue)Dark")
                    .renderingMode(contentViewModel.statusIconRenderingMode)
                    Text("Memories")
                }
                .tag(1)
            
            NotificationsView()
                .tabItem {
                    Image(systemName: "bell")
                    Text("Notifications")
                }
                .tag(2)
                .badge(contentViewModel.notificationViewBadgeCount)
            
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(3)
            
            MyHappeningsView()
                .tabItem {
                    Image(systemName: "person.crop.rectangle.stack.fill")
                    Text("My Happenings")
                }
                .tag(4)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
                .tag(5)
        }
        .onChange(of: contentViewModel.selectedTab, perform: { value in
            if(value == 1) {
                contentViewModel.statusIconName = .Normal
                contentViewModel.statusIconRenderingMode = .template
            }
        })
        .onAppear {
            contentViewModel.getSelectedTabFromUserDefaults()
        }
        .onChange(of: contentViewModel.selectedTab) { _ in
            contentViewModel.saveSelectedTabToUserDefaults()
        }
        .onReceive(messageSheetVM.getNAssignChatDataFromUserDefaultsTimer) { _ in
            messageSheetVM.AllOfMyChatDataArray = messageSheetVM.getMessagesFromUserDefaults()
        }
        .onReceive(messageSheetVM.pendingMessagesReuploaderTimer) { _ in
            messageSheetVM.pendingMessagesResender()
        }
    }
}

// MARK: PREVIEWS
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .preferredColorScheme(.dark)
            
            ContentView()
        }
        .environmentObject(ContentViewModel())
        .environmentObject(FaceIDAuthentication())
        .environmentObject(ColorTheme())
        .environmentObject(SettingsViewModel())
        .environmentObject(MemoriesViewModel())
        .environmentObject(MyHappeningsViewModel())
        .environmentObject(ProfileBasicInfoViewModel())
        .environmentObject(MyFollowersFollowingsListViewModel())
        .environmentObject(ThemeColorPickerViewModel())
        .environmentObject(NetworkManger())
        .environmentObject(FeedbackSupportViewModel())
        .environmentObject(HappeningsViewModel())
        .environmentObject(CreateAHappeningViewModel())
        .environmentObject(NotificationsViewModel())
        .environmentObject(MessageSheetViewModel())
        .environmentObject(ImageBasedMemoryViewModel())
        .environmentObject(TextBasedMemoryViewModel())
    }
}
