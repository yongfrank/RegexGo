//
//  DocumentView.swift
//  
//
//  Created by Chu Yong on 4/5/23.
//

import SwiftUI

/// This View is Used for render Markdown file
struct DocumentView: View {
    private let showingBorder = false
    private let docFont: Font
    
    private let filename: String
    
    private var content: LocalizedStringKey? {
        if let filepathUrl = Bundle.main.url(forResource: filename, withExtension: "md") {
            return try? LocalizedStringKey(
                String(contentsOf: filepathUrl)
            )
        }
        return "Unable to load"
    }
    
    private var indicating: Bool {
        self.title != "" ? true : false
    }
    @State private var title = ""

    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                Text(content ?? "nil content")
                    .font(docFont)
                    .padding()
                    .border(showingBorder ? .red : .clear)
            }
            .border(showingBorder ? .blue : .clear)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.quaternary, lineWidth: 8)
            )
            .mask(RoundedRectangle(cornerRadius: 16))
            
            Text("\(title)")
                .font(.body.monospaced())
                .padding()
                .background(Material.thin)
                .frame(height: 32)
                .cornerRadius(32)
                .shadow(color: .black.opacity(0.1), radius: 12, x: 0, y: 0)
                .opacity(indicating ? 1 : 0)
                .padding(.top, 32)
//            Button("Toggle") {
//                self.title = self.title == "" ? "hi" : ""
//            }
        }
        
//        .animation(.easeInOut, value: self.width)
    }
    
    
    /// Init Document File
    /// - Parameters:
    ///   - filename: markdown filename
    ///   - docFont: rendered file font
    init(_ filename: String, _ docFont: Font = .body.monospaced()) {
        self.filename = filename
        self.docFont = docFont
    }
}

struct DocumentView_Previews: PreviewProvider {
    static var previews: some View {
        DocumentView(PageSource.history.rawValue)
    }
}
