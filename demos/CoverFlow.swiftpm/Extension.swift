//
//  Extension.swift
//  CoverFlow
//
//  Created by Chu Yong on 4/13/23.
//

import Foundation
import SwiftUI

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
