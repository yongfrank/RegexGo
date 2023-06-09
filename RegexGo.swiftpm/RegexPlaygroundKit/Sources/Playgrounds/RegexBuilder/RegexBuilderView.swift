//
//  RegexBuilderView.swift
//
//
//  Created by Chu Yong on 4/12/23.
//

import SwiftUI
import AVKit

struct RegexBuilderView: View {
    
    @StateObject var vm = RegexLinesViewModel()
    @State var bracketIndent = 0
    
    @State private var text = ""
    @State private var showSheet = false

    @AppStorage("lookUpText") private var lookUpText = "my email is wwdc.23@developer.com, or you can mail to dont.wait.and.go.to@apple.park for more help"
    @State private var insertPosition: RegexBuilderLine?
    @State private var fileterKeyword = ""
    
    @AppStorage("isShowTerminal") private var isShowTerminal = false
    
    @EnvironmentObject var model: RegexPlaygroundsModel
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                SectionView(needPadding: false, borderType: .inside) {
                    TextField("Filter Text", text: $lookUpText, axis: .vertical)
                        .textFieldStyle(.noBorderCaptitalizedAutoCorrection)
                        .padding(5)
                        .focused($keyboardState)
                }
                .onAppear {
                    if model.playtimes == 0 {
                        isShowHelp = true
                        self.model.playtimes += 1
                    }
                }
                
                SectionView(title: "🏗️ Builder Area", needPadding: false, borderType: .inside, isTitlePositionTop: true) {
                    ScrollView {
                        draggableGrid
                    }
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
                
                if isShowTerminal {
                    SectionView(title: "🕹️ Terminal", needPadding: false, borderType: .inside, isTitlePositionTop: true) {
                        TextEditor(text: self.$text)
                            .focused($keyboardState)
                    }
                    .transition(.move(edge: .trailing))
                }
                
            }
            SectionView(title: "🕹️ Terminal is Here~",needPadding: false, borderType: .none) {
                Toggle(isOn: $isShowTerminal) {
                    Image(systemName: "terminal")
                    //                    .overlay(Rou)
                }
                .toggleStyle(.button)
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done🫣") {
                    keyboardState = false
                }
            }
        }
//        .sheet(isPresented: $isShowHelp) {
//            VideoPlayerView(player: AVPlayer(url: Bundle.main.url(forResource: "help", withExtension: "mp4")!))
//        }
        .fullScreenCover(isPresented: $isShowHelp) {
            VideoPlayerView(player: AVPlayer(url: Bundle.main.url(forResource: "help", withExtension: "mp4")!))
                .ignoresSafeArea()
        }
    }
    
    @FocusState private var keyboardState: Bool
    
    // MARK: - local variables
    let columns = Array(repeating: GridItem(.flexible(), spacing: 45), count: 1)
    var terminalSection = SectionView {}
    
    // MARK: - Slices
    var draggableGrid: some View {
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
                        .padding(.leading,
                                 (CGFloat(page.count(pages: vm.pages)) - 1) * 20
                        )
                    
                    Spacer()
                }
                .contentShape(Rectangle())
                // https://stackoverflow.com/questions/62733633/swiftui-tapgesture-and-longpressgesture-in-scrollview-with-tap-indication-not-wo
                // https://developer.apple.com/forums/thread/127277
                .onTapGesture {}
                .onLongPressGesture {
                    self.insertPosition = page
                    showSheet.toggle()
                }
                .padding(8)
            }
        }
    }
    @State private var isShowHelp = false
    var toolBarButtons: some View {
        Group {
            Button {
                showSheet.toggle()
            } label: {
                Image(systemName: "plus")
            }

//            Button {
//                self.vm.pages.append(.init(regexString: .captureLeft))
//                self.vm.pages.append(.init(regexString: .captureRight))
//            } label: {
//                Image(systemName: "quote.opening")
//            }
            Button {
                if self.text.isEmpty {
                    model.addCompletionProgress(selection: Panel.pageSource(.secondPage))
                }
                self.text = vm.printAllStr(pages: vm.pages, text: self.lookUpText) + "\n" + self.text
                self.isShowTerminal = true
            } label: {
                Image(systemName: "printer")
            }
            Button {
                self.isShowHelp.toggle()
            } label: {
                Image(systemName: "questionmark.circle")
            }

//            Button {
//                withAnimation {
//                    self.text = ""
//                }
//            } label: {
//                Image(systemName: "trash")
//            }
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
