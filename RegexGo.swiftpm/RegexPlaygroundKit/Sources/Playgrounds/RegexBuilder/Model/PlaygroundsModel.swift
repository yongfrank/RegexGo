//
//  PlaygroundsModel.swift
//  
//
//  Created by Chu Yong on 4/15/23.
//

#if os(iOS) || os(macOS)

import Foundation
import SwiftUI

@MainActor
public final class PlaygroundsModel: ObservableObject {
    
    @Published var pages = RegexBuilderLine.PAGESEXAMPLE {
        didSet {
            self.storePersistentPages()
        }
    }
    @Published var currentDragPage: RegexBuilderLine?
    @AppStorage("persistencePages") var persistencePages: Data?
    
    /// Deprecated
    func printAllStr(pages: [RegexBuilderLine], text: String) -> String {
        var result = ""
//        for page in pages {
//            result += page.regexString.description
//        }
        guard let regexComponent = try? /\/(.*)\//.firstMatch(in: result)?.1, let regexpattern = try? Regex(String(regexComponent)) else { return "Component Error"}
        print(text, regexComponent)
        
        let findedResult = text.matches(of: regexpattern)
//        result += "\n===== 🤯 Result Area \(Date.now.formatted()) =====\n"
        if findedResult.isEmpty {
            result += "Not Found\n"
        }
        for match in findedResult {
            result += "\(match.0)\n"
        }
//        result += "===== 🤯 Result Area \(Date.now.formatted()) =====\n"
        return result
    }
    
    func storePersistentPages() {
        self.persistencePages = try? JSONEncoder().encode(self.pages)
    }
    
    init() {
        guard let persistencePages = persistencePages, let pages = try? JSONDecoder().decode([RegexBuilderLine].self, from: persistencePages) else {
            return
        }
        self.pages = pages
    }
    
    // MARK: - Private
}

#endif // os(iOS) || os(macOS)
