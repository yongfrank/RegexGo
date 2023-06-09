//
//  RegexBuilderLine.swift
//  
//
//  Created by Chu Yong on 4/15/23.
//

import Foundation

enum RegexBuilderType: Codable {
    case regexLeft
    case regexRight
    case word
    case captureLeft
    case captureRight
    case normalString(rawV: String)
    case zeroOrMoreLeft
    case zeroOrMoreRight
    case oneOrMoreLeft
    case oneOrMoreRight
    case digit
    case oneOrMoreWord
    case oneOrMoreDigit
}

extension RegexBuilderType {
    
    var description: String {
        switch self {
        case .word:
            return "[a-zA-Z]"
        case .captureLeft:
            return "("
        case .captureRight:
            return ")"
        case .normalString(let rawV):
            return String(try! /["]?(.*)["]?/.firstMatch(in: rawV)?.1 ?? "")
        case .regexLeft:
            return "/"
        case .regexRight:
            return "/"
        case .zeroOrMoreLeft:
            return "["
        case .oneOrMoreLeft:
            return "["
        case .zeroOrMoreRight:
            return "]*"
        case .oneOrMoreRight:
            return "]+"
        case .digit:
            return "\\d"
        case .oneOrMoreWord:
            return "[a-zA-Z]+"
        case .oneOrMoreDigit:
            return "[0-9]+"
        }
    }
    
    var swiftRegex: String {
        switch self {
        case .word:
            return ".word"
        case .captureLeft:
            return "Capture {"
        case .captureRight:
            return "} // Capture"
        case .normalString(let rawV):
            return "\"\(rawV)\""
        case .regexLeft:
            return "Regex {"
        case .regexRight:
            return "};"
        case .zeroOrMoreLeft:
            return "ZeroOrMore {"
        case .zeroOrMoreRight:
            return "} // ZeroOrMore"
        case .oneOrMoreLeft:
            return "OneOrMore {"
        case .oneOrMoreRight:
            return "} // OneOrMore"
        case .digit:
            return ".digit"
        case .oneOrMoreWord:
            return "OneOrMore(.word)"
        case .oneOrMoreDigit:
            return "OneOrMore(.digit)"
        }
    }
}

struct RegexBuilderLine: Codable, Identifiable {
    var id = UUID().uuidString
    var regexString: RegexBuilderType
}

extension RegexBuilderLine {
    
    var text: String {
        regexString.swiftRegex
    }
    
    // Find Email Example
    static var PAGESEXAMPLE: [RegexBuilderLine] = [
        .init(regexString: .regexLeft),
        .init(regexString: .zeroOrMoreLeft),
        .init(regexString: .oneOrMoreWord),
        .init(regexString: .oneOrMoreDigit),
        .init(regexString: .normalString(rawV: ".")),
        .init(regexString: .zeroOrMoreRight),
        .init(regexString: .normalString(rawV: "@")),
        .init(regexString: .oneOrMoreWord),
        .init(regexString: .oneOrMoreLeft),
        .init(regexString: .normalString(rawV: ".")),
        .init(regexString: .oneOrMoreWord),
        .init(regexString: .oneOrMoreRight),
        .init(regexString: .regexRight),
    ]
    
    func remove(pages: inout [RegexBuilderLine]) {
        let line = pages.firstIndex { page in
            page.id == self.id
        } ?? 0
        
        pages.remove(at: line)
    }
    func count(pages: [RegexBuilderLine]) -> Int {
        let line = pages.firstIndex { page in
            page.id == self.id
        } ?? 0
        
        var outerBrackets = 0
        var depth = 0
        var index = 0
        
        for char in pages {
            if char.text.contains(/.*{/) {
                depth += 1
                if index == line {
                    depth -= 1
                    break
                }
            } else if char.text.contains(/.*}/) {
                depth -= 1
                if depth < 0 {
                    // 遇到了多余的右括号，将计数器减一
                    outerBrackets -= 1
                    depth = 0
                }
            }
            if index == line { break }
            index += 1
        }
//        print(self.text, line, outerBrackets)
        // 如果深度不为零，说明遇到了多余的左括号，将计数器加一
        if depth > 0 {
            outerBrackets += 1
        }
        return depth
    }
}
