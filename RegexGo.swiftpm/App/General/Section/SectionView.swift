//
//  SectionView.swift
//  
//
//  Created by Chu Yong on 4/9/23.
//

import SwiftUI

/// A view useful for outer border and HUD (heads-up display) title
///
/// You need to add ScrollView by your self
struct SectionView<Content: View>: View {
    
    private var title = ""
    private let showingBorder = false
    private let content: Content
    private let needPadding: Bool
    private let borderType: BorderType
    private let isTitlePositionTop: Bool
    private let isTitleShowAlways: Bool
    
    @State private var dragOffset = CGSize.zero
    @State private var slideDirection: SlideDirection = .up
    @State private var showTitle = false {
        willSet {
            if showTitle == true {
                dragOffset = .zero
            }
        }
    }
    
    var body: some View {
        ZStack(alignment: isTitlePositionTop ? .top : .bottom) {
            self.content
//                .padding(.top, 52)
                .padding(needPadding ? .all : [])
                .border(showingBorder ? .blue : .clear)
                .overlay(
                    RoundedRectangle(cornerRadius: borderType.cornerRadius)
                        .stroke(.quaternary, lineWidth: borderType.lineWidth)
                )
                .mask(RoundedRectangle(cornerRadius: borderType.cornerRadius))
            
            if showTitle && title != "" {
                Text("\(title)")
                    .font(.body.monospaced())
                    .padding()
                    .background(Material.ultraThin)
                    .frame(height: 32)
                    .cornerRadius(32)
                    .shadow(color: .black.opacity(0.1), radius: 12, x: 0, y: 0)
//                    .opacity(title == "" ? 0 : 1)
                    .padding(isTitlePositionTop ? .top : .bottom, 16)
                    .offset(dragOffset)
                    .gesture(
                        DragGesture()
                            .onChanged({ gesture in
                                if isTitlePositionTop ? gesture.translation.height > 0 : gesture.translation.height < 0 {
                                    dragOffset.height = 0
                                } else if isTitlePositionTop ? gesture.translation.height > 30 : gesture.translation.height < 30 {
                                    dragOffset.height = gesture.translation.height
                                } else {
                                    dragOffset.height = 30
                                }
                            })
                            .onEnded({ gesture in
                                withAnimation {
                                    showTitle.toggle()
                                }
                            })
                    )
                    .transition(slideDirection == .up ? .push(from: .bottom) : .push(from: .top))
                    .zIndex(1)
            }
        }
        .onChange(of: showTitle, perform: { _ in
            self.slideDirection.toggle()
        })
        .onAppear {
            self.showTitleAndHide(from: 0.3, to: 3)
        }
    }
    
    func showTitleAndHide(from start: Double = 0, to end: Double = 5) {
        slideDirection = isTitlePositionTop ? .down : .up
        DispatchQueue.main.asyncAfter(deadline: .now() + start) {
            withAnimation(.spring()) {
                showTitle = true
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + end) {
            withAnimation(.spring()) {
                showTitle = isTitleShowAlways ? true : false
            }
        }
    }
}

extension SectionView {

    /// Beautiful section contains content
    /// - Parameters:
    ///   - title: HUD Title
    ///   - needPadding: padding from four side
    ///   - borderType: ``.outer`` means thick border
    ///   - isTitlePositionTop: `true` means that title will show up in the top
    ///   - isTitleShowAlways: `true` means that title will not disappear
    ///   - content: What's inside section
    init(title: String = "", needPadding: Bool = true, borderType: BorderType = .outer,
         isTitlePositionTop: Bool = true,
         isTitleShowAlways: Bool = false,
         // TODO: Head Contents
         @ViewBuilder content: () -> Content) {
        self.content = content()
        self.title = title
        self.needPadding = needPadding
        self.borderType = borderType
        self.isTitlePositionTop = isTitlePositionTop
        self.isTitleShowAlways = false
    }
    
    enum BorderType: CGFloat {
        case outer = 8, inside = 2, none = 0
        
        var lineWidth: CGFloat {
            return self.rawValue
        }
        var cornerRadius: CGFloat {
            switch self {
            case .outer:
                return 16
            case .inside:
                return 5
            case .none:
                return 0
            }
        }
    }
    
    enum SlideDirection {
        case up
        case down
        
        mutating func toggle() {
            self = self == .up ? .down : .up
        }
    }
}

struct SectionView_Previews: PreviewProvider {
    static var previews: some View {
        SectionView(title: "Hello") {
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
