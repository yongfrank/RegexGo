//
//  WidthThresholdReader.swift
//
//
//  Created by Chu Yong on 4/15/23.
//

/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
Reports whether the view is horizontally compact.
*/

import SwiftUI

/// Wrapper For ``WidthThresholdReader``
struct SideBySideStack<Content: View>: View {
    var content: Content
//    var verticalContent: Content
    
    var body: some View {
        WidthThresholdReader(widthThreshold: 520) { proxy in
            Grid(horizontalSpacing: 12, verticalSpacing: 12) {
                if proxy.isCompact {
                    content
                } else {
                    GridRow {
                        content
                    }
                }
            }
            .containerShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .frame(maxWidth: 1200)
        }
    }
    init(@ViewBuilder content: () -> Content
//         ,@ViewBuilder verticalContent: () -> Content
    ) {
        self.content = content()
//        self.verticalContent = verticalContent()
    }
}

/**
 A view useful for determining if a child view should act like it is horizontally compressed.
 
 Several elements are used to decide if a view is compressed:
 - Width
 - Dynamic Type size
 - Horizontal size class & VerticalSizeClass(for Landscape or Portrait detection) (on iOS)
 */
struct WidthThresholdReader<Content: View>: View {
    var widthThreshold: Double = 400
    var dynamicTypeThreshold: DynamicTypeSize = .xxLarge
    var isGeometryReader: Bool = true
    
    @ViewBuilder var content: (WidthThresholdProxy) -> Content
    
    #if os(iOS)
    @Environment (\.verticalSizeClass) private var verticalSizeClass
    @Environment(\.horizontalSizeClass) private var sizeClass
    #endif
    @Environment(\.dynamicTypeSize) private var dynamicType
    
    var body: some View {
        if isGeometryReader {
            GeometryReader { geometryProxy in
                let compressionProxy = WidthThresholdProxy(
                    width: geometryProxy.size.width,
                    isCompact: isCompact(width: geometryProxy.size.width)
                )
                content(compressionProxy)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        } else {
            GeometryReader { geometryProxy in
                let compressionProxy = WidthThresholdProxy(
                    width: geometryProxy.size.width,
                    isCompact: isCompact(width: geometryProxy.size.width)
                )
                content(compressionProxy)
                    .frame(width: 200)
            }
        }
    }
    
    /**
     [Cross platform with SwiftUI](https://yongfrank.github.io/posts/swiftui/#cross-platform-swiftui)
    
     | Device                  | Landscape/Portrait | horizontalSizeClass | verticalSizeClass |
     | -------------------- | ---------------------- | ---------------------- | -------------------- |
     | All iPhone             |  Portrait                   | compact                  | regular                  |
     | iPhone (except Max、Plus) | Landscape    | compact             | compact               |
     | iPhone (Max、Plus)             | Landscape    | regular                | compact               |
     | All iPad                  | Landscape & Portrait  | regular                | regular                   |
     */
    func isCompact(width: Double) -> Bool {
        #if os(iOS)
        if self.sizeClass == .compact {
            if verticalSizeClass == .compact {
                return false
            }
        }
        #endif
        if self.dynamicType >= dynamicTypeThreshold {
            return true
        }
        if width < self.widthThreshold {
            return true
        }
        return false
    }
}

struct WidthThresholdProxy: Equatable {
    var width: Double
    var isCompact: Bool
}


struct WidthThresholdReader_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 40) {
            WidthThresholdReader { proxy in
                Label {
                    Text("Standard")
                } icon: {
                    compactIndicator(proxy: proxy)
                }
            }
            .border(.quaternary)
            
            WidthThresholdReader { proxy in
                Label {
                    Text("200 Wide")
                } icon: {
                    compactIndicator(proxy: proxy)
                }
            }
            .frame(width: 200)
            .border(.quaternary)
            
            WidthThresholdReader { proxy in
                Label {
                    Text("X Large Type")
                } icon: {
                    compactIndicator(proxy: proxy)
                }
            }
            .dynamicTypeSize(.xxxLarge)
            .border(.quaternary)
        
            #if os(iOS)
            WidthThresholdReader { proxy in
                Label {
                    Text("Manually Compact Size Class")
                } icon: {
                    compactIndicator(proxy: proxy)
                }
            }
            .border(.quaternary)
            .environment(\.horizontalSizeClass, .regular)
            #endif
        }
    }
    
    @ViewBuilder
    static func compactIndicator(proxy: WidthThresholdProxy) -> some View {
        if proxy.isCompact {
            Image(systemName: "arrowtriangle.right.and.line.vertical.and.arrowtriangle.left.fill")
                .foregroundStyle(.red)
        } else {
            Image(systemName: "checkmark.circle")
                .foregroundStyle(.secondary)
        }
    }
}
