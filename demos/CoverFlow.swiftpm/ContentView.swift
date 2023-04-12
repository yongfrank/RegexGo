import SwiftUI

struct ContentView: View {
    var body: some View {
        TestView()
    }
}
//
//  TestView.swift
//
//
//  Created by Chu Yong on 4/12/23.
//

import SwiftUI
import WebKit

struct TestView: View {
    
    let columns = Array(repeating: GridItem(.flexible(), spacing: 45), count: 1)
    @StateObject var vm = PageViewModel()
    @State var bracketIndent = 0
    
    @State private var text = ""
    @State private var showSheet = false
    @State private var sheetCategory = AddPicker.normal
    
    @State private var fileterKeyword = ""
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(vm.pages, id: \.id) { page in
                        HStack {
                            Text(page.text)
                                .font(.largeTitle)
                                .monospaced()
                                .padding(.horizontal)
                                .background(.red)
                                .opacity(self.vm.currentDragPage?.id == page.id ? 0.01 : 1)
                                .containerShape(RoundedRectangle(cornerRadius: 12))
                                .onDrag {
                                    self.vm.currentDragPage = page
                                    return NSItemProvider(contentsOf: URL(string: "\(page.id)")!)!
                                }
                                .onDrop(of: [.url], delegate: DropViewDelegate(currentDropPage: page, pageData: vm))
//                                .onLongPressGesture(perform: {
//                                    withAnimation {
//                                        page.remove(pages: &vm.pages)
//                                    }
//                                })
                                .gesture(TapGesture(count: 2).onEnded({ _ in
                                    withAnimation {
                                        page.remove(pages: &vm.pages)
                                    }
                                }))
                                .padding(.leading, CGFloat(page.count(pages: vm.pages)) * 20)
                            Spacer()
                        }
//                        .contentShape(Rectangle())
//                        .onLongPressGesture {
//                            print("Loong")
//                        }
                        .padding(.vertical, 5)
                    }
                }
                .background(.gray)
                
                Text(self.text)
            }
            .onDrop(of: [.url], delegate: DropOutsideDelegate(pageData: vm))
            .toolbar {
                ToolbarItemGroup {
                    Button {
                        showSheet.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }

                    Button("add") {
                        self.vm.pages.append(.init(regexString: .captureLeft))
                        self.vm.pages.append(.init(regexString: .captureRight))
                    }
                    Button("print") {
                        self.text += vm.printAllStr(pages: vm.pages)
                        self.text += "\n"
                    }
                }
            }
            .sheet(isPresented: $showSheet) {
                NavigationView {
                    List {
                        ForEach(PickerDetail.allCases, id: \.self) { picDetail in
                            HStack {
                                if picDetail == .normalText {
                                    TextField("Filter keyword", text: $fileterKeyword)
                                }
                                
                                Button {
                                    if picDetail == .normalText {
                                        self.vm.pages.append(
                                            .init(regexString: .normalString(rawV: fileterKeyword)
                                            )
                                        )
                                    } else {
                                        for pic in picDetail.pickerInfo {
                                            self.vm.pages.append(.init(regexString: pic))
                                        }
                                    }
                                    showSheet.toggle()
                                } label: {
                                    Text(picDetail.displayName)
                                }
                                
                            }
                            .frame(minHeight: 200)
                        }
                    }
                    .listStyle(.plain)
                    .toolbar {
                        ToolbarItem {
                            Picker("Choose", selection: $sheetCategory) {
                                ForEach(AddPicker.allCases, id: \.self) { picker in
                                    Text(picker.rawValue)
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                    }
                }
            }
        }
    }
}

enum AddPicker: String, CaseIterable {
    case custom
    case normal
}

struct DropOutsideDelegate: DropDelegate {
    var pageData: PageViewModel
        
    func performDrop(info: DropInfo) -> Bool {
        pageData.currentDragPage = nil
        return true
    }
    func dropUpdated(info: DropInfo) -> DropProposal? {
        DropProposal(operation: .move)
    }
}


struct DropViewDelegate: DropDelegate {
    var currentDropPage: Page
    var pageData: PageViewModel
    
    func performDrop(info: DropInfo) -> Bool {
        self.pageData.currentDragPage = nil
        return true
    }
    
