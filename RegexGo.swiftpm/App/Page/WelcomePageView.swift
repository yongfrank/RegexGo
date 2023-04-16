//
//  WelcomePageView.swift
//  
//
//  Created by Chu Yong on 4/15/23.
//

/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The app's landing page view.
*/

import SwiftUI

struct WelcomePageView: View {
    @ObservedObject var model: RegexPlaygroundsModel
    @Binding var navigationSelection: PageSource
    
    var body: some View {
        SideBySideStack {
            docView
            playGroundView
        }
//        verticalContent: {
//            docView
//            Spacer().ignoresSafeArea()
//            playGroundView
//        }
    }
    
    var docView: some View {
        DocumentView(.welcome, title: navigationSelection.panelName) {}
    }
    
    var playGroundView: some View {
        SectionView(title: "👾 Playground", needPadding: false, borderType: .none) {
            PasswordView()
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
