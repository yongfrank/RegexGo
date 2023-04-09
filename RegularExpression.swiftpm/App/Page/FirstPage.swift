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
            DocumentView(PageSource.history.rawValue)
            VStack {
                Text("First PageFirst PageFirst PageFirst PageFirst PageFirst PageFirst PageFirst Page")
                Button("show") {
                    model.columnVisibility = .all
                    navigationSelection = .pageSecond
                }
            }
        }
    }
}

enum PageSource: String {
    case firstPage = "FirstPage"
    case readme = "README"
    case history = "history"
    
//    static func page() -> String {
//        return PageSource.RawValue
//    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        FirstPage(model: RegularExpressionModel(), navigationSelection: .constant(.pageFirst))
    }
}
