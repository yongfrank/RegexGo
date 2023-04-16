import SwiftUI

struct ContentView: View {
    @State private var bio = "Describe yourself."
    @State private var isShowingFindNavigator = false
    
    var body: some View {
        NavigationStack {
            TextEditor(text: $bio)
                .replaceDisabled()
                .findNavigator(isPresented: $isShowingFindNavigator)
                .toolbar {
                    Button {
                        isShowingFindNavigator.toggle()
                    } label: {
                        Label("Find", systemImage: "magnifyingglass")
                    }
                }
                .navigationTitle("Edit Bio")
        }
    }
}
