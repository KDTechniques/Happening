//
//  MessageBarSection.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-01-05.
//

import SwiftUI

struct MessageBarSection: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var color: ColorTheme
    
    // MARK: BODY
    var body: some View {
        Section {
            HStack(spacing: 0) {
                Text("Selected Text")
                    .overlay(alignment: .leading, content: {
                        Rectangle()
                            .fill(color.accentColor.opacity(0.2))
                            .overlay(alignment: .leading) {
                                Text("I")
                                    .font(.system(size: 28).weight(.light))
                                    .foregroundColor(color.accentColor)
                                    .offset(x: -2, y: 0)
                            }
                            .overlay(alignment: .trailing) {
                                Text("I")
                                    .font(.system(size: 28).weight(.light))
                                    .foregroundColor(color.accentColor)
                                    .offset(x: 2, y: 0)
                            }
                        
                    })
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.vertical, 6)
                    .background(Color("MessageTextFieldColor"))
                    .cornerRadius(.infinity)
                    .overlay(
                        RoundedRectangle(cornerRadius: .infinity)
                            .stroke(Color.primary.opacity(0.3), lineWidth: 0.2)
                            .overlay(alignment: .topLeading) {
                                Circle()
                                    .fill(color.accentColor)
                                    .frame(width: 10)
                                    .offset(x: 11.8, y: -13)
                            }
                            .overlay(alignment: .topLeading) {
                                Circle()
                                    .fill(color.accentColor)
                                    .frame(width: 10)
                                    .offset(x: 113.2, y: 13)
                            }
                    )
                    .padding(.horizontal)
                
                Image(systemName: "paperplane.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 32)
                    .rotationEffect(.degrees(45))
                    .foregroundColor(color.accentColor)
                    .padding(.trailing)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 7)
            .background(Color("NavBarTabBarColor"))
            .previewLayout(.sizeThatFits)
        } header: {
            Text("Sample Message Bar")
                .font(.footnote)
        }
    }
}

// MARK: PREVIEWS
struct MessageBarSection_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                List {
                    MessageBarSection()
                        .preferredColorScheme(.dark)
                }
            }
            
            NavigationView {
                List {
                    MessageBarSection()
                }
            }
        }
        .listStyle(.grouped)
        .environmentObject(ColorTheme())
    }
}
