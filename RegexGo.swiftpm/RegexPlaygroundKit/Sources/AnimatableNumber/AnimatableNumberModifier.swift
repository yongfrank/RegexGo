//
//  AnimatableNumberModifier.swift
//  
//  https://stefanblos.com/posts/animating-number-changes/
//  Created by Chu Yong on 4/20/23.
//

import SwiftUI

struct AnimatableNumberModifier: AnimatableModifier {
    var number: Double
    
    var animatableData: Double {
        get { number }
        set { number = newValue }
    }
    
    func body(content: Content) -> some View {
        content
            .overlay(
                Text("\(Int(number))")
            )
    }
}


extension View {
    func animatingOverlay(for number: Double) -> some View {
        modifier(AnimatableNumberModifier(number: number))
    }
}

struct AnimatingNumberView: View {

    // Change 1: number is now a Double
    @State private var number: Double = 0

    var body: some View {
        VStack(spacing: 20) {
            // Change 2: we have a container with our modifier applied
            Color.clear
                .frame(width: 50, height: 50)
                .animatingOverlay(for: number)

            Button {
                withAnimation {
                    number = .random(in: 0 ..< 200)
                }
            } label: {
                Text("Create random number")
            }
        }
    }
}

struct AnimatingNumberView_Previews: PreviewProvider {
    static var previews: some View {
        AnimatingNumberView()
    }
}
