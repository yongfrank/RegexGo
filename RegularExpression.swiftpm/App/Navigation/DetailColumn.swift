//
//  DetailColumn.swift
//  
//
//  Created by Chu Yong on 4/3/23.
//

import SwiftUI

struct DetailColumn: View {
    /// The person's selection in the sidebar.
    ///
    /// This value is a binding, and the superview must pass in its value.
    @Binding var selection: Panel?
    
    /// The app's model the superview must pass in.
    @ObservedObject var model: RegularExpressionModel
    /// The body function
    ///
    /// This view presents the appropriate view in response to the person's selection in the ``Sidebar``. See ``Panel``
    /// for the views that `DetailColumn`  presents.
    var body: some View {
        switch selection ?? .pageSource(.firstPage) {
        case .about:
            SecondPage()
        case .pageSource(let page):
            switch page {
            case .firstPage:
                FirstPage(model: model, navigationSelection: pageSourceBinding)
            default:
                FirstPage(model: model, navigationSelection: pageSourceBinding)
            }
        }
        //        case .none:
        //            BlankPage()

    }
    
    private var pageSourceBinding: Binding<PageSource> {
        Binding<PageSource>(
            get: {
                switch selection {
                case .pageSource(let page):
                    return page
                default:
                    return .firstPage
                }
            },
            set: { newValue in
                selection = .pageSource(newValue)
            }
        )
    }


}
