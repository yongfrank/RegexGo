import SwiftUI

struct ContentView: View {
    var body: some View {
        RegexBuilderView()
    }
}
//
//  TestView.swift
//
//
//  Created by Chu Yong on 4/12/23.
//

import SwiftUI

struct RegexBuilderView: View {
    
    @StateObject var vm = RegexLinesViewModel()
    @State var bracketIndent = 0
    
    @State private var text = ""
    @State private var showSheet = false

    @AppStorage("lookUpText") private var lookUpText = "my email is myname.my@example.com"
    @State private var insertPosition: RegexBuilderLine?
    @State private var fileterKeyword = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                TextField("Filter Text", text: $lookUpText, axis: .vertical)
                    .textFieldStyle(.noReturnTextFieldStyle)
                    .padding(.horizontal)
                LazyVGrid(columns: columns) {
                    ForEach(vm.pages, id: \.id) { page in
                        HStack {
                            Text(page.text)
//                                .font(.largeTitle)
                                .monospaced()
                                .padding(.horizontal)
//                                .background(.red)
                                .opacity(self.vm.currentDragPage?.id == page.id ? 0.01 : 1)
                                .containerShape(RoundedRectangle(cornerRadius: 12))
                                .onDrag {
                                    self.vm.currentDragPage = page
                                    return NSItemProvider(contentsOf: URL(string: "\(page.id)")!)!
                                }
                                .onDrop(of: [.url], delegate: DropViewDelegate(currentDropPage: page, pageData: vm))
                                .gesture(TapGesture(count: 2).onEnded({ _ in
                                    withAnimation {
                                        page.remove(pages: &vm.pages)
                                    }
                                }))
                                .padding(.leading, CGFloat(page.count(pages: vm.pages)) * 20)
                            
                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .onLongPressGesture {
                            self.insertPosition = page
                            showSheet.toggle()
                            
                        }
                        .padding(.vertical, 5)
                    }
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(.gray, lineWidth: 5)
                )
                
                TextEditor(text: self.$text)
            }
            .scrollDismissesKeyboard(.interactively)
            .onDisappear(perform: {
                vm.storePersistentPages()
            })
            .onDrop(of: [.url], delegate: DropOutsideDelegate(pageData: vm))
            .toolbar {
                ToolbarItemGroup {
                    toolBarButtons
                }
            }
            .sheet(isPresented: $showSheet) {
                RegexPickerView(showSheet: $showSheet, fileterKeyword: $fileterKeyword, insertPosition: $insertPosition, vm: self.vm)
            }
        }
    }
    
    // MARK: - local variables
    let columns = Array(repeating: GridItem(.flexible(), spacing: 45), count: 1)
    
    // MARK: - Slices
    var toolBarButtons: some View {
        Group {
            Button {
                showSheet.toggle()
            } label: {
                Image(systemName: "plus")
            }

            Button {
                self.vm.pages.append(.init(regexString: .captureLeft))
                self.vm.pages.append(.init(regexString: .captureRight))
            } label: {
                Image(systemName: "quote.opening")
            }
            Button {
                self.text = vm.printAllStr(pages: vm.pages, text: self.lookUpText) + "\n" + self.text
            } label: {
                Image(systemName: "printer")
            }
            Button {
                withAnimation {
                    self.text = ""
                }
            } label: {
                Image(systemName: "trash")
            }
        }
    }
}

struct DropOutsideDelegate: DropDelegate {
    var pageData: RegexLinesViewModel
        
    func performDrop(info: DropInfo) -> Bool {
        pageData.currentDragPage = nil
        return true
    }
    func dropUpdated(info: DropInfo) -> DropProposal? {
        DropProposal(operation: .move)
    }
}

struct DropViewDelegate: DropDelegate {
    var currentDropPage: RegexBuilderLine
    var pageData: RegexLinesViewModel
    
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

enum RegexErrorCase: String {
    case noResult
}

extension RegexErrorCase {
    var errorDescription: String {
        switch self {
        case .noResult:
            return "No result"
        }
    }
}
