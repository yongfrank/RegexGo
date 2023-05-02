//
//  PageView.swift
//  
//
//  Created by Chu Yong on 4/16/23.
//

import SwiftUI

struct PageView<Content: View>: View {
    @ObservedObject var model: RegexPlaygroundsModel
    @Binding var navigationSelection: PageSource
    @ViewBuilder var content: () -> Content

    var body: some View {
        SideBySideStack {
            docView
            playgroundView
        }
    }
    
    private var docView: some View {
        DocumentView(navigationSelection.pageName, title: navigationSelection.panelName) {
            
        }
    }
    private var playgroundView: some View {
        content()
    }
}

//struct SwiftUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        PageView()
//    }
//}
