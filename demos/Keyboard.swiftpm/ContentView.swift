import SwiftUI

struct ContentView: View {
    var body: some View {
        KeyboardBarDemo()
    }
}

enum Field {
    case suit
    case rank
}

struct FieldKey: FocusedValueKey {
    typealias Value = Field
}

extension FocusedValues {
    var field: Field? {
        get { self[FieldKey.self] }
        set { self[FieldKey.self] = newValue }
    }
}

struct KeyboardBarDemo: View {
    @FocusedValue(\.field) var field: Field?
    @FocusState private var focusedField: Field?
    @State private var suitText = ""
    @State private var rankText = ""
    
    var body: some View {
        HStack {
            TextField("Suit", text: $suitText)
                .focusedValue(\.field, .suit)
                .focused($focusedField, equals: .suit)
                .textFieldStyle(.roundedBorder)
            TextField("Rank", text: $rankText)
                .focusedValue(\.field, .rank)
                .focused($focusedField, equals: .rank)
                .textFieldStyle(.roundedBorder)
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                if field == .suit {
                    Button("♣️", action: { self.suitText += "♣️" })
                    Button("♥️", action: { self.suitText += "♥️" })
                    Button("♠️", action: { self.suitText += "♠️" })
                    Button("♦️", action: { self.suitText += "♦️" })
                }
                Spacer()
                Button("Done") {
                    focusedField = nil
                }
            }
        }
    }
}
