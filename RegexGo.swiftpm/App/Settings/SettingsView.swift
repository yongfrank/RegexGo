//
//  SettingsView.swift
//  
//
//  Created by Chu Yong on 4/16/23.
//

import SwiftUI
import StoreKit

struct SettingsView: View {
    @ObservedObject var model: RegexPlaygroundsModel
    @Binding var navigationSelection: PageSource
    
    @State private var isShowRelevantApp = false
    
    @State private var isShowAlert = false
    @State private var alertMessage = ""
    var body: some View {
        NavigationStack {
            Form {
                Section("About App 🤖") {
                    Button("RESET APP") {
                        isShowAlert.toggle()
                        self.alertMessage = "All the data in the app will be erased."
                    }
                }
                
                Section("About Author 🧑‍💻") {
                    Button("Relevant App") {
                        isShowRelevantApp.toggle()
                    }
                    // https://www.hackingwithswift.com/quick-start/swiftui/how-to-recommend-another-app-using-appstoreoverlay 6446227923 1440611372
                    .appStoreOverlay(isPresented: $isShowRelevantApp) {
                        SKOverlay.AppConfiguration(appIdentifier: "6446227923", position: .bottom)
                    }
                }
            }
            .alert("Attention ⚠️", isPresented: $isShowAlert) {
                Button("OK", role: .destructive) {
                    model.resetDefaults()
                    isShowAlert.toggle()
                }
            } message: {
                Text(alertMessage)
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

//struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsView()
//    }
//}
