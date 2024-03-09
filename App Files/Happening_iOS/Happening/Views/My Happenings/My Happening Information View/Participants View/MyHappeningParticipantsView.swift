//
//  MyHappeningParticipantsView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-06-01.
//

import SwiftUI

struct MyHappeningParticipantsView: View {
    
    // MARK: PROPERTIES
    let participantsProfileDataArray: [ParticipantBasicProfileDataModel]
    let numberOfSpaces: Int
    
    let screeWidth: CGFloat = UIScreen.main.bounds.size.width
    
    // MARK: BODY
    var body: some View {
        Section {
            ScrollView(.horizontal, showsIndicators: true) {
                HStack {
                    ForEach(0...participantsProfileDataArray.count-1, id: \.self) { index in
                        ParticipantItemView(
                            profilePhotoThumnailURL: participantsProfileDataArray[index].profilePhotoThumnailURL,
                            userName: participantsProfileDataArray[index].userName,
                            profession: participantsProfileDataArray[index].profession,
                            ratings: participantsProfileDataArray[index].ratings
                        )
                    }
                }
                .padding(.bottom, 10)
                .padding(.horizontal)
            }
            .listRowInsets(EdgeInsets())
        } header: {
            Text("Participants (\(participantsProfileDataArray.count))")
                .font(.footnote)
        } footer: {
            Text("available spaces: \(numberOfSpaces-participantsProfileDataArray.count) out of \(numberOfSpaces)")
                .font(.footnote)
        }
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
}
