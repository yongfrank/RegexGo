//
//  FirstPage.swift
//  
//
//  Created by Chu Yong on 4/3/23.
//

import SwiftUI

struct FirstPage: View {
    @ObservedObject var model: RegularExpressionModel
    @Binding var navigationSelection: Panel?

    var body: some View {
        HStack {
            VStack {
                Text("First Page")
                Button("show") {
                    model.columnVisibility = .all
                    navigationSelection = .pageSecond
                }
            }
            DocumentView(PageSource.readme.rawValue)
        }
    }
}

enum PageSource: String {
    case firstPage = "FirstPage"
    case readme = "README"
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        FirstPage(model: RegularExpressionModel(), navigationSelection: .constant(.pageFirst))
    }
}
