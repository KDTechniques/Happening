//
//  DatePickerView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-12-24.
//

import SwiftUI

struct DatePickerView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var approvalFormViewModel: ApprovalFormViewModel
    
    // MARK: BODY
    var body: some View {
        ZStack{
            VStack(spacing: 0){
                Spacer()
                Divider()
                DatePicker("Date of Birth", selection: $approvalFormViewModel.formData.dateOfBirth, in: approvalFormViewModel.startingDate...approvalFormViewModel.endingDate, displayedComponents: [.date])
                    .labelsHidden()
                    .frame(maxWidth: .infinity)
                    .datePickerStyle(.wheel)
                    .background(.ultraThinMaterial)
                    .overlay(alignment: .topTrailing, content: {
                        Button {
                            withAnimation(.easeInOut(duration: 0.45)){
                                approvalFormViewModel.isPresentedDatePicker = false
                            }
                        } label: {
                            Image(systemName: "arrowtriangle.down.circle")
                                .font(.title)
                                .foregroundColor(Color.primary)
                                .padding()
                                .padding(.trailing, 8)
                        }
                    })
                    .onChange(of: approvalFormViewModel.formData.dateOfBirth) { _ in
                        approvalFormViewModel.DateOfBirthValidation()
                    }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .transition(.move(edge: .bottom))
    }
}

// MARK: PREVIEW
struct DatePickerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DatePickerView().preferredColorScheme(.dark)
            DatePickerView()
        }
        .environmentObject(ApprovalFormViewModel())
    }
}
