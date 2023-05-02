//
//  BlankPage.swift
//  
//
//  Created by Chu Yong on 4/5/23.
//

import SwiftUI
import RegexBuilder

struct BlankPage: View {
    @State private var regexResearch: String = #"/(CREDIT|DEBIT)\s+(\d{1,2}\/\d{1,2}\/\d{4})/"#
    @State private var resultText: String = "nil"
    @EnvironmentObject var model: RegexPlaygroundsModel
    
    // https://developer.apple.com/documentation/regexbuilder
    @State private var transactionOfView = """
    KIND      DATE          INSTITUTION                AMOUNT
    ----------------------------------------------------------------
    CREDIT    03/01/2022    Payroll from employer      $200.23
    CREDIT    03/03/2022    Suspect A                  $2,000,000.00
    ?????     03/03/2022    Ted's Pet Rock Sanctuary   $2,000,000.00
    DEBIT     03/05/2022    Doug's Dugout Dogs         $33.27
    DEBIT     06/03/2022    Oxford Comma Supply Ltd.   £57.33
    """
    
    private enum Field: Int, CaseIterable {
        case regex, input, output
    }
    
    @FocusState private var focusedField: Field?
    
    var body: some View {
        VStack {
            SectionView(needPadding: false, borderType: .inside) {
                TextField("regex", text: $regexResearch, axis: .vertical)
//                    .textFieldStyle(.noReturnTextFieldStyle)
                    .font(.body.monospaced())
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .focused($focusedField, equals: .regex)
                    .padding(5)
            }
            
            SectionView(title: "📊 Data Area ✍️", needPadding: false, borderType: .inside) {
                TextEditor(text: $transactionOfView)
                    .foregroundColor(.secondary)
                    .font(.custom("HelveticaNeue", size: 10))
                    .monospaced()
                    .focused($focusedField, equals: .input)
            }
//            TextEditor(text: $regexResearch)
//                .font(.body.monospaced())
            
            SectionView(title: "🏷️ Regex Result Area ✍️", needPadding: false, borderType: .inside) {
                TextEditor(text: $resultText)
                    .monospaced()
                    .font(.caption2)
                    .focused($focusedField, equals: .output)
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Button("CREDIT 💳") {
                    self.regexResearch = #"/(CREDIT)\s+(\d{1,2}\/\d{1,2}\/\d{4}).*/"#
                }
                Button("DEBIT 🏦") {
                    self.regexResearch = #"/(DEBIT)\s+(\d{1,2}\/\d{1,2}\/\d{4}).*/"#
                    model.addCompletionProgress(selection: Panel.pageSource(.firstPage))
                }
                Spacer()
                Button("Done🫣") {
                    focusedField = nil
                }
            }
        }
        .onAppear {
            regexStartSearch()
        }
        .onChange(of: regexResearch) { _ in
            regexStartSearch()
        }
    }
    
    let transaction = """
KIND      DATE          INSTITUTION                AMOUNT
----------------------------------------------------------------
CREDIT    03/01/2022    Payroll from employer      $200.23
CREDIT    03/03/2022    Suspect A                  $2,000,000.00
?????     03/03/2022    Ted's Pet Rock Sanctuary   $2,000,000.00
DEBIT     03/05/2022    Doug's Dugout Dogs         $33.27
DEBIT     06/03/2022    Oxford Comma Supply Ltd.   £57.33
"""
    let research = /(CREDIT|DEBIT)\s+(\d{1,2}\/\d{1,2}\/\d{4})/
    
    func regexStartSearch() {
//        let regexOfDelimiter = Regex {
//            "/"
//            Capture {
//                OneOrMore(.any)
//                OneOrMore {
//                    .word
//                    "hi"
//                }
//            }
//            "/"
//        }
        let anotherRegexDelimiter = /\/(.*)\//
        let contentRegexString = regexResearch.firstMatch(of: anotherRegexDelimiter)
//        let contentRegexString = regexResearch.firstMatch(of: regexOfDelimiter)
        guard
            let contentRegexString = contentRegexString?.1,
            let regex =
                try? Regex(String(contentRegexString))
//                try? Regex(self.regexResearch)
        else {
            self.resultText = "Error Regex"
            return
        }

        self.resultText = ""
        let results = transactionOfView.matches(of: regex)
        for result in results {
            self.resultText += "\(result.0)\n"
        }
    }
}

struct BlankPage_Previews: PreviewProvider {
    static var previews: some View {
        BlankPage()
    }
}

extension TextFieldStyle where Self == NoReturnTextFieldStyle {
    static var noReturnTextFieldStyle: NoReturnTextFieldStyle {
        NoReturnTextFieldStyle()
    }
}

struct NoReturnTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
//            .submitLabel(.search)
            .font(.body.monospaced())
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .textFieldStyle(.roundedBorder)
    }
}

extension TextFieldStyle where Self == NoBorderCaptitalizedAutoCorrection {
    static var noBorderCaptitalizedAutoCorrection: NoBorderCaptitalizedAutoCorrection {
        NoBorderCaptitalizedAutoCorrection()
    }
}

struct NoBorderCaptitalizedAutoCorrection: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
//            .submitLabel(.search)
            .font(.body.monospaced())
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
    }
}
