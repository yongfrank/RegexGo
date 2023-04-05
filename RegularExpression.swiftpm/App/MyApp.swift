import SwiftUI

/// The app's entry point.
///
/// The `MyApp` object is the app's entry point. Additionally, this is the object that keeps the app's state in the `model` and `store` parameters.
///
@main
struct MyApp: App {
    /// The app's state.
    @StateObject private var model = RegularExpressionModel()
    
    /// The app's body function.
    ///
    /// This app uses a [`WindowGroup`](https://developer.apple.com/documentation/swiftui/windowgroup) scene, which contains the root view of the app, ``ContentView``.
    var body: some Scene {
        WindowGroup {
            ContentView(model: model)
        }
    }
}
