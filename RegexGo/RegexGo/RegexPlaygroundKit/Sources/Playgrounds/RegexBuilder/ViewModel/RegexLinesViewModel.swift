//
//  RegexLinesViewModel.swift
//  CoverFlow
//
//  Created by Chu Yong on 4/14/23.
//

import Foundation
import SwiftUI

class RegexLinesViewModel: ObservableObject {
    @Published var pages = RegexBuilderLine.PAGESEXAMPLE {
        didSet {
            self.storePersistentPages()
        }
    }
    @Published var currentDragPage: RegexBuilderLine?
    @AppStorage("persistencePages") var persistencePages: Data?
    
    func printAllStr(pages: [RegexBuilderLine], text: String) -> String {
        var result = ""
        var resForRegex = ""
        for page in pages {
            resForRegex += page.regexString.description
        }
        guard let regexComponent = try? /\/(.*)\//.firstMatch(in: resForRegex)?.1, let regexpattern = try? Regex(String(regexComponent)) else { return "Component Error"}
        print(text, regexComponent)
        
        let findedResult = text.matches(of: regexpattern)
//        result += "\n===== 🤯 Result Area \(Date.now.formatted()) =====\n"
        result += Date().formatted(date: .numeric, time: .standard)
        result += ":\n"
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
}
