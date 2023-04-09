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
    let needPadding: Bool
    let sectionType: BorderType

    var body: some View {
        ZStack(alignment: .bottom) {
            self.content
//                .padding(.top, 52)
                .padding(needPadding ? .all : [])
                .border(showingBorder ? .blue : .clear)
                .overlay(
                    RoundedRectangle(cornerRadius: sectionType.cornerRadius)
                        .stroke(.quaternary, lineWidth: sectionType.lineWidth)
                )
                .mask(RoundedRectangle(cornerRadius: sectionType.cornerRadius))
            
            Text("\(title)")
                .font(.body.monospaced())
                .padding()
                .background(Material.ultraThin)
                .frame(height: 32)
                .cornerRadius(32)
                .shadow(color: .black.opacity(0.1), radius: 12, x: 0, y: 0)
                .opacity(title == "" ? 0 : 1)
                .padding(.bottom, 16)
        }
    }
    
    private let showingBorder = false
    
    init(title: String = "", needPadding: Bool = true, sectionType: BorderType = .outer, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.title = title
        self.needPadding = needPadding
        self.sectionType = sectionType
    }
}

enum BorderType: CGFloat {
    case outer = 8, inside = 2
    
    var lineWidth: CGFloat {
        return self.rawValue
    }
    var cornerRadius: CGFloat {
        switch self {
        case .outer:
            return 16
        case .inside:
            return 5
        }
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
