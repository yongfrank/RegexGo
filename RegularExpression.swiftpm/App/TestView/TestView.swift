//
//  TestView.swift
//  
//
//  Created by Chu Yong on 4/12/23.
//

import SwiftUI
import WebKit

struct TestView: View {
    
    let columns = Array(repeating: GridItem(.flexible(), spacing: 45), count: 2)
    @StateObject var vm = PageViewModel()
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(vm.pages, id: \.self) { page in
                    WebView(url: page.url)
                        .frame(height: 200)
                        .cornerRadius(15)
                        .onDrag {
                            return NSItemProvider(contentsOf: URL(string: "\(page.id)")!)!
                        }
                        .onDrop(of: [.url], delegate: DropViewDelegate())
                }
            }
        }
    }
}

struct DropViewDelegate: DropDelegate {
    func performDrop(info: DropInfo) -> Bool {
        return true
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
    var url: URL
    var id = UUID().uuidString
    
    static var PAGESEXAMPLE: [Page] = [
        Page(url: URL(string: "https://www.twitter.com")!),
        Page(url: URL(string: "https://www.gmail.com")!),
        Page(url: URL(string: "https://www.instagram.com")!),
        Page(url: URL(string: "https://www.twitter.com")!),
        Page(url: URL(string: "https://www.facebook.com")!),
        Page(url: URL(string: "https://www.apple.com")!),
        Page(url: URL(string: "https://www.facebook.com")!)
    ]
}

class PageViewModel: ObservableObject {
    @Published var pages = Page.PAGESEXAMPLE
}


struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
            .preferredColorScheme(.dark)
    }
}
