/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The sidebar and the root of the navigation interface.
*/

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
    /// The value for the ``PageSource``
    case pageSource(PageSource)
    /// The value for the ``SecondPage``.
    case about
}

/// An enum that represents the person's selection of Page in the app's sidebar.
enum PageSource: String, CaseIterable {
    /// The value for the ``WelcomePageView``
    case welcome = "Welcome"
    /// The value for the ``FirstPage``
    case firstPage = "FirstPage"
//    case readme = "README"
//    case history = "history"
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
            }
            
            Section("Pages") {
                ForEach(PageSource.allCases, id: \.self) { page in
                    NavigationLink(value: Panel.pageSource(page)) {
                        Label(page.pannelName, systemImage: page.icon)
                    }
                }
            }
            
            NavigationLink(value: Panel.about) {
                Label("Game 👾", systemImage: "2.circle")
            }
        }
        .navigationTitle("Regex Go 🛫")
        #if os(macOS)
        .navigationSplitViewColumnWidth(min: 200, ideal: 200)
        #endif
    }
}

extension Panel {
    static var defaultPage = pageSource(.welcome)

    var isFirst: Bool {
        self == .pageSource(.welcome)
    }
    
    var isLast: Bool {
        return self == .about
    }
    
    func next() -> Panel {
        switch self {
        case .about:
            return .about
        case .pageSource(let page):
            switch page {
            case .welcome:
                return .pageSource(.firstPage)
            case .firstPage:
                return .about
//            default:
//                return .about
            }
        }
    }
    
    func previous() -> Panel {
        switch self {
        case .about:
            return .pageSource(.firstPage)
        case .pageSource(let page):
            switch page {
            case .welcome:
                return .pageSource(.welcome)
            case .firstPage:
                return .pageSource(.welcome)
//            default:
//                return .pageSource(.firstPage)
            }
        }
    }
}

extension PageSource: CustomStringConvertible {
    
    /// Page Name
    var description: String {
        return self.rawValue
    }
    
    var pannelName: String {
        switch self {
        case .welcome:
            return "Welcome 🥳 "
        case .firstPage:
            return "Story 📖"
        }
    }
    
    /// Page Icon Name
    var icon: String {
        switch self {
        case .welcome:
            return "highlighter"
        case .firstPage:
            return "1.circle"
//        case .readme:
//            return "bookmark"
//        case .history:
//            return "fossil.shell"
        }
    }
}
