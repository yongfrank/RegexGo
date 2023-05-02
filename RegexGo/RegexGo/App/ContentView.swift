/*
 
Abstract:
The app's root view.
*/

import SwiftUI
import MarkdownUI
#if DEBUG
import FLEX
#endif

/// The root view in Regex Go.
///
/// This view is the root view in ``RegexPlaygroundApp``'s scene.
/// On macOS, and iPadOS it presents a split navigation view, while on iOS devices it presents a navigation stack, as the main interface of the app.
struct ContentView: View {
    /// The app's model that the containing scene passes in.
    @ObservedObject var model: RegexPlaygroundsModel
    
    @State private var selection: Panel? = Panel.defaultPage
    
    @State private var path = NavigationPath()
    
    @State private var isNight = false
    
    @AppStorage("navigationSelection") private var navigationSelectionData: Data?
    
    /// The view body.
    ///
    /// This view embeds a [`NavigationSplitView`](https://developer.apple.com/documentation/swiftui/navigationsplitview),
    /// which displays the ``Sidebar`` view in the
    /// left column, and a [`NavigationStack`](https://developer.apple.com/documentation/swiftui/navigationstack)
    /// in the detail column, which consists of ``DetailColumn``, on macOS and iPadOS.
    /// On iOS the [`NavigationSplitView`](https://developer.apple.com/documentation/swiftui/navigationsplitview)
    /// display a navigation stack with the ``Sidebar`` view as the root.
    var body: some View {
        ZStack {
            NavigationSplitView(columnVisibility: $model.columnVisibility) {
                Sidebar(selection: $selection, model: model, progress: model.progress)
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
            FireworkView(showFirework: model.isShowFirework, isConfettiSwiftUILibrary: true, confettiCounter: $confettiCounter)
        }
        .onChange(of: selection) { _ in
            self.path.removeLast(path.count)
            self.storePersistentSelection(from: selection)
        }
        .onAppear {
            loadPersistentSelection(from: navigationSelectionData)
        }
        .onChange(of: self.model.isShowFirework) { newValue in
            if self.model.isShowFirework == true {
                
                // Show Confetti
                confettiCounter += 1
                DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                    self.model.isShowFirework = false
                }
            }
        }
    }
    
    @State private var confettiCounter = 0
    
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
    
    /// toolBarItems including Night Mode
    private var toolBarItems: some ToolbarContent {
        Group {
            if Panel.needNavigation.contains(self.selection ?? .settings) {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    HStack {
                        
                        #if DEBUG
                        themePicker
                        #endif
                        
                        pageNavigatorLeft
                        
                        // Progress Bar
                        if Panel.hideProgress.contains(self.selection ?? .settings) { } else {
                            progressBar
                        }
                        
                        pageNavigatorRight
                    }
                }
            }
        }
    }
    
    private var darkModeButton: some View {
        Button {
            self.model.colorScheme = (
                self.model.colorScheme == .light ? .dark : .light
            )
        } label: {
            Image(systemName: self.model.colorScheme == .light ? "moon" : "sun.max")
        }
    }
    
    private var pageNavigatorLeft: some View {
        HStack {
            Button {
                self.selection = self.selection?.previous()
            } label: {
                Image(systemName: "chevron.backward")
            }
            .disabled(self.selection?.isFirst ?? true)
        }
    }
    
    private var pageNavigatorRight: some View {
        Button {
            self.selection = self.selection?.next()
        } label: {
            Image(systemName: "chevron.forward")
        }
        .disabled(self.selection?.isLast ?? true)
    }
    
    private var progressBar: some View {
        VStack {
            if self.selection == .pageSource(.welcome) || self.selection == .pageSource(.firstPage) || self.selection == .pageSource(.secondPage) {
                Group {
                    if model.completionProgress.contains(self.selection ?? .settings) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.accentColor)
                            .padding(.leading, 5)
                            .transition(.scale.combined(with: .opacity))
                    } else {
                        Image(systemName: "circlebadge")
                            .foregroundColor(.secondary)
                            .padding(.leading, 5)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                .onTapGesture {
                    self.model.isShowFirework = true
                }
            } else {
                Image(systemName: "swift")
                    .foregroundColor(.accentColor)
                    .padding(.leading, 5)
            }
        }
        .animation(Animation.timingCurve(0.44, 1.86, 0.61, 0.99, duration: 0.5), value: self.model.completionProgress)
        .onTapGesture {
            self.model.isShowFirework = true
        }
    }
    
    @State private var themeChoosed: ThemeOption = .basic
    
    #if DEBUG
    private var themePicker: some View {
        HStack {
            Picker("Theme", selection: self.$themeChoosed) {
                ForEach(ThemeOption.themeOptions, id: \.self) { option in
                    Text(option.name).tag(option)
                }
            }
            Button("FLEX") {
                FLEXManager.shared.showExplorer()
            }
        }
        .onChange(of: themeChoosed) { newValue in
            model.theme = newValue
        }
    }
    #endif
}

extension ContentView {
    private func loadPersistentSelection(from data: Data?) {
        guard let data = data, let persistentSelection = try? JSONDecoder().decode(Panel.self, from: data) else { return }
        self.selection = persistentSelection
    }
    
    private func storePersistentSelection(from panel: Panel?) {
        guard let persistenceSelectionData = try? JSONEncoder().encode(panel ?? .pageSource(.welcome)) else { return }
        self.navigationSelectionData = persistenceSelectionData
    }
}

struct ContentView_Previews: PreviewProvider {
    struct Preview: View {
        @StateObject var model = RegexPlaygroundsModel()
        var body: some View {
            ContentView(model: RegexPlaygroundsModel())
                .monospaced()
                .environmentObject(model)
        }
    }
    static var previews: some View {
        Preview()
//            .environment(\.locale, .init(identifier: "zh-Hans"))
    }
}
