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
        switch selection ?? nil {
        case .pageFirst:
            FirstPage(model: model, navigationSelection: $selection)
        case .pageSecond:
            SecondPage()
        case .none:
            BlankPage()
        }
    }

}
