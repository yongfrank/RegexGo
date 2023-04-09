import SwiftUI

///// An enum that represents the person's selection in the app's sidebar.
//struct Page: Identifiable {
//    /// <#Description#>
//    var id: String
//    /// <#Description#>
//    var content: String
//}

/// The root view in Food Truck.
///
/// This view is the root view in ``MyApp``'s scene.
/// On macOS, and iPadOS it presents a split navigation view, while on iOS devices it presents a navigation stack, as the main interface of the app.
struct ContentView: View {
//    @State private var employeeIds: Set<Page.ID> = []
    
    /// The app's model that the containing scene passes in.
    @ObservedObject var model: RegularExpressionModel
    
    @State private var selection: Panel? = Panel.pageSource(.firstPage)
    
    var body: some View {
        NavigationSplitView(columnVisibility: $model.columnVisibility) {
            Sidebar(selection: $selection, progress: model.progress)
        } detail: {
            DetailColumn(selection: $selection, model: model)
                .padding(.horizontal)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem {
                        VStack(alignment: .leading) {
                            Text(model.progress == 1.0 ? "Success" : "Loading")
                            ProgressView(value: model.progress)
//                            ProgressView(value: model.progress)
//                                .progressViewStyle(.circular)
//                            Text("\(model.progress)")
                        }
                    }
                    ToolbarItem {
                        Button {
//                            withAnimation {
                                self.model.colorScheme = (
                                    self.model.colorScheme == .light ? .dark : .light
                                )
//                            }
                        } label: {
                            Image(systemName: self.model.colorScheme == .light ? "moon" : "sun.max")
                        }
                    }
                    ToolbarItem {
                        Button {
                            self.selection = self.selection?.previous()
                        } label: {
                            Image(systemName: "arrowtriangle.left")
                        }
                    }

                    ToolbarItem {
                        Button {
                            self.selection = self.selection?.next()
                        } label: {
                            Image(systemName: "arrowtriangle.forward")
                        }
                    }
                }
        }
    }
}
