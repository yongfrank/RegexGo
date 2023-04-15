//
//  main.swift
//  CLIRegex
//
//  Created by Chu Yong on 4/9/23.
//

import Foundation

print("Hello, World!")

let search1 = /My name is (.+?) and I'm (\d+) years old./
//let search1 = try! Regex("My name is [.+?] and I'm [\\d+] years old.")
let greeting1 = "My name is Taylor and I'm 26 years old."

if let result = try? search1.wholeMatch(in: greeting1) {
//    print("Name: \(result.1)")
//    print("Age: \(result.2)")
    print(result)
}