    func dropEntered(info: DropInfo) {
        if pageData.currentDragPage == nil {
            pageData.currentDragPage = currentDropPage
        }
        
        let fromIndex = pageData.pages.firstIndex { page in
            page.id == self.pageData.currentDragPage?.id
        } ?? 0
        let toIndex = pageData.pages.firstIndex { page in
            page.id == self.currentDropPage.id
        } ?? 0
        if fromIndex != toIndex {
            withAnimation {
//                let fromPage = pageData.pages[fromIndex]
//                let toPage = pageData.pages[toIndex]
//                pageData.pages[fromIndex] = toPage
//                pageData.pages[toIndex] = fromPage
                pageData.pages.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: toIndex > fromIndex ? toIndex + 1 : toIndex)
            }
        }
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        DropProposal(operation: .move)
    }
}

struct WebView: UIViewRepresentable {
    var url: URL
    
    func makeUIView(context: Context) -> some UIView {
        let view = WKWebView()
        view.load(URLRequest(url: url))
        view.isUserInteractionEnabled.toggle()
        
        // Scaling
        view.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

enum PickerDetail: String, CaseIterable {
    case word
    case capture
    case normalText
}

extension PickerDetail {
    var pickerInfo: [RegexBuilderType] {
        switch self {
        case .word:
            return [.word]
        case .capture:
            return [.captureLeft, .captureRight]
        case .normalText:
            return [.normalString(rawV: "default")]
        }
    }
    
    var displayName: String {
        switch self {
        case .word:
            return "word"
        case .capture:
            return "Capture { }"
        case .normalText:
            return "Normal Text"
        }
    }

}

enum RegexBuilderType: CaseIterable, Hashable {
    static var allCases: [RegexBuilderType] = [.word, .captureLeft, .captureRight, .normalString()]
    
    
    case word
    case captureLeft
    case captureRight
    case normalString(rawV: String = "default")
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
//        default:
//            return ""
        }
    }
    
    var swiftRegex: String {
        switch self {
        case .word:
            return "word"
        case .captureLeft:
            return "Capture {"
        case .captureRight:
            return "}"
        case .normalString(let rawV):
            return "\"\(rawV)\""
        }
    }
}

struct Page: Identifiable {
    
    var id = UUID().uuidString
    var text: String {
        regexString.swiftRegex
    }
    var regexString: RegexBuilderType = .word
    
    static var PAGESEXAMPLE: [Page] = [
        Page(regexString: .captureLeft),
        Page(regexString: .word),
        Page(regexString: .normalString(rawV: "apple")),
        Page(regexString: .normalString(rawV: "google")),
        Page(regexString: .normalString(rawV: "twitter")),
        Page(regexString: .normalString(rawV: "facebook")),
        Page(regexString: .captureRight)
    ]
    
    
}

extension Page {
    func remove(pages: inout [Page]) {
        let line = pages.firstIndex { page in
            page.id == self.id
        } ?? 0
        
        pages.remove(at: line)
    }
    func count(pages: [Page]) -> Int {
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
            } else if char.text == "}" {
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
        print(self.text, line, outerBrackets)
        // 如果深度不为零，说明遇到了多余的左括号，将计数器加一
        if depth > 0 {
            outerBrackets += 1
        }
        return depth
    }
}

//struct Page: Hashable, Identifiable {
//    var url: URL
//    var id = UUID().uuidString
//    var text: String {
//        url.absoluteString
//    }
//
//    static var PAGESEXAMPLE: [Page] = [
//        Page(url: URL(string: "https://www.twitter.com")!),
//        Page(url: URL(string: "https://www.gmail.com")!),
//        Page(url: URL(string: "https://www.instagram.com")!),
//        Page(url: URL(string: "https://www.twitter.com")!),
//        Page(url: URL(string: "https://www.facebook.com")!),
//        Page(url: URL(string: "https://www.apple.com")!),
//        Page(url: URL(string: "https://www.facebook.com")!)
//    ]
//}

class PageViewModel: ObservableObject {
    @Published var pages = Page.PAGESEXAMPLE
    @Published var currentDragPage: Page?
    
    func printAllStr(pages: [Page]) -> String {
        var result = ""
        for page in pages {
            result += page.regexString.description
        }
        return result
    }
}
