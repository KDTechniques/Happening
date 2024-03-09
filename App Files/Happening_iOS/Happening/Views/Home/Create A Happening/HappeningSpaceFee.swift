//
//  HappeningSpaceFee.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-03-07.
//

import SwiftUI

struct HappeningSpaceFee: View {
    
    @EnvironmentObject var createAHappeningVM: CreateAHappeningViewModel
    
    var body: some View {
        Section {
            TextField(createAHappeningVM.selectedSpaceFeeType == .Free ? "0 \(createAHappeningVM.currency)" : "Fee", text: $createAHappeningVM.spaceFeeTextFieldtext)
                .onChange(of: createAHappeningVM.spaceFeeTextFieldtext){ _ in
                    createAHappeningVM.createAHappeningValidation()
                }
                .disabled(createAHappeningVM.selectedSpaceFeeType == .Free ? true : false)
                .keyboardType(.asciiCapableNumberPad)
                .overlay(alignment: .trailing) {
                    Picker("", selection: $createAHappeningVM.selectedSpaceFeeType) {
                        Text(SpaceFeeType.Free.rawValue)
                            .tag(SpaceFeeType.Free)
                        
                        Text(SpaceFeeType.Paid.rawValue)
                            .tag(SpaceFeeType.Paid)
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 150)
                    .onChange(of: createAHappeningVM.selectedSpaceFeeType) { _ in
                        createAHappeningVM.spaceFeeTextFieldtext = ""
                        createAHappeningVM.createAHappeningValidation()
                    }
                }
        } header: {
            Text("Space Fee (\(createAHappeningVM.currency))")
        } footer: {
            VStack(alignment: .leading, spacing: 10) {
                Text("*required (It means how much you're willing to charge from one follower.)")
                
                if(createAHappeningVM.spaceFeeTextFieldtext.isEmpty) {
                    Text("Tips:")
                        .font(.subheadline)
                    
                    Text("Provide good value to your followers.")
                        .fontWeight(.semibold)
                } else {
                    Text("You will earn \(Text("\(String(format: "%.2f", (createAHappeningVM.spaceFeeTextFieldtext as NSString).doubleValue * 65/100)) \(createAHappeningVM.currency) per space.").foregroundColor(.green))")
                        .fontWeight(.semibold)
                    
                    if(createAHappeningVM.noOfSpaces > 1) {
                        Text("You will earn \(Int((createAHappeningVM.spaceFeeTextFieldtext as NSString).doubleValue) * 65/100 * createAHappeningVM.noOfSpaces) \(createAHappeningVM.currency) for \(createAHappeningVM.noOfSpaces) spaces.")
                            .fontWeight(.semibold)
                    }
                    
                    Text("One follower must pay \(createAHappeningVM.spaceFeeTextFieldtext) \(createAHappeningVM.currency).")
                        .fontWeight(.semibold)
                    
                    Text("Payment Processing and Service Fees will charge \(String(format: "%.2f", (createAHappeningVM.spaceFeeTextFieldtext as NSString).doubleValue * 35/100)) \(createAHappeningVM.currency) per space.")
                        .fontWeight(.semibold)
                }
            }
            .font(.footnote)
        }
    }
}

struct HappeningSpaceFee_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            List {
                HappeningSpaceFee()
            }
            
            List {
                HappeningSpaceFee()
            }
            .preferredColorScheme(.dark)
        }
        .listStyle(.grouped)
        .environmentObject(CreateAHappeningViewModel())
    }
}
