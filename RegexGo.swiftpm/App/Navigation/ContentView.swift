/*
 
Abstract:
The app's root view.
*/

import SwiftUI

/// The root view in Food Truck.
///
/// This view is the root view in ``RegexPlaygroundApp``'s scene.
/// On macOS, and iPadOS it presents a split navigation view, while on iOS devices it presents a navigation stack, as the main interface of the app.
struct ContentView: View {
    /// The app's model that the containing scene passes in.
    @ObservedObject var model: RegexPlaygroundsModel
    
    @State private var selection: Panel? = Panel.defaultPage
    @State private var path = NavigationPath()
    
    @State private var isNight = false
    
    /// The view body.
    ///
    /// This view embeds a [`NavigationSplitView`](https://developer.apple.com/documentation/swiftui/navigationsplitview),
    /// which displays the ``Sidebar`` view in the
    /// left column, and a [`NavigationStack`](https://developer.apple.com/documentation/swiftui/navigationstack)
    /// in the detail column, which consists of ``DetailColumn``, on macOS and iPadOS.
    /// On iOS the [`NavigationSplitView`](https://developer.apple.com/documentation/swiftui/navigationsplitview)
    /// display a navigation stack with the ``Sidebar`` view as the root.
    var body: some View {
        NavigationSplitView(columnVisibility: $model.columnVisibility) {
            Sidebar(selection: $selection, progress: model.progress)
        } detail: {
            NavigationStack(path: $path) {
                DetailColumn(selection: $selection, model: model)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        toolBarItems
                    }
                    .toolbarBackground(.hidden, for: .automatic)
            }
        }
        .onChange(of: selection) { _ in
            path.removeLast(path.count)
        }
    }
    
    #if os(iOS)
    @Environment (\.verticalSizeClass) private var verticalSizeClass
    @Environment(\.horizontalSizeClass) private var sizeClass
    #endif

    /**
     [Cross platform with SwiftUI](https://yongfrank.github.io/posts/swiftui/#cross-platform-swiftui)
    
     | Device                  | Landscape/Portrait | horizontalSizeClass | verticalSizeClass |
     | -------------------- | ---------------------- | ---------------------- | -------------------- |
     | All iPhone             |  Portrait                   | compact                  | regular                  |
     | iPhone (except Max、Plus) | Landscape    | compact             | compact               |
     | iPhone (Max、Plus)             | Landscape    | regular                | compact               |
     | All iPad                  | Landscape & Portrait  | regular                | regular                   |
     */
    private var isCompact: Bool {
        #if os(iOS)
        if self.sizeClass == .compact {
            if verticalSizeClass == .compact {
                return false
            }
            return true
        }
        #endif
        return false
    }
    
    private var toolBarItems: some ToolbarContent {
        Group {
            if Panel.needNavigation.contains(self.selection ?? .settings) {
                ToolbarItemGroup(placement: .principal) {
                    HStack {
                        pageNavigatorLeft
                        if self.isCompact &&
                            Panel.hideProgress.contains(self.selection ?? .settings) {
                        } else {
                            progressBar
                        }
                        pageNavigatorRight
                    }
                }
            }
            
            ToolbarItemGroup {
                Button {
                    self.model.colorScheme = (
                        self.model.colorScheme == .light ? .dark : .light
                    )
                } label: {
                    Image(systemName: self.model.colorScheme == .light ? "moon" : "sun.max")
                }
            }
        }
    }
    
    private var pageNavigatorLeft: some View {
        HStack {
            Button {
                self.selection = self.selection?.previous()
            } label: {
                //                    Image(systemName: "arrowtriangle.left")
                Image(systemName: "chevron.backward")
            }
            .disabled(self.selection?.isFirst ?? true)
        }
    }
    
    private var pageNavigatorRight: some View {
        Button {
            self.selection = self.selection?.next()
        } label: {
            //                    Image(systemName: "arrowtriangle.forward")
            Image(systemName: "chevron.forward")
        }
        .disabled(self.selection?.isLast ?? true)
    }
    
    private var progressBar: some View {
        VStack(alignment: .leading) {
            //                    withAnimation {
            //                        Text(model.progress == 1.0 ? "Success" : "Loading")
            //                    }
            ProgressView(value: model.progress)
                .animation(.default, value: model.progress)
            Text((model.progress * 100).formatted() + "% completed")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(width: 200)
    }
}

struct ContentView_Previews: PreviewProvider {
    struct Preview: View {
        var body: some View {
            ContentView(model: RegexPlaygroundsModel())
        }
    }
    static var previews: some View {
        Preview()
    }
}
