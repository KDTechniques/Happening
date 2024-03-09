//
//  HappeningCharactersView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-02-16.
//

import SwiftUI

struct HappeningCharactersView: View {
    
    @Binding var opacityCharacter1: CGFloat
    @Binding var opacityCharacter2: CGFloat
    @Binding var opacityCharacter3: CGFloat
    @Binding var opacityCharacter4: CGFloat
    @Binding var opacityCharacter5: CGFloat
    @Binding var opacityCharacter6: CGFloat
    @Binding var opacityCharacter7: CGFloat
    @Binding var opacityCharacter8: CGFloat
    @Binding var opacityCharacter9: CGFloat
    
    var body: some View {
        HStack(spacing: 3.0) {
            Text("H").opacity(opacityCharacter1)
            Text("A").opacity(opacityCharacter2)
            Text("P").opacity(opacityCharacter3)
            Text("P").opacity(opacityCharacter4)
            Text("E").opacity(opacityCharacter5)
            Text("N").opacity(opacityCharacter6)
            Text("I").opacity(opacityCharacter7)
            Text("N").opacity(opacityCharacter8)
            Text("G").opacity(opacityCharacter9)
        }
        .font(.title.weight(.heavy))
        .foregroundColor(Color.primary)
        .dynamicTypeSize(.xxxLarge)
    }
}

struct HappeningCharactersView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HappeningCharactersView(opacityCharacter1: Binding.constant(1), opacityCharacter2: Binding.constant(1), opacityCharacter3: Binding.constant(1), opacityCharacter4: Binding.constant(1), opacityCharacter5: Binding.constant(1), opacityCharacter6: Binding.constant(1), opacityCharacter7: Binding.constant(1), opacityCharacter8: Binding.constant(1), opacityCharacter9: Binding.constant(1))
            
            HappeningCharactersView(opacityCharacter1: Binding.constant(1), opacityCharacter2: Binding.constant(1), opacityCharacter3: Binding.constant(1), opacityCharacter4: Binding.constant(1), opacityCharacter5: Binding.constant(1), opacityCharacter6: Binding.constant(1), opacityCharacter7: Binding.constant(1), opacityCharacter8: Binding.constant(1), opacityCharacter9: Binding.constant(1)).preferredColorScheme(.dark)
        }
    }
}
