//
//  HappeningFilterOptionsView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-03-27.
//

import SwiftUI

struct HappeningFilterOptionsView: View {
    
    // MARK: PROPERTIES
    
    @EnvironmentObject var color: ColorTheme
    @EnvironmentObject var happeningsVM: HappeningsViewModel
    @EnvironmentObject var networkManager: NetworkManger
    
    // MARK: BODY
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    happeningsVM.isPresentedFilterOptionsSheet = false
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                        .foregroundColor(Color(UIColor.systemGray2))
                }
                
                Spacer()
                
                Text("Filter")
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button("Reset") {
                    happeningsVM.resetFilterOptionsSheet()
                }
                .tint(color.accentColor)
            }
            .padding(.horizontal)
            
            Divider()
                .padding(.top)
            
            ScrollView {
                // SORT
                VStack {
                    Text("Sort")
                        .font(.subheadline.weight(.medium))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack(spacing: 10) {
                        CustomFilterButtonView(text: "Happening Sooner", accentColor: happeningsVM.isSelectedHappeningSoonerButton) {
                            happeningsVM.isSelectedHappeningSoonerButton.toggle()
                        }
                        
                        CustomFilterButtonView(text: "Happening Later", accentColor: happeningsVM.isSelectedHappeningLaterButton) {
                            happeningsVM.isSelectedHappeningLaterButton.toggle()
                        }
                        
                        Spacer()
                    }
                    
                    Divider()
                        .padding(.top, 10)
                }
                .padding(.top)
                
                // SPACE FEE
                VStack {
                    Text("Space Fee")
                        .font(.subheadline.weight(.medium))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack(spacing: 10) {
                        CustomFilterButtonView(text: "Free", accentColor: happeningsVM.isSelectedFreeButton) {
                            happeningsVM.isSelectedFreeButton.toggle()
                        }
                        
                        CustomFilterButtonView(text: "Paid", accentColor: happeningsVM.isSelectedPaidButton) {
                            happeningsVM.isSelectedPaidButton.toggle()
                        }
                        
                        Spacer()
                    }
                    
                    Divider()
                        .padding(.top, 10)
                }
                .padding(.top)
                
                // SPACE FEE RANGE
                VStack {
                    Text("Space Fee Range")
                        .font(.subheadline.weight(.medium))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack(spacing: 10) {
                        HStack {
                            CustomFilterTextFieldView(placeholderText: "min", text: $happeningsVM.minSpaceFeeTextFieldText)
                            
                            Text(Locale.current.currencyCode ?? "")
                                .font(.footnote)
                        }
                        
                        Text("-")
                        
                        HStack {
                            CustomFilterTextFieldView(placeholderText: "max", text: $happeningsVM.maxSpaceFeeTextFieldText)
                            
                            Text(Locale.current.currencyCode ?? "")
                                .font(.footnote)
                        }
                        
                        Spacer()
                    }
                    .keyboardType(.numberPad)
                    
                    Divider()
                        .padding(.top, 10)
                }
                .padding(.top)
                
                // CITY / PROVINCE
                VStack {
                    Text("City / Province")
                        .font(.subheadline.weight(.medium))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack(spacing: 10) {
                        CustomFilterTextFieldView(placeholderText: "ex: Colombo", text: $happeningsVM.cityOrProvinceTextFieldText)
                        
                        Text("or")
                        
                        CustomFilterButtonView(text: "Near Me", accentColor: happeningsVM.isSelectedNearMeButton) {
                            happeningsVM.isSelectedNearMeButton.toggle()
                        }
                        
                        Spacer()
                    }
                    
                    Divider()
                        .padding(.top, 10)
                }
                .padding(.top)
                
                // RATING
                VStack {
                    Text("Rating")
                        .font(.subheadline.weight(.medium))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 10) {
                            CustomFilterRatingButtonView(number: 5, accentColor: happeningsVM.isSelected5StarsButton) {
                                happeningsVM.isSelected5StarsButton.toggle()
                            }
                            
                            CustomFilterRatingButtonView(number: 4, accentColor: happeningsVM.isSelected4StarsNupButton) {
                                happeningsVM.isSelected4StarsNupButton.toggle()
                            }
                            
                            CustomFilterRatingButtonView(number: 3, accentColor: happeningsVM.isSelected3StarsNupButton) {
                                happeningsVM.isSelected3StarsNupButton.toggle()
                            }
                            
                            CustomFilterRatingButtonView(number: 2, accentColor: happeningsVM.isSelected2StarsNupButton) {
                                happeningsVM.isSelected2StarsNupButton.toggle()
                            }
                            
                            CustomFilterRatingButtonView(number: 1, accentColor: happeningsVM.isSelected1StarNupButton) {
                                happeningsVM.isSelected1StarNupButton.toggle()
                            }
                        }
                        
                        Spacer()
                    }
                }
                .padding(.vertical)
            }
            .onTapGesture {
                hideKeyboard()
            }
            .padding(.horizontal)
            
            Divider()
            
            ButtonView(name: "Show Results") {
                
                if networkManager.connectionStatus == .noConnection {
                    happeningsVM.alertItemForHappeningFilterOptionsView = AlertItemModel(
                        title: "Couldn't Search Results",
                        message: "Please check your phone's connection and try again."
                    )
                } else {
                    happeningsVM.isPresentedProgressView = true
                    happeningsVM.isPresentedFilterOptionsSheet = false
                    
                    happeningsVM.getCustomHappenings {
                        happeningsVM.isPresentedProgressView = false
                        if !$0 { // false status
                            happeningsVM.isPresentedErrorText = true
                        } else {
                            if happeningsVM.happeningsDataArray.isEmpty {
                                happeningsVM.isPresentedErrorText = true
                            } 
                        }
                    }
                }
            }
            .padding(.vertical)
        }
        .padding(.top)
        .alert(item: $happeningsVM.alertItemForHappeningFilterOptionsView) { alert -> Alert in
            Alert(title: Text(alert.title), message: Text(alert.message), dismissButton: alert.dismissButton)
        }
    }
}

