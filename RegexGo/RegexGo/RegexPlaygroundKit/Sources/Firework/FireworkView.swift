//
//  FireworkView.swift
//  
//
//  Created by Chu Yong on 4/19/23.
//

import SwiftUI
import ConfettiSwiftUI

struct FireworkView: View {
    var showFirework: Bool
    var isConfettiSwiftUILibrary: Bool
    @Binding var confettiCounter: Int
    var body: some View {
        if showFirework {
            if isConfettiSwiftUILibrary {
                confettiLibrary
            } else {
                ZStack {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 12, height: 12)
                        .modifier(ParticlesModifier())
                        .offset(x: -100, y : -50)
                    
                    Circle()
                        .fill(Color.red)
                        .frame(width: 12, height: 12)
                        .modifier(ParticlesModifier())
                        .offset(x: 60, y : 70)
                }
            }
        }
    }
    
    private var confettiLibrary: some View {
        ZStack {
            
        }
        .confettiCannon(counter: $confettiCounter, num: 100)
    }
}

struct ParticlesModifier: ViewModifier {
    @State var time = 0.0
    @State var scale = 0.1
    let duration = 5.0
    
    func body(content: Content) -> some View {
        ZStack {
            ForEach(0..<80, id: \.self) { index in
                content
                    .hueRotation(Angle(degrees: time * 80))
                    .scaleEffect(scale)
                    .modifier(FireworkParticlesGeometryEffect(time: time))
                    .opacity(((duration-time) / duration))
            }
        }
        .onAppear {
            withAnimation (.easeOut(duration: duration)) {
                self.time = duration
                self.scale = 1.0
            }
        }
    }
}


struct FireworkParticlesGeometryEffect : GeometryEffect {
    var time : Double
    var speed = Double.random(in: 20 ... 200)
    var direction = Double.random(in: -Double.pi ...  Double.pi)
    
    var animatableData: Double {
        get { time }
        set { time = newValue }
    }
    func effectValue(size: CGSize) -> ProjectionTransform {
        let xTranslation = speed * cos(direction) * time
        let yTranslation = speed * sin(direction) * time
        let affineTranslation =  CGAffineTransform(translationX: xTranslation, y: yTranslation)
        return ProjectionTransform(affineTranslation)
    }
}

struct FireworkView_Previews: PreviewProvider {
    struct FireworkPreview: View {
        @State private var counter = 1
        var body: some View {
            ZStack {
                Button("Button") {
                    counter += 1
                }
                FireworkView(showFirework: true, isConfettiSwiftUILibrary: true, confettiCounter: $counter)
            }
        }
    }
    static var previews: some View {
        FireworkPreview()
    }
}
