//
//  PasswordView.swift
//  
//
//  Created by Chu Yong on 4/5/23.
//

import SwiftUI
import RegexBuilder

struct PasswordView: View {
    @State var passText = ""
    @State var diagMsgs = [Diag]()
    var body: some View {
        VStack {
            TextField("Pass ", text: self.$passText)
                .onChange(of: self.passText) { newValue in
                    diagMsgs.removeAll()
                    self.matchRegex()
                    if passText.isEmpty {
                        diagMsgs.removeAll()
                    }
                }
                .textFieldStyle(.roundedBorder)
                .padding(.top, 64)
            displaceFailedMatches()
        }
    }
    
    fileprivate func matchRegex() {
        for rule in Rules.allCases {
            guard let formulae = try? Regex(rule.rawValue) else { return }
            if let _ = self.passText.wholeMatch(of: formulae) {
                
            } else {
                let diag = Crips.cripList[rule.ordinal()]
                self.diagMsgs.append(Diag(message: "\(diag)"))
//                let a: Regex<Substring> = /wwdc/
//                let foo = /\a/
//                print(foo)
            }
        }
    }
    
    // Now, the second function displays a console-like diagnostics list
    // that will scroll off the screen if it gets too big.
    fileprivate func displaceFailedMatches() ->
        ScrollViewReader<ScrollView<VStack<some View>>> {
            ScrollViewReader { moveTo in
                ScrollView(.vertical) {
                    VStack(alignment: .leading) {
                        ForEach(diagMsgs, id: \.id) { text in
                            Text("\(text.message)")
                                .id(text.id)
                        }
//                        .onChange(of: diagMsgs) { newValue in
//                            moveTo.scrollTo(diagMsgs.last?.id, anchor: .bottom)
//                        }
                    }
                }
            }
    }
}

struct PasswordView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordView()
    }
}
