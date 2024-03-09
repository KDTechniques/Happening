//
//  SearchBarView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-03-25.
//

import SwiftUI

struct SearchBarView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var color: ColorTheme
    
    @Binding var searchText: String
    @Binding var isSearching: Bool
    
    @FocusState private var focusedField: FocusField?
    
    @State private var textFieldPadding: CGFloat = 0
    @State private var cancelOffsetX: CGFloat = 70
    @State private var hideXmark: Bool = true
    
    enum FocusField: Hashable {
        case field
    }
    
    enum TransitionDirectionType {
        case toRight
        case toLeft
    }
    
    // MARK: BODY
    var body: some View {
        VStack(spacing: 0) {
            TextField("Search", text: $searchText)
                .onChange(of: searchText, perform: { _ in
                    if searchText.isEmpty {
                        withAnimation(.linear(duration: 0.1)) {
                            hideXmark = true
                        }
                    } else {
                        withAnimation(.linear(duration: 0.1)) {
                            hideXmark = false
                        }
                    }
                })
                .onChange(of: focusedField, perform: { value in
                    if value == .field {
                        transition(direction: .toLeft)
                    } else {
                        transition(direction: .toRight)
                    }
                })
                .focused($focusedField, equals: .field)
                .submitLabel(.return)
                .onSubmit { transition(direction: .toRight) }
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 36)
                .padding(.leading, 32)
                .padding(.trailing, 35)
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(10)
                .onTapGesture { focusedField = .field }
                .overlay(alignment: .trailing, content: {
                    Button {
                        searchText.removeAll()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(Color(UIColor.systemGray2))
                            .padding(.trailing, 7)
                            .opacity(hideXmark ? 0 : 1)
                            .disabled(hideXmark ? true : false)
                    }
                })
                .padding(.trailing, textFieldPadding) // 0 <-> 65
                .overlay(alignment: .leading) {
                    Image(systemName: "magnifyingglass")
                        .padding(.leading, 6)
                        .foregroundColor(Color(UIColor.systemGray2))
                }
                .overlay(alignment: .trailing) {
                    Button(action: {
                        searchText.removeAll()
                        transition(direction: .toRight)
                    }, label: {
                        Text("Cancel")
                            .foregroundColor(color.accentColor)
                    })
                        .offset(x: cancelOffsetX) // x: 0 <-> 70
                }
                .padding(.horizontal)
            
            Divider()
                .padding(.top)
        }
    }
    
    // MARK: FUNCTIONS
    
    // MARK: transition
    func transition(direction: TransitionDirectionType) {
        if direction == .toRight {
            focusedField = .none
            withAnimation(.spring()) {
                cancelOffsetX = 70
                textFieldPadding = 0
            }
            isSearching = false
        } else {
            withAnimation(.spring()) {
                textFieldPadding = 65
                cancelOffsetX = 0
            }
            isSearching = true
        }
    }
}

// MARK: PREVIEWS
//struct SearchBarView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            SearchBarView(searchText: .constant(""), isSearching: .constant(false))
//                .preferredColorScheme(.dark)
//
//            SearchBarView(searchText: .constant("check 123"), isSearching: .constant(true))
//        }
//        .environmentObject(ColorTheme())
//    }
//}
