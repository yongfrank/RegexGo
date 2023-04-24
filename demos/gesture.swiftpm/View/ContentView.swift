// https://www.youtube.com/watch?v=ylcEQHYev1U
// A mini-game with collisions in SwiftUI 🔴🔵🟠🟣🟢⚫️

import SwiftUI
import RegexBuilder

struct ContentView: View {
    @State var position = CGPoint(x: 100, y: 100)
    
    var drag: some Gesture {
        DragGesture()
            .onChanged { state in
                position = state.location
            }
            .onEnded { state in
                position = CGPoint(x: 100, y: 100)
            }
    }
    
    var body: some View {
        DraggableToy(position: position, gesture: drag)
    }
}
