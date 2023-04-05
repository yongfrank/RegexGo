//
//  DocumentView.swift
//  
//
//  Created by Chu Yong on 4/5/23.
//

import SwiftUI

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

    var body: some View {
        ScrollView {
            Text(content ?? "nil content")
                .font(docFont)
                .border(showingBorder ? .red : .clear)
        }
        .border(showingBorder ? .blue : .clear)
    }
    
    init(_ filename: String, _ docFont: Font = .body.monospaced()) {
        self.filename = filename
        self.docFont = docFont
    }
}

struct DocumentView_Previews: PreviewProvider {
    static var previews: some View {
        DocumentView("README")
    }
}
