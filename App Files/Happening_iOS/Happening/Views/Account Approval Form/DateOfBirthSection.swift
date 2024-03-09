//
//  DateOfBirthSection.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-12-23.
//

import SwiftUI

struct DateOfBirthSection: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var color: ColorTheme
    @EnvironmentObject var approvalFormViewModel: ApprovalFormViewModel
    
    // MARK: BODY
    var body: some View {
        Button {
            hideKeyboard()
            withAnimation(.easeInOut(duration: 0.45)){
                approvalFormViewModel.isPresentedDatePicker = true
            }
        } label: {
            HStack {
                Text("Date of Birth")
                    .foregroundColor(approvalFormViewModel.isChangedAccentColorBirthDate ? .primary : color.accentColor)
                Spacer()
                Text(approvalFormViewModel.dateFormatter.string(from: approvalFormViewModel.formData.dateOfBirth))
                    .foregroundColor(Color.secondary)
            }
        }
    }
}

// MARK: PREVIEW
struct DateOfBirthSection_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                Form {
                    Section{
                        DateOfBirthSection()
                            .preferredColorScheme(.dark)
                    }
                }
            }
            NavigationView {
                Form {
                    Section{
                        DateOfBirthSection()
                    }
                }
            }
        }
        .environmentObject(ApprovalFormViewModel())
        .environmentObject(ColorTheme())
    }
}
