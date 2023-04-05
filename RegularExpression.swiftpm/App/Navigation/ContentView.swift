import SwiftUI

struct Page: Identifiable {
    var id: String
    var content: String
}

/// The root view in Food Truck.
///
/// This view is the root view in ``MyApp``'s scene.
/// On macOS, and iPadOS it presents a split navigation view, while on iOS devices it presents a navigation stack, as the main interface of the app.
struct ContentView: View {
    @State private var employeeIds: Set<Page.ID> = []
    @ObservedObject var model: RegularExpressionModel
    
    @State private var selection: Panel? = Panel.pageFirst
    
    var body: some View {
        NavigationSplitView(columnVisibility: $model.columnVisibility) {
            Sidebar(selection: $selection, progress: model.progress)
        } detail: {
            DetailColumn(selection: $selection, model: model)
        }
    }
}
