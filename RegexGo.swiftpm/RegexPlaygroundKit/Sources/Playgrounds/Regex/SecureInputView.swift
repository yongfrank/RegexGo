//
//  SecureInputView.swift
//  https://stackoverflow.com/questions/63095851/show-hide-password-how-can-i-add-this-feature
//
//  Created by Chu Yong on 4/16/23.
//

import SwiftUI

struct SecureInputView: View {
    
    @Binding private var text: String
    @State private var isSecured: Bool = true
    private var title: String
    
    init(_ title: String, text: Binding<String>) {
        self.title = title
        self._text = text
    }
        
    var body: some View {
        SectionView(needPadding: false, borderType: .inside) {
            ZStack(alignment: .trailing) {
                Group {
                    if isSecured {
                        SecureField(title, text: $text)
                    } else {
                        TextField(title, text: $text)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                    }
                }
                .padding(.trailing, 32)
                Button(action: {
                    isSecured.toggle()
                }) {
                    
                    // https://stackoverflow.com/questions/72568296/sf-symbol-images-different-sizes
                    
                    Image(systemName: self.isSecured ? "eye.slash" : "eye")
                        .accentColor(.gray)
                }
            }
            .padding(5)
        }
    }
}
struct SecureInputView_Previews: PreviewProvider {
    struct Preview: View {
        @State private var pwd = ""
        var body: some View {
            SecureInputView("Enter your password", text: $pwd)
        }
    }
    static var previews: some View {
        Preview()
    }
}
