//
//  HappeningApp.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-11-11.
//

import SwiftUI
import Firebase

@main
struct HappeningApp: App {
    @StateObject var color = ColorTheme.shared
    @StateObject var faceID = FaceIDAuthentication.shared
    @StateObject var facebook = FacebookLoginManager.shared
    @StateObject var google = GoogleLoginManager.shared
    @StateObject var approvalFormVM = ApprovalFormViewModel.shared
    @StateObject var signInVM = SignInViewModel.shared
    @StateObject var authenticatedUserVM = AuthenticatedUserViewModel.shared
    @StateObject var contentVM = ContentViewModel.shared
    @StateObject var settingsVM = SettingsViewModel.shared
    @StateObject var updateProfilePhotoVM = UpdateProfilePhotoViewModel.shared
    @StateObject var editProfileVM = EditProfileViewModel.shared
    @StateObject var memoriesVM = MemoriesViewModel.shared
    @StateObject var biometricAuthenticationAnimationVM = BiometricAuthenticationAnimationViewModel.shared
    @StateObject var phoneNoAuthManager = PhoneNoAuthManager.shared
    @StateObject var currentUser = CurrentUser.shared
    @StateObject var profileBasicInfoVM = ProfileBasicInfoViewModel.shared
    @StateObject var editUserNameVM = EditUserNameViewModel.shared
    @StateObject var updateProfessionVM = UpdateProfessionViewModel.shared
    @StateObject var editAboutVM = EditAboutViewModel.shared
    @StateObject var editAddressVM = EditAddressViewModel.shared
    @StateObject var editPhoneNumberVM = EditPhoneNumberViewModel.shared
    @StateObject var editEmailAddressVM = EditEmailAddressViewModel.shared
    @StateObject var qrCodeVM = QRCodeViewModel.shared
    @StateObject var myFollowersSectionVM = MyFollowersFollowingsListViewModel.shared
    @StateObject var themeColorPickerVM = ThemeColorPickerViewModel.shared
    @StateObject var feedbackSupportVM = FeedbackSupportViewModel.shared
    @StateObject var contactPickerSheetVM = ContactPickerSheetViewModel.shared
    @StateObject var appInitializer = AppInitializer.shared
    @StateObject var networkManger = NetworkManger.shared
    @StateObject var otpSheetVM = OTPSheetViewModel.shared
    @StateObject var myHappeningLocationMapVM = MyHappeningLocationMapViewModel.shared
    @StateObject var locationSearchService = LocationSearchService.shared
    @StateObject var createAHappeningVM = CreateAHappeningViewModel.shared
    @StateObject var myHappeningsVM = MyHappeningsViewModel.shared
    @StateObject var publicProfileInfoVM = PublicProfileInfoViewModel.shared
    @StateObject var userProfileInfoVM = UserProfileInfoViewModel.shared
    @StateObject var blockedUsersVM = BlockedUsersViewModel.shared
    @StateObject var happeningsVM = HappeningsViewModel.shared
    @StateObject var notificationsVM = NotificationsViewModel.shared
    @StateObject var notificationManager = NotificationManager.shared
    @StateObject var messageSheetVM = MessageSheetViewModel.shared
    @StateObject var reservedHVM = ReservedHViewModel.shared
    @StateObject var participatedMessagesVM = ParticipatorMessagesViewModel.shared
    @StateObject var creatorMessagesVM = CreatorMessagesViewModel.shared
    @StateObject var participatedHVM = ParticipatedHViewModel.shared
    @StateObject var textBasedMemoryVM = TextBasedMemoryViewModel.shared
    @StateObject var imageBasedMemoryVM = ImageBasedMemoryViewModel.shared
    @StateObject var fileManager = LocalFileManager.shared
    
    // initializer modifications affect to the whole application.
    init() {
        
        // hide all the scroll indicators.
        UITableView.appearance().showsVerticalScrollIndicator = false
        
        // set navigation bar apperance to Custom dark & light color.
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = UIColor(Color("NavBarTabBarColor"))
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        
        // set tab bar apperance to custom dark & light color.
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = UIColor(Color("NavBarTabBarColor"))
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        UITabBar.appearance().standardAppearance = tabBarAppearance
        
        // set text editor's background color to clear, so customization can be easy.
        UITextView.appearance().backgroundColor = .clear
        
        FacebookLoginManager.shared.facebookLogout()
        GoogleLoginManager.shared.googleSignOut()
        // do same for the apple
    }
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            // Shows brand logo Animations & transitions
            LaunchScreenView()
                .navigationViewStyle(StackNavigationViewStyle())
                .dynamicTypeSize(.large)
                .tint(color.accentColor)
                .accentColor(color.accentColor)
                .environmentObject(color)
                .environmentObject(faceID)
                .environmentObject(facebook)
                .environmentObject(google)
                .environmentObject(approvalFormVM)
                .environmentObject(signInVM)
                .environmentObject(authenticatedUserVM)
                .environmentObject(contentVM)
                .environmentObject(settingsVM)
                .environmentObject(memoriesVM)
                .environmentObject(biometricAuthenticationAnimationVM)
                .environmentObject(phoneNoAuthManager)
                .environmentObject(currentUser)
                .environmentObject(profileBasicInfoVM)
                .environmentObject(editUserNameVM)
                .environmentObject(updateProfessionVM)
                .environmentObject(editAboutVM)
                .environmentObject(editAddressVM)
                .environmentObject(editPhoneNumberVM)
                .environmentObject(editEmailAddressVM)
                .environmentObject(editAddressVM)
                .environmentObject(qrCodeVM)
                .environmentObject(myFollowersSectionVM)
                .environmentObject(themeColorPickerVM)
                .environmentObject(feedbackSupportVM)
                .environmentObject(contactPickerSheetVM)
                .environmentObject(appInitializer)
                .environmentObject(updateProfilePhotoVM)
                .environmentObject(editProfileVM)
                .environmentObject(networkManger)
                .environmentObject(otpSheetVM)
                .environmentObject(myHappeningLocationMapVM)
                .environmentObject(locationSearchService)
                .environmentObject(createAHappeningVM)
                .environmentObject(myHappeningsVM)
                .environmentObject(publicProfileInfoVM)
                .environmentObject(userProfileInfoVM)
                .environmentObject(blockedUsersVM)
                .environmentObject(happeningsVM)
                .environmentObject(notificationsVM)
                .environmentObject(notificationManager)
                .environmentObject(messageSheetVM)
                .environmentObject(reservedHVM)
                .environmentObject(participatedMessagesVM)
                .environmentObject(creatorMessagesVM)
                .environmentObject(participatedHVM)
                .environmentObject(textBasedMemoryVM)
                .environmentObject(imageBasedMemoryVM)
                .environmentObject(fileManager)
        }
    }
}

struct RootPresentationModeKey: EnvironmentKey {
    static let defaultValue: Binding<RootPresentationMode> = .constant(RootPresentationMode())
}

extension EnvironmentValues {
    var rootPresentationMode: Binding<RootPresentationMode> {
        get { return self[RootPresentationModeKey.self] }
        set { self[RootPresentationModeKey.self] = newValue }
    }
}

typealias RootPresentationMode = Bool

extension RootPresentationMode {
    public mutating func dismiss() {
        self.toggle()
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        AppInitializer.shared.appInitializer()
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) { }
}
