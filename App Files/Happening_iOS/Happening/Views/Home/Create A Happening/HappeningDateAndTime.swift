//
//  HappeningDateAndTime.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-03-08.
//

import SwiftUI

struct HappeningDateAndTime: View {
    
    @EnvironmentObject var createAHappeningVM: CreateAHappeningViewModel
    
    var body: some View {
        let endingEndingDate: Date = Calendar.current.date(byAdding: .weekOfMonth, value: 1, to: createAHappeningVM.startingDateTimeSelection) ?? Date()
        Section {
            
            DatePicker("Starting", selection: $createAHappeningVM.startingDateTimeSelection, in: createAHappeningVM.startingDate...createAHappeningVM.startingEndingDate)
                .onChange(of: createAHappeningVM.startingDateTimeSelection) { _ in
                    createAHappeningVM.createAHappeningValidation()
                }
                .datePickerStyle(.compact)
            
            DatePicker("Ending", selection: $createAHappeningVM.endingDateTimeSelection, in: createAHappeningVM.startingDateTimeSelection...endingEndingDate)
                .onChange(of: createAHappeningVM.endingDateTimeSelection) { _ in
                    createAHappeningVM.createAHappeningValidation()
                }
                .datePickerStyle(.compact)
        } header: {
            Text("Date & Time")
                .font(.footnote)
        } footer: {
            VStack(alignment: .leading, spacing: 5) {
                Text("*the starting date must be at least 02 hours from now.")
                
                Text("*the ending date must be at least 15 minutes from the starting date.")
            }
            .font(.footnote)
        }
    }
}

struct HappeningDateAndTime_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            List {
                HappeningDateAndTime()
            }
            
            List {
                HappeningDateAndTime()
            }
            .preferredColorScheme(.dark)
        }
        .listStyle(.grouped)
        .environmentObject(CreateAHappeningViewModel())
    }
}
