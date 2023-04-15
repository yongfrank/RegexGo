/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The app's landing page view.
*/

//
//  WelcomePageView.swift
//  
//
//  Created by Chu Yong on 4/15/23.
//

import SwiftUI

struct WelcomePageView: View {
    @ObservedObject var model: RegexPlaygroundsModel
    @Binding var navigationSelection: PageSource
    
    var body: some View {
        WidthThresholdReader(widthThreshold: 520) { proxy in
            Grid(horizontalSpacing: 12, verticalSpacing: 12) {
                if proxy.isCompact {
                    
                } else {
                    
                }
            }
        }
    }
    
    var docView: some View {
        SectionView {
            Text("hi")
        }
    }
    
    var playGroundView: some View {
        SectionView {
            Text("wo")
        }
    }
}

struct WelcomePageView_Previews: PreviewProvider {
    struct Preview: View {
        @State private var navigationSelection: PageSource = .welcome
        var body: some View {
            WelcomePageView(model: RegexPlaygroundsModel(), navigationSelection: $navigationSelection)
        }
    }
    static var previews: some View {
        NavigationStack {
            Preview()
        }
    }
}
