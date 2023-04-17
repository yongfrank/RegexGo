//
//  PasswordView.swift
//  
//
//  Created by Chu Yong on 4/5/23.
//

import SwiftUI
import RegexBuilder

// https://www.hackingwithswift.com/quick-start/swiftui/how-to-create-a-toggle-switch
struct PasswordFilterList: Identifiable, Equatable {
    var id: Rules
    var isSubscribed = false
}

struct PasswordView: View {
    @State var passText = "WelcomeToWWDC23"
    @State var diagMsgs = [Diag]()
    @State var ruleList = [PasswordFilterList]()
    
    var body: some View {
        VStack {
            SecureInputView("Enter the password for testing", text: $passText)
                .submitLabel(.done)
                .font(.body.monospaced())
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach($ruleList) { $rule in
                        Toggle(rule.id.name, isOn: $rule.isSubscribed)
                            .toggleStyle(.button)
                    }
                }
            }
            
            displaceFailedMatches()
        }
        .onAppear {
            for rule in Rules.passwordGameCases {
                if rule == .alphaRule {
                    self.ruleList.append(.init(id: rule, isSubscribed: true))
                } else {
                    self.ruleList.append(.init(id: rule))
                }
            }
            self.matchAgain()
        }
        .onChange(of: self.passText) { _ in
            self.matchAgain()
        }
        .onChange(of: ruleList) { _ in
            self.matchAgain()
        }
    }
    
    private func matchAgain() {
        self.diagMsgs.removeAll()
        self.matchRegex()
        if passText.isEmpty {
            diagMsgs.removeAll()
        }
    }
    
    fileprivate func matchRegex() {
        let choosedRule = ruleList.filter { rule in
            rule.isSubscribed
        }
        for rule in choosedRule {
            guard let formulae = try? Regex(rule.id.rawValue) else { return }
            if let _ = self.passText.wholeMatch(of: formulae) {
                
            } else {
                let diag = Crips.cripList[rule.id.ordinal()]
                self.diagMsgs.append(Diag(message: "\(diag)"))
            }
        }
        if diagMsgs.isEmpty {
            self.diagMsgs.append(Diag(message: "👍 Very Good, the password meets the requirements"))
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
                        .onChange(of: diagMsgs) { newValue in
                            moveTo.scrollTo(diagMsgs.last?.id, anchor: .bottom)
                        }
                    }
                }
            }
    }
}

struct PasswordView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PasswordView()
                .navigationTitle("Password")
        }
    }
}
