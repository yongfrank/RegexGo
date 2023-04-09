//
//  SectionView.swift
//  
//
//  Created by Chu Yong on 4/9/23.
//

import SwiftUI

struct SectionView<Content: View>: View {
    
    private var title = ""
    
    let content: Content

    var body: some View {
        ZStack(alignment: .top) {
            self.content
                .padding()
                .border(showingBorder ? .blue : .clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.quaternary, lineWidth: 8)
                )
                .mask(RoundedRectangle(cornerRadius: 16))
            
            Text("\(title)")
                .font(.body.monospaced())
                .padding()
                .background(Material.thin)
                .frame(height: 32)
                .cornerRadius(32)
                .shadow(color: .black.opacity(0.1), radius: 12, x: 0, y: 0)
                .opacity(title == "" ? 0 : 1)
                .padding(.top, 32)
        }
    }
    
    private let showingBorder = false
    
    init(title: String = "", @ViewBuilder content: () -> Content) {
        self.content = content()
        self.title = title
    }
}

struct SectionView_Previews: PreviewProvider {
    static var previews: some View {
//        SectionView {
//            VStack {
//                Text("hi")
//                Text(":")
//            }
//        }
        SectionView {
            VStack {
                Text("hihihihihihihihihihihi")
                Text("hihihihihihihihihihihi")
                Text("hihihihihihihihihihihi")
                Text("hihihihihihihihihihihi")
                Text("hihihihihihihihihihihi")
                Text(":")
            }
        }
    }
}
