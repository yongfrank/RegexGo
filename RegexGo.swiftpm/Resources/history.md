**❓What is Regex - /WWDC[\d]{0,4}/gi**

> [Validation With Regex in Swift 5.7 Using SwiftUI and Combine](https://betterprogramming.pub/validation-with-regex-before-ios-16-using-swiftui-and-combine-567817909d1)

🕰️ You can trace the history of Regex back to an American mathematician, Stephen Cole Kleene, who proposed the idea of text representing patterns using mathematical expressions of sorts in 1951. However, his work did not take off until Ken Thompson decided to use it in his editors QED and ED in 1967, running under UNIX, the forerunning of OSX, iOS, and Android.

Although you could argue that the brevity of Regex expressions almost certainly influenced the syntax of one of the most popular programming languages in the world, namely C, which didn’t come out until 1972. A forerunning to Objective C and now Swift.

Although Regex didn’t find its way into the C language, it got incorporated into dozens of UNIX utilities like grep, awk, and vi — and most modern programming languages. So, it is somewhat surprising [at least for me] that it took almost forty years for Apple to adopt Regex in Objective C, waiting until 2010.

而又過了 10 年之後，Apple 在 WWDC2022 重寫了 Regex 語法，讓使用者用起來更方便。在這篇文章中，我會帶大家用更現代的 Regex 更新 Validate Passwords in SwiftUI Forms Using Combine 和 Data Validation in SwiftUI 2.0 這兩篇文章。不過，我會盡量使用新命令框架 (command framework) 內的原始語法。

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