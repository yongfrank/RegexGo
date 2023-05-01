//
//  SettingsView.swift
//  
//
//  Created by Chu Yong on 4/16/23.
//

import SwiftUI
import StoreKit

struct SettingsDescription {
    var url: URL
    var description: LocalizedStringKey
}

enum SettingsData {
    static let githubLink: SettingsDescription = .init(
        url: URL(string: "https://github.com/yongfrank/RegexGo")!,
        description: "🌟 Star My Repository on GitHub"
    )
    static let regexGoPress = SettingsDescription(
        url: URL(string: "https://yongfrank.github.io/regex-go/")!,
        description: "📖 Blog at yongfrank.github.com"
    )
}

struct SettingsView: View {
    @ObservedObject var model: RegexPlaygroundsModel
    @Binding var navigationSelection: PageSource
    
    @State private var isShowRelevantApp = false
    
    @State private var isShowAlert = false
    @State private var alertMessage: LocalizedStringKey = ""
    var body: some View {
        NavigationStack {
            Form {
                Section(LocalizedStringKey("About App 🤖")) {
                    Button(LocalizedStringKey("RESET APP")) {
                        isShowAlert.toggle()
                        self.alertMessage = "All the data in the app will be erased."
                    }
                    Button(LocalizedStringKey("CHANGE LANGUAGE")) {
                        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                            return
                        }

                        if UIApplication.shared.canOpenURL(settingsUrl) {
                            UIApplication.shared.open(settingsUrl, completionHandler: nil)
                        }
                    }
                    
                }
                
                Section(LocalizedStringKey("About Author 🧑‍💻")) {
                    Button("🚩 Relevant App: Oh My Flag") {
                        isShowRelevantApp.toggle()
                    }
                    // https://www.hackingwithswift.com/quick-start/swiftui/how-to-recommend-another-app-using-appstoreoverlay 6446227923 1440611372
                    .appStoreOverlay(isPresented: $isShowRelevantApp) {
                        SKOverlay.AppConfiguration(appIdentifier: "6446227923", position: .bottom)
                    }
                    
                    Link(SettingsData.githubLink.description, destination: SettingsData.githubLink.url)
                    
                    Link(SettingsData.regexGoPress.description, destination: SettingsData.regexGoPress.url)
                }
            }
            .monospaced()
            .alert("Attention ⚠️", isPresented: $isShowAlert) {
                Button("OK", role: .destructive) {
                    model.resetDefaults()
                    isShowAlert.toggle()
                }
            } message: {
                Text(alertMessage, comment: "Alert Message for Settings View, Clear all datas")
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    isShowRelevantApp = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    isShowRelevantApp = false
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    struct Settings: View {
        @StateObject var model = RegexPlaygroundsModel()
        @State var page: PageSource = .firstPage
        var body: some View {
            SettingsView(model: model, navigationSelection: $page)
        }
    }
    static var previews: some View {
        Settings()
    }
}
