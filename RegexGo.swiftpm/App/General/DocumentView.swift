//
//  DocumentView.swift
//  
//
//  Created by Chu Yong on 4/5/23.
//

import SwiftUI

/// This View is Used for render Markdown file
struct DocumentView<Content: View>: View {
    private let isMarkDown: Bool
    private let showingBorder = false
    private let docFont: Font
    
    private let filename: String
    private let title: String
    
    private let contentView: Content
    
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
                    if isMarkDown {
                        Text(content ?? "nil content")
                        /// On iOS, the person using the app touches and holds on a selectable Text view, which brings up a system menu with menu items appropriate for the current context. These menu items operate on the entire contents of the Text view; the person can’t select a range of text like they can on macOS.
                            .textSelection(.enabled)
                            .font(docFont)
                            .padding()
                        contentView
                            .padding(.bottom)
                    } else {
                        contentView
                    }
                }
                // For MaxWidth even text is not available
                .frame(maxWidth: .infinity)
//                .background(.regularMaterial)
                .background(.thickMaterial)
                // https://www.hackingwithswift.com/quick-start/swiftui/how-to-change-the-background-color-of-list-texteditor-and-more
//                .background(.linearGradient(colors: [.white, .gray], startPoint: .top, endPoint: .bottom))
            }
        }
    }
    
    
    /// Init Document File
    /// - Parameters:
    ///   - filename: markdown filename
    ///   - docFont: rendered file font
    init(_ filename: String, _ docFont: Font = .body.monospaced(), title: String = "", isMarkdown: Bool = true, @ViewBuilder content: () -> Content) {
        self.filename = filename
        self.docFont = docFont
        
        if title == "" {
            self.title = filename
        } else {
            self.title = title
        }
        
        self.isMarkDown = isMarkdown
        self.contentView = content()
    }
    
    /// Init Document File
    /// - Parameters:
    ///   - filename: markdown filename
    ///   - docFont: rendered file font
    init(_ filename: PageSource, _ docFont: Font = .body.monospaced(), title: String, isMarkdown: Bool = true, @ViewBuilder content: () -> Content) {
        self.filename = filename.description
        self.docFont = docFont
        
        if title == "" {
            self.title = filename.panelName
        } else {
            self.title = title
        }
        
        self.isMarkDown = isMarkdown
        self.contentView = content()
    }
    
    /// Custom Document File
    /// - Parameters:
    ///   - isMarkDown: defalut no
    ///   - title: HUD Title
    ///   - content: Custom View
    init(isMarkDown: Bool = false, title: String, @ViewBuilder content: () -> Content) {
        self.isMarkDown = isMarkDown
        self.title = title
        self.docFont = .body.monospaced()
        self.filename = ""
        self.contentView = content()
    }
}

struct DocumentView_Previews: PreviewProvider {
    static var previews: some View {
        DocumentView(PageSource.firstPage.rawValue, title: "i") {}
    }
}
