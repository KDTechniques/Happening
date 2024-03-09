//
//  CreateAHappeningView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-03-06.
//

import SwiftUI

struct CreateAHappeningView: View {
    
    // MARK: PROPERTIES
    @Environment(\.dismiss) var presentationMode
    @EnvironmentObject var color: ColorTheme
    @EnvironmentObject var myHappeningLocationMapVM: MyHappeningLocationMapViewModel
    @EnvironmentObject var createAHappeningVM: CreateAHappeningViewModel
    
    // MARK: BODY
    var body: some View {
        List {
            // title
            HappeningTitle()
            
            // add happening photos
            AddHappeningPhotos()
            
            // description
            HappeningDescription()
            
            // date & time
            HappeningDateAndTime()
            
            // set happening location on maps
            SetHappeningLocation()
            
            // address
            HappeningAddress()
            
            // contact number
            HappeningContactNumber()
            
            // no. spaces
            HappeningNoOfSpaces()
            
            // space fee
            HappeningSpaceFee()
        }
        .disabled(createAHappeningVM.isDisabledCreateAHappeningView)
        .listStyle(.grouped)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(createAHappeningVM.isDisabledCreateAHappeningView)
        .toolbar {
            ToolbarItem(placement: .keyboard) { HideKeyboardPlacementView() }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Create") {
                    createAHappeningVM.createAHappening { status in
                        if(status) {
                            presentationMode.callAsFunction()
                        } else {
                            presentationMode.callAsFunction()
                        }
                    }
                }
                .font(.body.weight(.semibold))
                .disabled(createAHappeningVM.isDisabledCreateButton)
            }
            
            ToolbarItem(placement: .principal) {
                if(createAHappeningVM.isPresentedCreatingProgress) {
                    CustomProgressView1(text: Binding.constant("Creating..."))
                } else {
                    Text("Create a Happening")
                        .fontWeight(.semibold)
                }
            }
        }
        .fullScreenCover(isPresented: $createAHappeningVM.isPresentedSheetForMapView) {
            myHappeningLocationMapVM.whenDismissed()
        } content: {
            MyHappeningLocationMapView {
                createAHappeningVM.isPresentedSheetForMapView = false
            }
        }
        .alert(item: $createAHappeningVM.alertItemForCreateAHappeningView) { alert -> Alert in
            Alert(title: Text(alert.title), message: Text(alert.message), dismissButton: alert.dismissButton)
        }
    }
}

// MARK: PREVIEWS
struct CreateAHappeningView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                CreateAHappeningView()
            }
            
            NavigationView {
                CreateAHappeningView()
            }
            .preferredColorScheme(.dark)
        }
        .environmentObject(ColorTheme())
        .environmentObject(MyHappeningLocationMapViewModel())
        .environmentObject(LocationSearchService())
        .environmentObject(MyHappeningLocationMapViewModel())
        .environmentObject(CreateAHappeningViewModel())
        .environmentObject(NetworkManger())
    }
}
