//
//  WebView.swift
//  CoverFlow
//
//  Created by Chu Yong on 4/14/23.
//

import Foundation
import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    var url: URL
    
    func makeUIView(context: Context) -> some UIView {
        let view = WKWebView()
        view.load(URLRequest(url: url))
        view.isUserInteractionEnabled.toggle()
        
        // Scaling
        view.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
