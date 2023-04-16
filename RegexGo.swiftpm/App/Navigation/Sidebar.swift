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
    case regexPlayground
    /// The value for the ``RegexBuilderView``.
    case regexBuilder
    /// The value for the ``SettingsView``
    case settings
    
    static var hideProgress: [Panel] = [.pageSource(.secondPage), .regexBuilder]
    static var miscPanels: [Panel] = [.settings]
    static var playgrounds: [Panel] = [.regexPlayground, .regexBuilder]
    static var needNavigation: [Panel] = [
        .pageSource(.welcome),
        .pageSource(.firstPage),
        .pageSource(.secondPage),
        .regexPlayground,
        .regexBuilder
    ]
}

/// An enum that represents the person's selection of Page in the app's sidebar.
enum PageSource: String, CaseIterable {
    /// The value for the ``WelcomePageView``
    case welcome = "Welcome"
    /// The value for the ``FirstPage``
    case firstPage = "FirstPage"
    case secondPage = "RegexBuilder"
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
//                Text(progress == 1.0 ? "Success" : "Loading")
                Text((progress * 100).formatted() + "% completed")
                    .font(.caption)
                    .foregroundColor(.secondary)
                ProgressView(value: progress)
            }
            
            Section("Pages 📖") {
                ForEach(PageSource.allCases, id: \.self) { page in
                    NavigationLink(value: Panel.pageSource(page)) {
                        Label(page.panelName, systemImage: page.icon)
                    }
                }
            }
            
            Section("Playgrounds 🎊") {
                ForEach(Panel.playgrounds, id: \.self) { page in
                    NavigationLink(value: page) {
                        Label(page.panelName, systemImage: page.icon)
                    }
                }
            }
            
            Section("Misc 🦭") {
                ForEach(Panel.miscPanels, id: \.self) { page in
                    NavigationLink(value: page) {
                        Label(page.panelName, systemImage: page.icon)
                    }
                }
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
    
    var panelName: String {
        switch self {
        case .pageSource(_):
            return "Pages"
        case .regexPlayground:
            return "Regex Playground 👾"
        case .regexBuilder:
            return "Builder Playground ⛷️"
        case .settings:
            return "Settings 🔩"
        }
    }
    var icon: String {
        switch self {
        case .pageSource(_):
            return "scribble"
        case .regexPlayground:
            return "gamecontroller"
        case .settings:
            return "gearshape"
        case .regexBuilder:
            return "building.2"
        }
    }

    var isFirst: Bool {
        self == .pageSource(.welcome)
    }
    
    var isLast: Bool {
        return self == .regexBuilder
    }
    
    func next() -> Panel {
        switch self {
        case .pageSource(let page):
            switch page {
            case .welcome:
                return .pageSource(.firstPage)
            case .firstPage:
                return .pageSource(.secondPage)
//            default:
//                return .about
            case .secondPage:
                return .regexPlayground
            }
        case .regexPlayground:
            return .regexBuilder
        case .regexBuilder:
            return .regexBuilder
        case .settings:
            return .settings
        }
    }
    
    func previous() -> Panel {
        switch self {
        case .pageSource(let page):
            switch page {
            case .welcome:
                return .pageSource(.welcome)
            case .firstPage:
                return .pageSource(.welcome)
//            default:
//                return .pageSource(.firstPage)
            case .secondPage:
                return .pageSource(.firstPage)
            }
        case .regexPlayground:
            return .pageSource(.secondPage)
        case .regexBuilder:
            return .regexPlayground
        case .settings:
            return .regexPlayground
        }
    }
}

extension PageSource: CustomStringConvertible {
    
    /// Page Name
    var description: String {
        return self.rawValue
    }
    
    /// Page Name
    var pageName: String {
        return self.rawValue
    }
    
    var panelName: String {
        switch self {
        case .welcome:
            return "Welcome 🥳 "
        case .firstPage:
            return "Common Regex 🤯"
        case .secondPage:
            return "Regex Builder with DSL 🛠️"
        }
    }
    
    /// Page Icon Name
    var icon: String {
        switch self {
        case .welcome:
            return "highlighter"
        case .firstPage:
            return "fossil.shell"
//        case .readme:
//            return "bookmark"
//        case .history:
//            return "fossil.shell"
        case .secondPage:
            return "building"
        }
    }
}
