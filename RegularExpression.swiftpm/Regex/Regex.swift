//
//  Regex.swift
//  https://www.appcoda.com.tw/swift-5-7-regex/
//
//  Created by Chu Yong on 4/5/23.
//

import Foundation

struct Diag: Equatable {
//: Hashable, Codable, Identifiable {
    var id = UUID()
    var message = ""
}

enum Rules:String, CaseIterable {
    case alphaRule = "[A-Za-z]+"
    case digitRule = "[0-9]+"
    case limitedAlphaNumericCombined = "[A-Za-z0-9]{4,12}"
    case limitedAlphaNumericSplit = "[A-Za-z]{4,12}[0-9]{2,4}"
    case currencyRule = "(\\w*)[£$€]+(\\w*)"
    case wordRule = "(\\w+)"
    case numericRule = "(\\d+)"
    case numberFirst = "^(\\d+)(\\w*)"
    case numberLast = "(\\w*)(\\d+)$"
    case spaceRule = "[\\S]"
    case capitalFirst = "^[A-Z]+[A-Za-z]*"
    case punctuationCharacters = "[:punct:]"
}

enum Crips:String, CaseIterable {
    case alphaRule = "MUST be alpha only"
    case digitRule = "MUST be numeric ONLY"
    case limitRuleCombined = "MIN 4 AlphaNumeric MAX 12 AlphaNumeric"
    case limitRuleSplit = "START MIN 4 Alpha MAX 12 Alpha, FINISH MIN 2 numeric, MAX 4 numeric"
    case currencyRule = "MUST contain $£€"
    case wordRule = "MUST be alphanumeric"
    case numericRule = "MUST be numeric"
    case numberFirst = "MUST start with a number"
    case numberLast = "MUST finish with a number"
    case noSpaces  = "MUST not contain spaces or tabs"
    case leadingCapital = "MUST start with an uppercase letter"
    case punctuationCharacters = "MUST contain punctuation characters"
    
    static var cripList: [String] {
        return Crips.allCases.map { $0.rawValue }
    }
}

extension CaseIterable where Self: Equatable {
    public func ordinal() -> Self.AllCases.Index {
        return Self.allCases.firstIndex(of: self)!
    }
}
