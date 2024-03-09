//
//  SearchBarWithButtonsSection.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-01-05.
//

import SwiftUI

struct SearchBarWithButtonsSection: View {
    
    // MARK: PROPERTIES
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var color: ColorTheme
    
    // MARK: BODY
    var body: some View {
        Section {
            VStack(spacing: 0) {
                HStack{
                    Image(systemName: "square.and.pencil")
                        .font(Font.body.weight(.medium))
                        .foregroundColor(color.accentColor)
                    
                    Spacer()
                    
                    Text("Filter")
                        .foregroundColor(color.accentColor)
                }
                
                HStack {
                    Text("Following")
                        .font(.title.weight(.bold))
                        .padding(.top, 12)
                    
                    Spacer()
                }
                
                HStack {
                    HStack {
                        HStack(spacing: 0) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(Color(UIColor.systemGray3))
                                .padding(.leading, 7)
                            
                            Text("Searched Text")
                                .overlay(alignment: .trailing) {
                                    Image(systemName: "line.diagonal")
                                        .rotationEffect(.degrees(90+45))
                                        .font(.system(size: 20))
                                        .foregroundColor(color.accentColor)
                                        .offset(x: 10, y: 0)
                                }
                                .padding(.trailing,32)
                                .padding(.leading, 5)
                            
                            Spacer()
                            
                            Image(systemName: "x.circle.fill")
                                .foregroundColor(Color(UIColor.systemGray2))
                        }
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 5)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    
                    Text("Cancel")
                        .foregroundColor(color.accentColor)
                        .padding(.leading)
                }
                .padding(.top, 8)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .padding(.horizontal, 10)
            .background(colorScheme == .light ? Color.white : Color.black)
            .previewLayout(.sizeThatFits)
        } header: {
            Text("Sample Search Bar")
                .font(.footnote)
        }
    }
}

// MARK: PREVIEWS
struct SearchBarWithButtonsSection_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                List {
                    SearchBarWithButtonsSection()
                        .preferredColorScheme(.dark)
                }
            }
            
            NavigationView {
                List {
                    SearchBarWithButtonsSection()
                }
            }
        }
        .listStyle(.grouped)
        .environmentObject(ColorTheme())
    }
}
