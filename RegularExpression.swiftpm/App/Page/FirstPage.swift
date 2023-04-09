//
//  FirstPage.swift
//  
//
//  Created by Chu Yong on 4/3/23.
//

import SwiftUI

func isPageSource(_ pannel: Panel?) -> Bool {
    switch pannel {
    case .none:
        return false
    case .pageSource(_):
        return true
    case .about:
        return false
    }
}

struct FirstPage: View {
    @ObservedObject var model: RegularExpressionModel
    @Binding var navigationSelection: PageSource

    var body: some View {
        HStack {
            DocumentView(navigationSelection.description)
            
            SectionView {
                BlankPage()
            }
//            VStack {
//                Text("First PageFirst PageFirst PageFirst PageFirst PageFirst PageFirst PageFirst Page")
//                Button("show") {
//                    model.columnVisibility = .all
//                    navigationSelection = .about
//                }
//            }
        }
    }
}

struct FirstPage_Previews: PreviewProvider {
    static var previews: some View {
        FirstPage(model: RegularExpressionModel(), navigationSelection: .constant(.firstPage))
    }
}
