## Deadline April 20, 2023, at 14:59 p.m UTC+8

Swift Student Challenge Submission

Submit your information to the Swift Student Challenge by April 19, 2023, at 11:59 p.m. PDT.

PDT: UTC-07:00

### Requirements

Your app playground must be built with and run on Swift Playgrounds 4.2.1 or later (requires iPadOS 16 or macOS 13) or Xcode 14 on macOS 13. You may incorporate the use of Apple Pencil.

## Idea

拖动 SwiftUI Regex 来完成效果？

## Background

正则表达式在生活中有很多应用场景，例如：

* 邮箱、电话号码、身份证号码等格式的校验
* 文本编辑器中的查找和替换功能
* 网页爬虫中的数据提取
* 命令行工具中的字符串处理
* 数据库查询中的模糊匹配
* 编程语言中的字符串匹配、替换、分割等操作

等等。总的来说，正则表达式在数据处理、文本处理、信息提取等方面有着广泛的应用。

## Research

* [How to use regular expressions in Swift]
* [Advanced regular expression matching with NSRegularExpression](https://www.hackingwithswift.com/articles/154/advanced-regular-expression-matching-with-nsregularexpression)
* [Learn Regex - GitHub][Learn Regex]
* [Regex](https://developer.apple.com/documentation/swift/regex)
* [hws - regex]
* [Meet Swift Regex](https://developer.apple.com/videos/play/wwdc2022/110357/)
* [Validation With Regex in Swift 5.7 Using SwiftUI and Combine](https://betterprogramming.pub/validation-with-regex-before-ios-16-using-swiftui-and-combine-567817909d1)

> * [hws - How to add advanced text styling using AttributedString](https://www.hackingwithswift.com/quick-start/swiftui/how-to-add-advanced-text-styling-using-attributedstring)
> * [hws - How to render Markdown content in text](https://www.hackingwithswift.com/quick-start/swiftui/how-to-render-markdown-content-in-text)
> * [Using Markdown in SwiftUI](https://www.appcoda.com/swiftui-markdown/)
> * [AttributedString](https://www.fatbobman.com/posts/attributedString/)
> * [🌟正则表达式介绍及常见用法](https://developer.aliyun.com/article/254339?spm=a2c6h.13262185.profile.340.699e167e7REVuk)
> * [正则表达式possessive、greediness和laziness区别](https://github.com/pro648/tips/blob/master/sources/%E6%AD%A3%E5%88%99%E8%A1%A8%E8%BE%BE%E5%BC%8Fpossessive%E3%80%81greediness%E5%92%8Claziness%E5%8C%BA%E5%88%AB.md)
> * [⭐️ Swift 5.7：應用新的 Regex 語法　在 SwiftUI 和 Combine 驗證使用者的輸入](https://www.appcoda.com.tw/swift-5-7-regex/)

[How to use regular expressions in Swift]: https://www.hackingwithswift.com/articles/108/how-to-use-regular-expressions-in-swift

[Learn Regex]: https://github.com/ziishaned/learn-regex/blob/master/translations/README-cn.md
[🌟 hws - regex]: https://www.hackingwithswift.com/swift/5.7/regexes

## Regex Example

```regex
((-|\+)?\d+(\.\d+)?)(rpx|px|%)

这个正则表达式可以匹配字符串中的数字，包括正数、负数、小数和整数，以及可选的单位（rpx、px或%）。具体来说：

* (-|+)? 表示可选的正负号；
* \d+ 表示一到多个数字；
* (.\d+)? 表示可选的小数部分，其中 . 表示小数点；
* (rpx|px|%) 表示单位，其中 | 表示或，rpx、px和 % 分别表示不同的单位。

这个正则表达式可以用于从文本中提取数字，并根据单位进行转换或处理。
```

```regex
^\*
> *

markdown
```

## [Learn Regex]

> A regular expression is a group of characters or symbols which is used to find a specific pattern in a text.

![regexp](https://github.com/ziishaned/learn-regex/raw/master/img/regexp-cn.png)

### Meta Characters

```regex
^: Start Sign, asserts position at start of a line
[]: required
{}: {3,200} matches the previous token between 3 and 200 times, as many times as possible, giving back as needed (greedy)
$: asserts position at the end of a line
\: Escapes the next character. This allows you to match reserved characters `[ ] ( ) { } . * + ? ^ $ \ |`
```

### Shorthand Character Sets

<!-- markdownlint-disable md010 -->
```regex
.	Any character except new line
\w	Matches alphanumeric characters: [a-zA-Z0-9_]
\W	Matches non-alphanumeric characters: [^\w]
\d	Matches digits: [0-9]
\D	Matches non-digits: [^\d]
\s	Matches whitespace characters: [\t\n\f\r\p{Z}]
\S	Matches non-whitespace characters: [^\s]
```

### Lookarounds

### Flags

```regex
i	忽略大小写。
g	全局搜索。
m	多行修饰符：锚点元字符 ^ $ 工作范围在每行的起始。
```

### Greedy vs Lazy Matching

### Unicode

* Character 字符
* Character Set 字符集
* Character Encoding 字符编码，比特 bit 0 1

码位（放置字符），码空间

* GB2312 2^8 = 256 2^16 = 65536
* GBKuozhan
* Unicode: UTF-8

## Errors

[Regex literals in Swift Packages](https://developer.apple.com/forums/thread/719108)