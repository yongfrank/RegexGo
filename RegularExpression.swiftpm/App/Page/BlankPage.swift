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
    var body: some View {
        VStack {
            TextEditor(text: $transactionOfView)
                .foregroundColor(Color.gray)
                .font(.custom("HelveticaNeue", size: 13))
                .lineSpacing(5)
            
            TextField("regex", text: $regexResearch)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .textFieldStyle(.roundedBorder)
                .padding()
            TextEditor(text: $resultText)
//                .onAppear {
//                    let results = transaction.matches(of: research)
//                    print("=========")
//                    for result in results {
//                        print(result.1, result.2)
//                    }
//                }
        }
        .onChange(of: regexResearch) { _ in
            print("\(Date.now) Changing")
            guard let regex = try? Regex(regexResearch) else {
                self.resultText = "Error Regex"
                return
            }
            self.resultText = ""
            let results = transactionOfView.matches(of: regex)
            for result in results {
                self.resultText += "\(result.0)\n"
            }
            print(results)
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
    
}

struct BlankPage_Previews: PreviewProvider {
    static var previews: some View {
        BlankPage()
    }
}
