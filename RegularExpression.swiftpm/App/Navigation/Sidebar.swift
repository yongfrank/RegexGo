//
//  Sidebar.swift
//  
//
//  Created by Chu Yong on 4/2/23.
//

import SwiftUI

enum Panel: Hashable {
    /// The value for the ``First TruckView``.
    case pageFirst
    /// The value for the ``Second FeedView``.
    case pageSecond
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
            NavigationLink(value: Panel.pageFirst) {
                Label("Page 1", systemImage: "1.circle")
            }
            NavigationLink(value: Panel.pageSecond) {
                Label("Page 2", systemImage: "2.circle")
            }
        }
        .navigationTitle("Regex")
    }
}
