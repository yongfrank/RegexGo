//
//  main.swift
//  RegexTester
//
//  Created by Chu Yong on 4/13/23.
//

import Foundation
import RegexBuilder

print("Hello, World!")

func regexSearch(for pattern: String, in text: String) -> String {
    var result = ""
    
    guard let regexComponent = try? /\/(.*)\//.firstMatch(in: pattern)?.1,
            let regexpattern = try? Regex(String(regexComponent))
    else { return "Component Error"}
    
    print(text, regexComponent)
    
    let findedResult = text.matches(of: regexpattern)
    result += "\n===== 🤯 Result Area =====\n"
    for match in findedResult {
        result += "\(match.0)\n"
    }
    result += "===== 🤯 Result Area =====\n"
    return result
}

func regexSearch(in text: String) -> String {
    let pattern = Regex {
        OneOrMore {
            .digit
        }
    }
    
    var result = ""
    
    let findedResult = text.matches(of: pattern)
    result += "\n===== 🤯 Result Area =====\n"
    for match in findedResult {
        result += "\(match.0)\n"
    }
    result += "===== 🤯 Result Area =====\n"
    return result
}

print(regexSearch(for: "/apple/", in: "applee"))

print(regexSearch(in: "my email is myname.my@example11.com"))

/**
 
 let pattern = Regex {
     Capture {
         ZeroOrMore {
             OneOrMore {
                 .word
             }
             "."
         }
         OneOrMore {
             .word
         }
         
     }
     "@"
//        Capture {
         OneOrMore {
             .word
         }
     OneOrMore {
         "."
         OneOrMore {
             .word
         }
         OneOrMore {
             .digit
         }
     }
         
//        }
 };
 */