// MARK: PREVIEWS
struct HappeningFilterOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HappeningFilterOptionsView()
                .preferredColorScheme(.dark)
            
            HappeningFilterOptionsView()
        }
        .environmentObject(ColorTheme())
        .environmentObject(HappeningsViewModel())
        .environmentObject(NetworkManger())
    }
}

// MARK: CUSTOM VIEWS



// MARK: CustomFilterButtonView
struct CustomFilterButtonView : View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var color: ColorTheme
    
    let text: String
    let accentColor: Bool
    let action: () -> ()
    
    var body: some View {
        
        Button {
            action()
        } label: {
            Text(text)
                .foregroundColor(.primary)
                .font(.footnote)
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .background(accentColor ? color.accentColor  : (colorScheme == .light ? Color(UIColor.systemGray6) : Color(UIColor.systemGray5)))
                .cornerRadius(10)
        }
    }
}

// MARK: CustomFilterTextFieldView
struct CustomFilterTextFieldView : View {
    
    @Environment(\.colorScheme) var colorScheme
    
    let placeholderText: String
    @Binding var text: String
    
    var body: some View {
        
        TextField(placeholderText, text: $text)
            .foregroundColor(.primary)
            .font(.footnote)
            .padding(9.5)
            .background(colorScheme == .light ? Color(UIColor.systemGray6) : Color(UIColor.systemGray5))
            .cornerRadius(5)
            .frame(width: 100)
    }
}

// MARK: CustomFilterRatingButtonView
struct CustomFilterRatingButtonView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var color: ColorTheme
    
    let number: Int
    let accentColor: Bool
    let action: () -> ()
    
    var body: some View {
        
        Button {
            action()
        } label: {
            HStack {
                ForEach(1...5, id: \.self) { index in
                    Image(systemName: "star.fill")
                        .foregroundColor(index <= number ? .yellow : Color(UIColor.systemGray3))
                }
                
                if number != 5 {
                    Text("& up")
                        .foregroundColor(.secondary)
                }
            }
            .font(.footnote)
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .background(accentColor ? color.accentColor  : (colorScheme == .light ? Color(UIColor.systemGray6) : Color(UIColor.systemGray5)))
            .cornerRadius(10)
        }
    }
}
