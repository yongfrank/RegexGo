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
    @State private var transactionOfView = """
    KIND      DATE          INSTITUTION                AMOUNT
    ----------------------------------------------------------------
    CREDIT    03/01/2022    Payroll from employer      $200.23
    CREDIT    03/03/2022    Suspect A                  $2,000,000.00
    ?????     03/03/2022    Ted's Pet Rock Sanctuary   $2,000,000.00
    DEBIT     03/05/2022    Doug's Dugout Dogs         $33.27
    DEBIT     06/03/2022    Oxford Comma Supply Ltd.   £57.33
    """
    
    @FocusState private var isFocused: Bool
    var body: some View {
        VStack {
            TextField("regex", text: $regexResearch, axis: .vertical)
//                .onAppear {
//                    UITextField.appearance().clearButtonMode = .whileEditing
//                }
                .textFieldStyle(.noReturnTextFieldStyle)
//                .focused($isFocused)
//                .onSubmit {
//                    self.isFocused = false
//                }
            
            SectionView(title: "Data Area: Editable", needPadding: false, sectionType: .inside) {
                TextEditor(text: $transactionOfView)
                    .foregroundColor(.secondary)
                    .font(.custom("HelveticaNeue", size: 10))
                    .monospaced()
            }
//            TextEditor(text: $regexResearch)
//                .font(.body.monospaced())
            
            SectionView(title: "Regex Result Area: Editable", needPadding: false, sectionType: .inside) {
                TextEditor(text: $resultText)
                    .monospaced()
                    .font(.caption2)
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
            .submitLabel(.search)
            .font(.body.monospaced())
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .textFieldStyle(.roundedBorder)
    }
}
