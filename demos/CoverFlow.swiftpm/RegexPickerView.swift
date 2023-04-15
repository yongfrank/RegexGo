//
//  RegexPickerView.swift
//  CoverFlow
//
//  Created by Chu Yong on 4/14/23.
//

import SwiftUI

enum AddPicker: String, CaseIterable {
    case custom
    case normal
}

enum PickerDetail: String, CaseIterable {
    case word
    case digit
    case capture
    case normalText
    case regexCurlyBracket
    case oneOrMore
    case zeroOrMore
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
        case .regexCurlyBracket:
            return [.regexLeft, .regexRight]
        case .oneOrMore:
            return [.oneOrMoreLeft, .oneOrMoreRight]
        case .zeroOrMore:
            return [.zeroOrMoreLeft, .zeroOrMoreRight]
        case .digit:
            return [.digit]
        }
    }
    
    var displayName: String {
        switch self {
        case .word:
            return "🉑 .word: Single Character"
        case .capture:
            return "🕸️ Capture { }"
        case .normalText:
            return "🔤 Normal Text"
        case .digit:
            return "🔢 .digit"
        case .regexCurlyBracket:
            return "🪄 Regex { }"
        case .oneOrMore:
            return "OneOrMore { }"
        case .zeroOrMore:
            return "ZeroOrMore { }"
        }
    }
}

struct RegexPickerView: View {
    @Binding var showSheet: Bool
    @Binding var fileterKeyword: String
    @Binding var insertPosition: RegexBuilderLine?
    
    @ObservedObject var vm: RegexLinesViewModel
    
    @State private var sheetCategory = AddPicker.normal

    var body: some View {
        NavigationStack {
            List {
                ForEach(PickerDetail.allCases, id: \.self) { picDetail in
                        Button {
                            withAnimation {
                                builderChoosed(picDetail: picDetail) {
                                    self.insertPosition = nil
                                }
                            }
                        } label: {
                            HStack {
                                Text(picDetail.displayName)
                                    .font(.body.monospaced())
                                if picDetail == .normalText {
                                    TextField("Filter keyword", text: $fileterKeyword, axis: .vertical)
                                        .textFieldStyle(.noReturnTextFieldStyle)
                                }
                            }
                        }
                    }
                    .padding()
//                            .frame(minHeight: 200)
            }
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Picker("Choose", selection: $sheetCategory) {
                        ForEach(AddPicker.allCases, id: \.self) { picker in
                            Text(picker.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            .navigationTitle("RegexBuilder")
        }
    }
    
    func builderChoosed(picDetail: PickerDetail, completion: () -> Void) {
        var insertIndex = self.vm.pages.count
        if self.insertPosition != nil {
            insertIndex = self.vm.pages.firstIndex { page in
                insertPosition?.id == page.id
            } ?? self.vm.pages.count
        }
        
        if picDetail == .normalText {
//            self.vm.pages.append(
//                .init(regexString: .normalString(rawV: fileterKeyword))
//            )
            self.vm.pages.insert(.init(regexString: .normalString(rawV: self.fileterKeyword)), at: insertIndex)
        } else {
            var pagesToBeInserted = [RegexBuilderLine]()
            for pic in picDetail.pickerInfo {
//                self.vm.pages.append(.init(regexString: pic))
//                self.vm.pages.insert(.init(regexString: pic), at: insertIndex + 1)
                pagesToBeInserted.append(.init(regexString: pic))
            }
            self.vm.pages.insert(contentsOf: pagesToBeInserted, at: insertIndex)
        }
        self.fileterKeyword = ""
        completion()
        showSheet.toggle()
    }
}

struct RegexPickerView_Previews: PreviewProvider {
    static var previews: some View {
        RegexPickerView(showSheet: .constant(true), fileterKeyword: .constant(""), insertPosition: .constant(nil), vm: RegexLinesViewModel())
    }
}
