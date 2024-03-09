//
//  ContactMeSection.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-01-06.
//

import SwiftUI

struct ContactMeSection: View {
    
    // MARK: PROPERTIES
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var feedbackSupportViewModel: FeedbackSupportViewModel
    
    // reference to UserDefaults
    let defaults = UserDefaults.standard
    
    // MARK: BODY
    var body: some View {
        Section {
            Toggle("Contact Me at My Email Address", isOn: $feedbackSupportViewModel.feedbackData.contactUser)
                .tint(Color.green)
        } footer: {
            VStack(alignment: .leading) {
                Text("The Happening will contact you about this feedback at your email address.")
                    .fixedSize(horizontal: false, vertical: true)
                
                Text("Your email address: \(Text("\(defaults.string(forKey: EditProfileViewModel.EditProfileViewUserDefaultsType.email.rawValue) ?? "...")").fontWeight(.semibold))")
                    .allowsHitTesting(false)
                    .padding(.vertical, 6)
                
                Text("[Happening Services Agreement](https://example.com)")
                    .padding(.vertical, 20)
                
                Text("[Privacy Statement](https://example.com)")
            }
            .font(.footnote)
        }
    }
}

// MARK: PREVIEWS
struct ContactMeSection_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                List {
                    ContactMeSection()
                        .preferredColorScheme(.dark)
                }
                .listStyle(.grouped)
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(Text(FeedbackTypes.like.rawValue))
            }
            
            NavigationView {
                List {
                    ContactMeSection()
                }
                .listStyle(.grouped)
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(Text(FeedbackTypes.suggestion.rawValue))
            }
        }
        .environmentObject(FeedbackSupportViewModel())
        .environmentObject(ProfileBasicInfoViewModel())
    }
}
