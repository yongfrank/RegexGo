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
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(vm.pages, id: \.self) { page in
                        HStack {
                            Text(page.text)
                                .background(.red)
                                .cornerRadius(30)
                                .padding(.leading, 5)
                                .opacity(self.vm.currentDragPage?.id == page.id ? 0.01 : 1)
                                .onDrag {
                                    self.vm.currentDragPage = page
                                    return NSItemProvider(contentsOf: URL(string: "\(page.id)")!)!
                                }
                                .onDrop(of: [.url], delegate: DropViewDelegate(currentDropPage: page, pageData: vm))
                            Spacer()
                        }
                        .contentShape(Rectangle())
//                        .onLongPressGesture {
//                            print("Loong")
//                        }
                        .padding(.horizontal)
                    }
                }
                .onDrop(of: [.url], delegate: DropOutsideDelegate(pageData: vm))
                .background(.gray)
            }
        }
    }
}

struct DropOutsideDelegate: DropDelegate {
    var pageData: PageViewModel
        
    func performDrop(info: DropInfo) -> Bool {
        pageData.currentDragPage = nil
        return true
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
                let fromPage = pageData.pages[fromIndex]
                let toPage = pageData.pages[toIndex]
                pageData.pages[fromIndex] = toPage
                pageData.pages[toIndex] = fromPage
            }
        }
        print(fromIndex, toIndex)
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
struct Page: Hashable, Identifiable {
    var id = UUID().uuidString
    var text: String
    
    static var PAGESEXAMPLE: [Page] = [
        Page(text: "Capture {"),
        Page(text: ".word"),
        Page(text: "\"apple\""),
        Page(text: "\"google\""),
        Page(text: "\"twitter\""),
        Page(text: "\"facebook\""),
        Page(text: "}")
    ]
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
}
