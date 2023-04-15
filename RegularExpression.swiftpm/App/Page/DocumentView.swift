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
    private let title: String
    
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

    var body: some View {
        ZStack(alignment: .top) {
            SectionView(title: title, needPadding: false) {
                ScrollView {
                    Text(content ?? "nil content")
                    /// On iOS, the person using the app touches and holds on a selectable Text view, which brings up a system menu with menu items appropriate for the current context. These menu items operate on the entire contents of the Text view; the person can’t select a range of text like they can on macOS.
                        .textSelection(.enabled)
                        .font(docFont)
                        .padding()
                }
                .background(.regularMaterial)
            }
        }
    }
    
    
    /// Init Document File
    /// - Parameters:
    ///   - filename: markdown filename
    ///   - docFont: rendered file font
    init(_ filename: String, _ docFont: Font = .body.monospaced(), title: String = "Documentation") {
        self.filename = filename
        self.docFont = docFont
        self.title = title
    }
}

struct DocumentView_Previews: PreviewProvider {
    static var previews: some View {
        DocumentView(PageSource.firstPage.rawValue)
    }
}
