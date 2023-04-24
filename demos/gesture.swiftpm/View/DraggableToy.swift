import SwiftUI

struct DraggableToy<Draggable: Gesture>: View {
    let size: CGRect = CGRect(x: 0, y: 0, width: 200, height: 30)
    
    let position: CGPoint
    let gesture: Draggable
    var body: some View {
        Rectangle()
            .fill(.red)
            .frame(width: size.width, height: size.height)
            .cornerRadius(10, antialiased: true)
            .position(position)
            .gesture(gesture)
    }
}

struct DraggableToy_Previews: PreviewProvider {
    static var previews: some View {
        DraggableToy(position: .zero, gesture: DragGesture())
    }
}
