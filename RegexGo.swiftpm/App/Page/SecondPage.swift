//
//  SecondPage.swift
//  
//
//  Created by Chu Yong on 4/5/23.
//

import SwiftUI

struct SecondPage: View {
    @ObservedObject var model: RegexPlaygroundsModel
    @Binding var navigationSelection: PageSource

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
        SectionView(needPadding: false, borderType: .none) {
            RegexBuilderView()
        }
    }
}

struct SecondPage_Previews: PreviewProvider {
    static var previews: some View {
        SecondPage(model: RegexPlaygroundsModel(), navigationSelection: .constant(.secondPage))
    }
}
