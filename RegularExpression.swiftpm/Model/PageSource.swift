//
//  PageSource.swift
//  
//
//  Created by Chu Yong on 4/9/23.
//

import Foundation

/// An enum that represents the person's selection in the app's sidebar.
enum PageSource: String, CaseIterable {
    case firstPage = "FirstPage"
    case readme = "README"
    case history = "history"
}

extension PageSource: CustomStringConvertible {
    var description: String {
        return self.rawValue
    }
}
