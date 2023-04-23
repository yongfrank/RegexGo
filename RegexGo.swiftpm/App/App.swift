/*

Abstract:
The single entry point for the Regex Playground app on iOS and macOS.
*/

import SwiftUI

// TODO: email me

/// The app's entry point.
///
/// The `RegexPlaygourndApp` object is the app's entry point. Additionally, this is the object that keeps the app's state in the `model` and `store` parameters.
///
@main
struct RegexPlaygroundApp: App {
    /// The app's state.
    @StateObject private var model = RegexPlaygroundsModel()
    
    @State var isColorSchemeDefault = false

    /// The app's body function.
    ///
    /// This app uses a [`WindowGroup`](https://developer.apple.com/documentation/swiftui/windowgroup) scene, which contains the root view of the app, ``ContentView``.
    var body: some Scene {
        WindowGroup {
            ContentView(model: model)
                .preferredColorScheme(model.colorScheme)
                .monospaced()
                .environmentObject(model)
        }
        #if os(macOS)
        .defaultSize(width: 1000, height: 650)
        #endif
    }
}
