//
//  File.swift
//  
//
//  Created by Chu Yong on 4/2/23.
//

import Combine
import SwiftUI

@MainActor
public class RegularExpressionModel: ObservableObject {
    @Published var progress: Double = 0.0
    @Published var columnVisibility = NavigationSplitViewVisibility.automatic
    @Published var colorScheme: ColorScheme = .dark
    private var cancellable: AnyCancellable?

    init() {
        startProgressUpdate()
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


    deinit {
        cancellable?.cancel()
    }
    
}
