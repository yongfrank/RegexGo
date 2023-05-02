//
//  FirstPage.swift
//  
//
//  Created by Chu Yong on 4/3/23.
//

import SwiftUI

//func isPageSource(_ pannel: Panel?) -> Bool {
//    switch pannel {
//    case .none:
//        return false
//    case .pageSource(_):
//        return true
//    case .about:
//        return false
//    }
//}

struct FirstPage: View {
    @ObservedObject var model: RegexPlaygroundsModel
    @Binding var navigationSelection: PageSource

    var body: some View {
        SideBySideStack {
            docView
            playgroundsView
        }
    }
    
    private var docView: some View {
        DocumentView(navigationSelection.description, title: navigationSelection.panelName) {
//            Button("Next") {}
        }
    }
    
    private var playgroundsView: some View {
        SectionView(needPadding: false, borderType: .none) {
            BlankPage()
        }
    }
}

struct FirstPage_Previews: PreviewProvider {
    static var previews: some View {
        FirstPage(model: RegexPlaygroundsModel(), navigationSelection: .constant(.firstPage))
    }
}
