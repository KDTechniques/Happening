//
//  MapOverlaySheet.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-03-05.
//

import SwiftUI
import MapKit

struct MapOverlaySheet: View {
    @EnvironmentObject var myHappeningLocationMapViewModel: MyHappeningLocationMapViewModel
    var body: some View {
        LocationSearchListView()
            .offset(y: myHappeningLocationMapViewModel.startingOffsetY)
            .offset(y: myHappeningLocationMapViewModel.currentDragOffsetY)
            .offset(y: myHappeningLocationMapViewModel.endingOffsetY)
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        if !(myHappeningLocationMapViewModel.endingOffsetY == -myHappeningLocationMapViewModel.startingOffsetY && value.translation.height < 0) {
                            withAnimation(.spring()) {
                                myHappeningLocationMapViewModel.currentDragOffsetY = value.translation.height
                            }
                        }
                    })
                    .onEnded({ value in
                        withAnimation(.spring()) {
                            if(myHappeningLocationMapViewModel.currentDragOffsetY < -150) {
                                myHappeningLocationMapViewModel.endingOffsetY = -myHappeningLocationMapViewModel.startingOffsetY
                            } else if(myHappeningLocationMapViewModel.endingOffsetY != 0 && myHappeningLocationMapViewModel.currentDragOffsetY > 150) {
                                myHappeningLocationMapViewModel.endingOffsetY = 0
                            }
                            myHappeningLocationMapViewModel.currentDragOffsetY = 0
                        }
                    })
            )
    }
}

struct MapOverlaySheet_Previews: PreviewProvider {
    static var previews: some View {
        MyHappeningLocationMapView {
            print("Clicked on Done Button")
        }
        .environmentObject(ColorTheme())
        .environmentObject(MyHappeningLocationMapViewModel())
        .environmentObject(LocationSearchService())
        .environmentObject(CreateAHappeningViewModel())
    }
}

struct LocationSearchListView: View {
    
    @EnvironmentObject var myHappeningLocationMapViewModel: MyHappeningLocationMapViewModel
    @EnvironmentObject var locationSearchService: LocationSearchService
    
    var body: some View {
        VStack {
            Rectangle()
                .frame(width: 100, height: 4)
                .cornerRadius(.infinity)
                .padding(.top, 10)
            
            SearchBarView(searchText: $locationSearchService.queryFragment, isSearching: $myHappeningLocationMapViewModel.isSearching)
                .padding(.top, 10)
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    Group { () -> AnyView in
                        switch locationSearchService.status {
                        case .noResults:
                            return AnyView(Text("No Results").padding())
                            
                        case .error(let description):
                            return AnyView(Text(description).padding())
                            
                        default:
                            return AnyView(EmptyView())
                        }
                    }
                    .foregroundColor(.secondary)
                    
                    ForEach(locationSearchService.searchResults, id: \.self) { completionResult in
                        HStack {
                            Button {
                                myHappeningLocationMapViewModel.searchLocation(locationName: "\(completionResult.title) \(completionResult.subtitle)")
                                myHappeningLocationMapViewModel.whenClickOnLocationItem()
                            } label: {
                                VStack(alignment: .leading) {
                                    Text(completionResult.title)
                                        .foregroundColor(.white)
                                    
                                    Text(completionResult.subtitle)
                                        .font(.footnote)
                                        .multilineTextAlignment(.leading)
                                        .foregroundColor(.secondary)
                                }
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity)
                        .frame(height: 70)
                        .background(.ultraThinMaterial)
                        .cornerRadius(10)
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.top, 20)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black.opacity(0.8))
        .background(.ultraThinMaterial)
        .cornerRadius(10)
        .padding(.top, 10)
        .edgesIgnoringSafeArea(.bottom)
        .preferredColorScheme(.dark)
    }
}
