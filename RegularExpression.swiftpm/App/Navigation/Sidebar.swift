//
//  Sidebar.swift
//  
//
//  Created by Chu Yong on 4/2/23.
//

import SwiftUI

/// An enum that represents the person's selection in the app's sidebar.
///
/// The `Panel` enum encodes the views the person can select in the sidebar, and hence appear in the detail view.
enum Panel: Hashable {
    
//    /// The value for the ``FirstPage``.
//    case pageFirst
    /// The value for the ``SecondPage``.
    case about
    case pageSource(PageSource)
}

/// The navigation sidebar view.
///
/// The ``ContentView`` presents this view as the navigation sidebar view on macOS and iPadOS, and the root of the navigation stack on iOS.
/// The superview passes the person's selection in the ``Sidebar`` as the ``selection`` binding.
struct Sidebar: View {
    /// The person's selection in the sidebar.
    ///
    /// This value is a binding, and the superview must pass in its value.
    @Binding var selection: Panel?
    
    var progress: Double
    
    /// The view body.
    ///
    /// The `Sidebar` view presents a `List` view, with a `NavigationLink` for each possible selection.
    var body: some View {
        List(selection: $selection) {
            VStack(alignment: .leading) {
                Text(progress == 1.0 ? "Success" : "Loading")
                ProgressView(value: progress)
                ProgressView(value: progress)
                    .progressViewStyle(.circular)
                Text("\(progress)")
            }
            
            ForEach(PageSource.allCases, id: \.self) { page in
                Button {
                    self.selection = .pageSource(page)
                } label: {
                    Text(page.description)
                }
            }
            NavigationLink(value: Panel.pageSource(.firstPage)) {
                Label("Page 1", systemImage: "1.circle")
            }
            NavigationLink(value: Panel.about) {
                Label("Page 2", systemImage: "2.circle")
            }
        }
        .navigationTitle("Regex")
    }
}

extension Panel {
    func next() -> Panel {
        switch self {
        case .about:
            return .about
        case .pageSource(let page):
            switch page {
            case .firstPage:
                return .about
            default:
                return .about
            }
        }
    }
    
    func previous() -> Panel {
        switch self {
        case .about:
            return .pageSource(.firstPage)
        case .pageSource(let page):
            switch page {
            case .firstPage:
                return .pageSource(.firstPage)
            default:
                return .pageSource(.firstPage)
            }
        }
    }
}
