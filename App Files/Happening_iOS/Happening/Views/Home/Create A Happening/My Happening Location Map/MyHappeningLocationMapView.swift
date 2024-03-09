//
//  AppleMaps.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-03-03.
//

import SwiftUI
import MapKit

struct MyHappeningLocationMapView: View {
    
    // MARK: PROPERTIES
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var color: ColorTheme
    @EnvironmentObject var myHappeningLocationMapViewModel: MyHappeningLocationMapViewModel
    @EnvironmentObject var locationSearchService: LocationSearchService
    @EnvironmentObject var networkManager: NetworkManger
    @EnvironmentObject var createAHappeningVM: CreateAHappeningViewModel
    @EnvironmentObject var profileBasicInfoVM: ProfileBasicInfoViewModel
    
    let action: () -> ()
    
    // MARK: BODY
    var body: some View {
        ZStack {
            Map(coordinateRegion: $myHappeningLocationMapViewModel.region, showsUserLocation: true, annotationItems: myHappeningLocationMapViewModel.happeningLocation) {
                MapAnnotation(coordinate: $0.coordinate) {
                    CustomAnnotationPin(
                        photoURL: profileBasicInfoVM.basicProfileDataArray[0].profilePhotoURL,
                        notationText: createAHappeningVM.happeningTitleTextFieldText.isEmpty ? "Your Happening Location" : createAHappeningVM.happeningTitleTextFieldText,
                        isDynamicNotationTextColor: false
                    )
                }
            }
            .ignoresSafeArea()
            .accentColor(color.accentColor)
            .gesture(DragGesture().onChanged { _ in
                myHappeningLocationMapViewModel.whenDragMap()
            })
            .overlay(alignment: .topLeading) {
                Rectangle()
                    .fill(.black.opacity(0.5))
                    .frame(width: 100, height: 47)
                    .background(.ultraThinMaterial)
                    .cornerRadius(8)
                    .overlay {
                        HStack(spacing: 0) {
                            Spacer()
                            
                            Button {
                                withAnimation(.spring()) {
                                    myHappeningLocationMapViewModel.focusOnCurrentLocation()
                                }
                            } label: {
                                Image(systemName: "location")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 20)
                            }
                            
                            Spacer()
                            Divider()
                            Spacer()
                            
                            Button {
                                if(networkManager.connectionStatus == .connected) {
                                    if(myHappeningLocationMapViewModel.showLocationSetterPin) {
                                        myHappeningLocationMapViewModel.setHappeningAnnotation()
                                        vibrate(type: .success)
                                    } else {
                                        myHappeningLocationMapViewModel.removeHappeningAnnotation()
                                        vibrate(type: .warning)
                                    }
                                } else {
                                    createAHappeningVM.alertItemForMyHappeningLocationMapView = AlertItemModel(
                                        title: "Couldn't Set Happening Location",
                                        message: "Check your phone's connection and try again."
                                    )
                                }
                            } label: {
                                Image(systemName: myHappeningLocationMapViewModel.showLocationSetterPin ? "plus.circle" : "minus.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 20)
                            }
                            
                            Spacer()
                        }
                        .tint(.secondary)
                    }
                    .padding(.leading)
                    .padding(.top, 30)
            }
            .overlay(alignment: .topTrailing) {
                Rectangle()
                    .fill(.black.opacity(0.5))
                    .frame(width: 100, height: 47)
                    .background(.ultraThinMaterial)
                    .cornerRadius(8)
                    .overlay {
                        Button {
                            action()
                            if(myHappeningLocationMapViewModel.showLocationSetterPin) {
                                myHappeningLocationMapViewModel.happeningLocation.removeAll()
                            }
                        } label: {
                            Text("Done")
                                .foregroundColor(color.accentColor)
                        }
                    }
                    .padding(.trailing)
                    .padding(.top, 30)
            }
            
            if(myHappeningLocationMapViewModel.showLocationSetterPin) {
                CustomMovingAnnotationPin()
            }
            
            VStack {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .frame(maxWidth: .infinity)
                    .frame(height: 45)
                
                Spacer()
            }
            .edgesIgnoringSafeArea(.top)
            
            MapOverlaySheet()
        }
        .preferredColorScheme(.dark)
        .onAppear {
            MyHappeningLocationMapViewModel.shared.setMap()
            myHappeningLocationMapViewModel.checkIfLocationServiceIsEnabled()
        }
        .alert(item: $createAHappeningVM.alertItemForMyHappeningLocationMapView) { alert -> Alert in
            Alert(title: Text(alert.title), message: Text(alert.message), dismissButton: alert.dismissButton)
        }
    }
}

// MARK: PREVIEWS
struct MyHappeningLocationMapView_Previews: PreviewProvider {
    static var previews: some View {
        MyHappeningLocationMapView {
            print("Clicked on Done Button")
        }
        .environmentObject(LocationSearchService())
        .environmentObject(MyHappeningLocationMapViewModel())
        .environmentObject(ColorTheme())
        .environmentObject(NetworkManger())
        .environmentObject(CreateAHappeningViewModel())
        .environmentObject(ProfileBasicInfoViewModel())
    }
}
