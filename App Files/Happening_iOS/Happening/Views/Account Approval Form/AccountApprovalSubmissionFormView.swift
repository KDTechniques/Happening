//
//  AccountApprovalSubmissionFormView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-11-14.
//

import SwiftUI

struct AccountApprovalSubmissionFormView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var color: ColorTheme
    @EnvironmentObject var approvalFormViewModel: ApprovalFormViewModel
    @EnvironmentObject var authenticatedUserViewModel: AuthenticatedUserViewModel
    @EnvironmentObject var signinViewModel: SignInViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @EnvironmentObject var currentUser: CurrentUser
    @EnvironmentObject var editPhoneNumberViewModel: EditPhoneNumberViewModel
    
    // controls the focus state of the text fields
    @FocusState private var fieldInFocus: ApprovalFormViewModel.FieldType?
    
    // MARK: BODY
    var body: some View {
        accountApprovalSubmissionFormView
    }
}

// MARK: PREVIEW
struct AccountApprovalSubmissionFormView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            NavigationView {
                AccountApprovalSubmissionFormView()
                    .preferredColorScheme(.dark)
            }
            
            NavigationView {
                AccountApprovalSubmissionFormView()
            }
        }
        .environmentObject(AuthenticatedUserViewModel())
        .environmentObject(ColorTheme())
        .environmentObject(ApprovalFormViewModel())
        .environmentObject(SignInViewModel())
        .environmentObject(SettingsViewModel())
        .environmentObject(CurrentUser())
        .environmentObject(EditPhoneNumberViewModel())
    }
}

// MARK: COMPONENTS
extension AccountApprovalSubmissionFormView {
    
    
    // MARK: accountApprovalSubmissionFormView
    private var accountApprovalSubmissionFormView: some View {
        NavigationView {
            VStack(spacing: 0) {
                ImageNameInstructions()
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.45)){
                            approvalFormViewModel.isPresentedDatePicker = false
                        }
                        hideKeyboard()
                    }
                Divider()
                approvalForm
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { navigationBarLeadingItems }
                ToolbarItem(placement: .confirmationAction) { navigationBarTrailingItems }
                ToolbarItem(placement: .keyboard) { HideKeyboardPlacementView() }
            }
            .onAppear {
                approvalFormViewModel.isDisabledApprovalForm = false
            }
        }
        .disabled(approvalFormViewModel.isDisabledApprovalForm)
        .sheet(isPresented: $approvalFormViewModel.isPresentedPhoneNoVerificationSheet) {
            ApprovalFormPhoneNoOTPSheetView()
        }
        .overlay(alignment: .center) {
            if(approvalFormViewModel.isPresentedLoadingView) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.ultraThinMaterial)
                    .frame(width: 140, height: 140)
                    .overlay(
                        VStack {
                            ProgressView()
                                .padding(.bottom, 5)
                            
                            Text("Loading...")
                                .font(.subheadline.weight(.semibold))
                        }
                            .tint(.primary)
                    )
            }
            
            if(approvalFormViewModel.isPresentedSubmitLoadingView) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.ultraThinMaterial)
                    .frame(width: 140, height: 140)
                    .overlay(
                        VStack {
                            ProgressView()
                                .padding(.bottom, 5)
                            
                            Text("Submitting...")
                                .font(.subheadline.weight(.semibold))
                        }
                            .tint(.primary)
                    )
            }
        }
    }
    
    // MARK: navigationBarLeadingItems
    private var navigationBarLeadingItems: some View {
        Button {
            currentUser.signOutUser()
        } label: {
            Text("Sign out")
        }
    }
    
    // MARK: navigationBarTrailingItems
    private var navigationBarTrailingItems: some View {
        Button {
            approvalFormViewModel.submitForm()
        } label: {
            Text("Submit")
        }
        .disabled(!approvalFormViewModel.isCompleted)
    }
    
    // MARK: form
    private var approvalForm: some View {
        ZStack {
            Form {
                // MARK: Section 1 - Personal Information
                Section {
                    // name
                    NameListSection(fieldInFocus: self.$fieldInFocus)
                    
                    // nic no
                    NICSelection(fieldInFocus: self.$fieldInFocus)
                    
                    // date of birth
                    DateOfBirthSection()
                        .alert(isPresented: $approvalFormViewModel.isPresentedSubmittingErrorAlert) {
                            cancelOKAlertReturner(title: "Unable to Submit", message: "An error occurred while submitting the approval form.")
                        }
                    
                    // gender
                    GenderSelection()
                } header: {
                    Text("Personal Information")
                        .font(.footnote)
                } footer: {
                    Text("*required")
                        .font(.footnote)
                }
                
                // MARK: Section 2 - Age
                Section {
                    AgeSection()
                } header: {
                    Text("Age")
                        .font(.footnote)
                }
                
                // MARK: Section 3 - Profession
                Section {
                    ProfessionSelection()
                } footer: {
                    Text("Select the profession as 'None' If you do not want other people to see your profession.")
                }
                
                // MARK: Section 4 - Contactable At
                Section {
                    AddressListSection(fieldInFocus: self.$fieldInFocus)
                    
                    EmailAddressSection(fieldInFocus: self.$fieldInFocus)
                    
                    PhoneNoSection(fieldInFocus: self.$fieldInFocus)
                } header: {
                    Text("Contactable At")
                        .font(.footnote)
                } footer: {
                    Text("*required")
                        .font(.footnote)
                }
                
                // MARK: Section 5 - Authenticity Verification
                // nic image upload section and profile Photo upload section
                Section {
                    NICImageListSection()
                    
                    ProfilePictureSection()
                } header: {
                    Text("Authenticity Verification")
                        .font(.footnote)
                } footer: {
                    Text("*required")
                        .font(.footnote)
                }
            }
            .onChange(of: fieldInFocus) {
                approvalFormViewModel.fieldInFocus = $0
            }
            .alert(isPresented: $approvalFormViewModel.isPresentedAlphabeticalCharactersOnlyAlert) {
                cancelOKAlertReturner(title: "Only Alphabetical Characters Are Allowed")
            }
            .onAppear(perform: {
                approvalFormViewModel.navigationLabelColorUpdator()
                approvalFormViewModel.enabelSubmitButton()
                approvalFormViewModel.isPresentedLoadingView = false
                approvalFormViewModel.isDisabledApprovalForm = false
            })
            
            if(approvalFormViewModel.isPresentedDatePicker){
                DatePickerView()
                    .zIndex(1)
            }
        }
    }
}
