/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The detail column of the navigation interface.
*/

//
//  DetailColumn.swift
//  
//
//  Created by Chu Yong on 4/3/23.
//

/// The detail view of the app's navigation interface.
///
/// The ``ContentView`` presents this view in the detail column on macOS and iPadOS, and in the navigation stack on iOS.
/// The superview passes the person's selection in the ``Sidebar`` as the ``selection`` binding.
import SwiftUI

struct DetailColumn: View {
    /// The person's selection in the sidebar.
    ///
    /// This value is a binding, and the superview must pass in its value.
    @Binding var selection: Panel?
    
    /// The app's model the superview must pass in.
    @ObservedObject var model: RegexPlaygroundsModel
    
    /// The body function
    ///
    /// This view presents the appropriate view in response to the person's selection in the ``Sidebar``. See ``Panel``
    /// for the views that ``DetailColumn``  presents.
    var body: some View {
        switch selection ?? .pageSource(.welcome) {
        case .pageSource(let page):
            switch page {
            case .welcome:
                WelcomePageView(model: model, navigationSelection: pageSourceBinding)
                    .padding(.horizontal)
            case .firstPage:
                FirstPage(model: model, navigationSelection: pageSourceBinding)
                    .padding(.horizontal)
            case .secondPage:
                SecondPage(model: model, navigationSelection: pageSourceBinding)
                    .padding(.horizontal)
            }
        case .regexPlayground:
            SectionView(title: Panel.regexPlayground.panelName, needPadding: false, borderType: .none, isTitlePositionTop: true) {
                BlankPage()
//                SecondPage()
            }
            .padding(.horizontal)
        case .regexBuilder:
            SectionView(title: Panel.regexBuilder.panelName, needPadding: false, borderType: .none, isTitlePositionTop: true) {
                RegexBuilderView()
            }
            .padding(.horizontal)
        case .settings:
            SettingsView(model: model, navigationSelection: pageSourceBinding)
        }
    }
    
    private var pageSourceBinding: Binding<PageSource> {
        Binding<PageSource>(
            get: {
                switch selection {
                case .pageSource(let page):
                    return page
                default:
                    return .firstPage
                }
            },
            set: { newValue in
                selection = .pageSource(newValue)
            }
        )
    }
}

struct DetailColumn_Previews: PreviewProvider {
    struct Preview: View {
        @State private var selection: Panel? = .pageSource(.welcome)
        @StateObject private var model = RegexPlaygroundsModel()
        var body: some View {
            DetailColumn(selection: $selection, model: model)
        }
    }
    static var previews: some View {
        Text("Hello, world!")
    }
}
