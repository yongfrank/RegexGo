/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The regular expression model.
*/

//
//  RegularExpressionModel.swift
//  
//
//  Created by Chu Yong on 4/2/23.
//

import Combine
import SwiftUI
import MarkdownUI

@MainActor
public class RegexPlaygroundsModel: ObservableObject {
    @Published var progress: Double = 0.0
    @Published var columnVisibility = NavigationSplitViewVisibility.automatic
    @Published var colorScheme: ColorScheme? = .none
    @Published var isShowFirework = false
    
    @Published var completionProgress: [Panel] {
        didSet {
            if let encoded = try? JSONEncoder().encode(completionProgress) {
                UserDefaults.standard.set(encoded, forKey: "completionProgress")
            }
            progress = Double(completionProgress.count) / 3.0
        }
    }
    
    @Published var theme: ThemeOption = .docC
    
    @AppStorage("playtimes") var playtimes = 0
    
    private var cancellable: AnyCancellable?

    init() {
//        startProgressUpdate()
        
        // init completionProgress with data from user defaults
        if let savedCompletionProgress = UserDefaults.standard.data(forKey: "completionProgress") {
            if let decodedCompletionProgress = try? JSONDecoder().decode([Panel].self, from: savedCompletionProgress) {
                completionProgress = decodedCompletionProgress
                
                self.progress = Double(self.completionProgress.count) / 3.0
                return
            }
        }
        // Default to an empty array
        completionProgress = [Panel]()
    }

    private func startProgressUpdate() {
        cancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateProgress()
            }
    }

    private func updateProgress() {
        progress += 0.1
        if abs(progress - 1.0) < 0.0001 {
            progress = 1.0
            cancellable?.cancel()
        }
    }

    func resetDefaults() {
        withAnimation {
            self.completionProgress.removeAll()
            self.progress = 0
            self.playtimes = 0
        }
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }

    deinit {
        cancellable?.cancel()
    }
    
    func addCompletionProgress(selection: Panel) {
        if !self.completionProgress.contains(selection) {
            self.isShowFirework = true
            self.completionProgress.append(selection)
        }
    }
}

struct ThemeOption: Hashable {
  let name: String
  let theme: Theme

  static func == (lhs: ThemeOption, rhs: ThemeOption) -> Bool {
    lhs.name == rhs.name
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(self.name)
  }

  static let basic = ThemeOption(name: "Basic", theme: .basic)
  static let docC = ThemeOption(name: "DocC", theme: .docC)
  static let gitHub = ThemeOption(name: "GitHub", theme: .gitHub)

    static let themeOptions: [ThemeOption] = [.docC, .basic, .gitHub]
}
